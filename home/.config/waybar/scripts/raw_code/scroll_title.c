#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MAX_LEN  40
#define GAP       8           /* spaces between end and start of scroll */
#define SLEEP_US  200000      /* 0.2 s */

/* ── UTF-8 helpers ───────────────────────────────────────────────────────── */

static int utf8_char_len(unsigned char c) {
    if ((c & 0x80) == 0x00) return 1;
    if ((c & 0xE0) == 0xC0) return 2;
    if ((c & 0xF0) == 0xE0) return 3;
    if ((c & 0xF8) == 0xF0) return 4;
    return -1;   /* invalid leading byte */
}

/*
 * Count the number of well-formed UTF-8 codepoints in s.
 * Invalid bytes are counted as 0 (they will be skipped).
 */
static int utf8_codepoint_count(const char *s) {
    int n = 0;
    for (const unsigned char *p = (const unsigned char *)s; *p; ) {
        int cl = utf8_char_len(*p);
        if (cl <= 0) { p++; continue; }          /* skip bad leading byte */
        /* verify continuation bytes */
        int ok = 1;
        for (int i = 1; i < cl; i++)
            if ((p[i] & 0xC0) != 0x80) { ok = 0; break; }
        if (!ok) { p++; continue; }
        n++;
        p += cl;
    }
    return n;
}

/* ── FIX 1: escape_markup now strips invalid UTF-8 ───────────────────────── */

/*
 * Copy `in` to `out` (max `size` bytes including NUL):
 *   - skip any byte that is not part of a valid UTF-8 sequence
 *   - XML-escape  &  <  >  for Pango markup
 */
static void escape_markup(const char *in, char *out, size_t size) {
    size_t j = 0;
    const unsigned char *p = (const unsigned char *)in;

    while (*p && j < size - 1) {
        /* validate the next UTF-8 character */
        int cl = utf8_char_len(*p);
        if (cl <= 0) { p++; continue; }          /* bad leading byte → skip */

        int ok = 1;
        for (int i = 1; i < cl; i++) {
            if ((p[i] & 0xC0) != 0x80) { ok = 0; break; }
        }
        if (!ok) { p++; continue; }               /* bad continuation → skip */

        /* single-byte: check for markup-special characters */
        if (cl == 1) {
            if (*p == '&') {
                if (j + 5 >= size) break;
                memcpy(out + j, "&amp;", 5); j += 5; p++; continue;
            }
            if (*p == '<') {
                if (j + 4 >= size) break;
                memcpy(out + j, "&lt;",  4); j += 4; p++; continue;
            }
            if (*p == '>') {
                if (j + 4 >= size) break;
                memcpy(out + j, "&gt;",  4); j += 4; p++; continue;
            }
        }

        /* copy the full multi-byte character */
        if (j + cl >= size) break;
        memcpy(out + j, p, cl);
        j  += cl;
        p  += cl;
    }

    out[j] = '\0';
}

/* ── window title retrieval ──────────────────────────────────────────────── */

static void get_title(char *buffer, size_t size) {
    buffer[0] = '\0';
    FILE *fp = popen("mmsg -g -c", "r");
    if (!fp) return;

    char line[512];
    while (fgets(line, sizeof(line), fp)) {
        char *ptr = strstr(line, "title");
        if (ptr) {
            ptr += 6;                           /* skip "title " */
            strncpy(buffer, ptr, size - 1);
            buffer[size - 1] = '\0';
            buffer[strcspn(buffer, "\n")] = '\0';
            break;
        }
    }
    pclose(fp);
}

/* ── FIX 2: scroll_text / period uses len + GAP ──────────────────────────── */

/*
 * Write MAX_LEN bytes (UTF-8 safe) starting at byte offset `pos` inside
 * the virtual string  "TEXT<GAP spaces>TEXT<GAP spaces>..." into `out`.
 *
 * The period of that virtual string is  strlen(text) + GAP,  which is
 * exactly what main() must use for its modulo so the gap is never skipped.
 */
static void scroll_text(const char *text, char *out, int pos) {
    /* build one full period: text + gap */
    char period_buf[1024];
    int  text_len = strlen(text);
    snprintf(period_buf, sizeof(period_buf), "%s%*s", text, GAP, "");
    int  period   = text_len + GAP;   /* true byte-length of one period */

    int  out_len  = 0;
    int  i        = pos % period;

    while (out_len < MAX_LEN) {
        /* wrap safely */
        if (i >= period) i = 0;

        /* gap region: emit a space */
        if (i >= text_len) {
            if (out_len + 1 > MAX_LEN) break;
            out[out_len++] = ' ';
            i = (i + 1) % period;
            continue;
        }

        unsigned char c  = (unsigned char)period_buf[i];
        int           cl = utf8_char_len(c);
        if (cl <= 0) { i++; continue; }          /* skip bad byte in source */
        if (i + cl > period) { i = 0; continue; }/* don't split across wrap  */
        if (out_len + cl > MAX_LEN) break;

        memcpy(out + out_len, period_buf + i, cl);
        out_len += cl;
        i = (i + cl) % period;
    }

    out[out_len] = '\0';
}

/* ── main loop ───────────────────────────────────────────────────────────── */

int main(void) {
    char title[512];
    char prev_title[512] = "";
    char temp[MAX_LEN + 64];   /* a bit of slack for escape expansion */
    char output[MAX_LEN + 64];
    int  pos = 0;

    while (1) {
        get_title(title, sizeof(title));

        /* reset scroll when the title changes */
        if (strcmp(title, prev_title) != 0) {
            pos = 0;
            strncpy(prev_title, title, sizeof(prev_title) - 1);
            prev_title[sizeof(prev_title) - 1] = '\0';
        }

        if (title[0] == '\0') {
            printf("{\"text\": \"\"}\n");
            fflush(stdout);
            usleep(SLEEP_US);
            continue;
        }

        int text_bytes = strlen(title);

        if (text_bytes <= MAX_LEN && utf8_codepoint_count(title) <= MAX_LEN) {
            /* title fits: no scrolling needed */
            escape_markup(title, output, sizeof(output));
        } else {
            /*
             * FIX 2: period is (text_bytes + GAP), not text_bytes.
             * The UTF-8 alignment nudge also stays within that range.
             */
            int period = text_bytes + GAP;
            pos = (pos + 1) % period;

            /* nudge forward past any UTF-8 continuation bytes */
            int safety = 0;
            while (pos < text_bytes &&
                   ((unsigned char)title[pos] & 0xC0) == 0x80 &&
                   safety++ < 4) {
                pos = (pos + 1) % period;
            }

            scroll_text(title, temp, pos);        /* scroll raw text  */
            escape_markup(temp, output, sizeof(output)); /* then escape */
        }

        printf("{\"text\": \"%s\"}\n", output);
        fflush(stdout);
        usleep(SLEEP_US);
    }

    return 0;
}

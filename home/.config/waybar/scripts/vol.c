/*
 * Icons (Nerd Fonts / your existing codepoints):
 *   Muted       : \uf466
 *   Low volume  : \uf027
 *   High volume : \uf028
 *   Bluetooth   : \udb80\udcaf  (used when sink description contains "bluetooth")
 *   Headphone   : \uee58        (used when sink description contains "headphone"/"headset")
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* Ignored sink substring - skip output entirely when default sink matches */
#define IGNORED_SINK "Easy Effects Sink"

/* Icons ------------------------------------------------------------------ */
#define ICON_MUTED      "\ueee8"
#define ICON_LOW        "\uf027"
#define ICON_HIGH       "\uf028"
#define ICON_HEADPHONE  "\uee58"
#define ICON_BT_SUFFIX  " \U000F00AF"   /* appended after volume icon for BT */

/* Run a shell command and return its stdout in a freshly malloc'd buffer.
 * Caller must free(). Returns NULL on failure. */
static char *capture(const char *cmd)
{
    FILE *fp = popen(cmd, "r");
    if (!fp) return NULL;

    size_t cap = 256, len = 0;
    char  *buf = malloc(cap);
    if (!buf) { pclose(fp); return NULL; }

    int c;
    while ((c = fgetc(fp)) != EOF) {
        if (len + 1 >= cap) {
            cap *= 2;
            char *tmp = realloc(buf, cap);
            if (!tmp) { free(buf); pclose(fp); return NULL; }
            buf = tmp;
        }
        buf[len++] = (char)c;
    }
    buf[len] = '\0';
    pclose(fp);
    return buf;
}

/* Trim leading/trailing whitespace in-place */
static char *trim(char *s)
{
    while (isspace((unsigned char)*s)) s++;
    if (*s == '\0') return s;
    char *end = s + strlen(s) - 1;
    while (end > s && isspace((unsigned char)*end)) *end-- = '\0';
    return s;
}

/* Case-insensitive strstr */
static int icontains(const char *haystack, const char *needle)
{
    if (!haystack || !needle) return 0;
    size_t nlen = strlen(needle);
    for (; *haystack; haystack++)
        if (strncasecmp(haystack, needle, nlen) == 0)
            return 1;
    return 0;
}

/* Escape a string for JSON (handles backslash and double-quote) */
static void json_puts(const char *s)
{
    for (; *s; s++) {
        if (*s == '"' || *s == '\\') putchar('\\');
        putchar(*s);
    }
}

int main(void)
{
    /* ------------------------------------------------------------------ */
    /* 1. Get default sink name                                            */
    /* ------------------------------------------------------------------ */
    char *sink_raw = capture("pactl get-default-sink 2>/dev/null");
    if (!sink_raw) {
        fprintf(stderr, "volume: failed to get default sink\n");
        return 1;
    }
    char *sink = trim(sink_raw);

    /* ------------------------------------------------------------------ */
    /* 2. Check ignored sinks                                              */
    /* ------------------------------------------------------------------ */
    if (icontains(sink, IGNORED_SINK)) {
        free(sink_raw);
        /* Output empty JSON — Waybar will show nothing */
        puts("{\"text\":\"\",\"class\":\"hidden\"}");
        return 0;
    }

    /* ------------------------------------------------------------------ */
    /* 3. Get volume percentage                                            */
    /* ------------------------------------------------------------------ */
    char vol_cmd[512];
    snprintf(vol_cmd, sizeof(vol_cmd),
        "pactl get-sink-volume '%s' 2>/dev/null "
        "| grep -oP '\\d+(?=%%)' | head -1",
        sink);
    char *vol_raw = capture(vol_cmd);
    int   volume  = vol_raw ? atoi(trim(vol_raw)) : 0;
    free(vol_raw);

    /* ------------------------------------------------------------------ */
    /* 4. Get mute state                                                   */
    /* ------------------------------------------------------------------ */
    char mute_cmd[512];
    snprintf(mute_cmd, sizeof(mute_cmd),
        "pactl get-sink-mute '%s' 2>/dev/null", sink);
    char *mute_raw = capture(mute_cmd);
    int   muted    = mute_raw && icontains(mute_raw, "yes");
    free(mute_raw);

    /* ------------------------------------------------------------------ */
    /* 5. Get sink description for BT / headphone detection               */
    /* ------------------------------------------------------------------ */
    char desc_cmd[512];
    snprintf(desc_cmd, sizeof(desc_cmd),
        "pactl list sinks 2>/dev/null "
        "| grep -A20 'Name: %s' "
        "| grep 'Description:' | head -1 "
        "| sed 's/.*Description: //'",
        sink);
    char *desc_raw  = capture(desc_cmd);
    char *desc      = desc_raw ? trim(desc_raw) : (char *)"";
    int   is_bt     = icontains(desc, "bluetooth") || icontains(sink, "bluez");
    int   is_phones = icontains(desc, "headphone") || icontains(desc, "headset");

    /* ------------------------------------------------------------------ */
    /* 6. Choose icon                                                      */
    /* ------------------------------------------------------------------ */
    const char *icon;
    char icon_buf[64] = {0};

    if (muted) {
        icon = ICON_MUTED;
    } else if (is_phones || is_bt) {
        /* Headphone / headset icon; BT gets an extra badge */
        snprintf(icon_buf, sizeof(icon_buf), "%s%s",
                 ICON_HEADPHONE, is_bt ? ICON_BT_SUFFIX : "");
        icon = icon_buf;
    } else {
        icon = (volume < 50) ? ICON_LOW : ICON_HIGH;
        if (is_bt) {
            snprintf(icon_buf, sizeof(icon_buf), "%s%s", icon, ICON_BT_SUFFIX);
            icon = icon_buf;
        }
    }

    /* ------------------------------------------------------------------ */
    /* 7. Build CSS class string                                           */
    /* ------------------------------------------------------------------ */
    char css_class[64];
    if (muted)
        snprintf(css_class, sizeof(css_class), "muted");
    else if (volume > 100)
        snprintf(css_class, sizeof(css_class), "boosted");
    else if (volume >= 50)
        snprintf(css_class, sizeof(css_class), "high");
    else
        snprintf(css_class, sizeof(css_class), "low");

    if (is_bt)   strncat(css_class, " bluetooth", sizeof(css_class) - strlen(css_class) - 1);
    if (is_phones) strncat(css_class, " headphone", sizeof(css_class) - strlen(css_class) - 1);

    /* ------------------------------------------------------------------ */
    /* 8. Emit Waybar JSON                                                 */
    /* ------------------------------------------------------------------ */
    printf("{\"text\":\"");
    if (muted)
        printf("%s  -%%", icon);
    else if (is_phones || is_bt)
        printf("%s %d%%", icon, volume);
    else
        printf("%s  %d%%", icon, volume);
    printf("\",\"class\":\"");
    json_puts(css_class);
    printf("\"}\n");
    fflush(stdout);

    free(sink_raw);
    free(desc_raw);
    return 0;
}

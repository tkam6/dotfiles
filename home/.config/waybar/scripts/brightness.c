/*
 *
 * Icons (Nerd Fonts, matching your original codepoints):
 *   Low    : \udb80\udcde  (󰃞)
 *   Medium : \udb80\udce0  (󰃠)
 *   High   : \udb80\udcda  (󰃚)  — kept in same order as format-icons array
 *
 * Scroll adjustment honours min-brightness (5%) so screen never goes black.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BACKLIGHT_DIR   "/sys/class/backlight/intel_backlight"
#define BRIGHTNESS_PATH BACKLIGHT_DIR "/brightness"
#define MAX_PATH        BACKLIGHT_DIR "/max_brightness"
#define MIN_BRIGHTNESS  5   /* percent — mirrors your min-brightness setting */
#define SCROLL_STEP     5   /* percent — mirrors your scroll-step setting     */

/* Icons — same order / codepoints as your format-icons array */
#define ICON_LOW    "\U000F00DE"   /* \udb80\udcde */
#define ICON_MED    "\U000F00E0"   /* \udb80\udce0 */
#define ICON_HIGH   "\U000F00DA"   /* \udb80\udcda */

/* Read a single integer from a sysfs file. Returns -1 on error. */
static int read_int(const char *path)
{
    FILE *f = fopen(path, "r");
    if (!f) return -1;
    int val = -1;
    fscanf(f, "%d", &val);
    fclose(f);
    return val;
}

/* Write a single integer to a sysfs file. Returns 0 on success. */
static int write_int(const char *path, int val)
{
    FILE *f = fopen(path, "w");
    if (!f) return -1;
    fprintf(f, "%d\n", val);
    fclose(f);
    return 0;
}

/* Clamp val between lo and hi */
static int clamp(int val, int lo, int hi)
{
    if (val < lo) return lo;
    if (val > hi) return hi;
    return val;
}

/* Escape a string for JSON */
static void json_puts(const char *s)
{
    for (; *s; s++) {
        if (*s == '"' || *s == '\\') putchar('\\');
        putchar(*s);
    }
}

int main(int argc, char *argv[])
{
    int max = read_int(MAX_PATH);
    int cur = read_int(BRIGHTNESS_PATH);

    if (max <= 0 || cur < 0) {
        fprintf(stderr, "backlight: cannot read sysfs brightness\n");
        return 1;
    }

    /* ------------------------------------------------------------------
     * Handle scroll adjustments (--inc / --dec)
     * ------------------------------------------------------------------ */
    if (argc > 1) {
        int min_raw  = (int)(MIN_BRIGHTNESS / 100.0 * max + 0.5);
        int step_raw = (int)(SCROLL_STEP    / 100.0 * max + 0.5);
        if (step_raw < 1) step_raw = 1;

        int new_brightness = cur;
        if (strcmp(argv[1], "--inc") == 0)
            new_brightness = clamp(cur + step_raw, min_raw, max);
        else if (strcmp(argv[1], "--dec") == 0)
            new_brightness = clamp(cur - step_raw, min_raw, max);

        if (new_brightness != cur)
            write_int(BRIGHTNESS_PATH, new_brightness);

        cur = new_brightness;
    }

    /* ------------------------------------------------------------------
     * Calculate percent and choose icon
     * ------------------------------------------------------------------ */
    int percent = (int)(cur * 100.0 / max + 0.5);
    percent = clamp(percent, 0, 100);

    const char *icon;
    if      (percent < 34) icon = ICON_LOW;
    else if (percent < 67) icon = ICON_MED;
    else                   icon = ICON_HIGH;

    /* CSS class reflects brightness tier */
    const char *css_class;
    if      (percent < 34) css_class = "low";
    else if (percent < 67) css_class = "medium";
    else                   css_class = "high";

    /* ------------------------------------------------------------------
     * Emit Waybar JSON
     * ------------------------------------------------------------------ */
    printf("{\"text\":\"");
    json_puts(icon);
    printf("\",\"class\":\"");
    json_puts(css_class);
    printf("\"}\n");
    fflush(stdout);

    return 0;
}

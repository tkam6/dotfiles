#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define SLEEP_US 2000000  // 2 seconds

typedef struct {
    long total, available;
} MemStat;

int read_mem_stat(MemStat *stat) {
    FILE *fp = fopen("/proc/meminfo", "r");
    if (!fp) return 0;

    char key[64];
    long value;
    char unit[16];
    stat->total = stat->available = 0;

    while (fscanf(fp, "%s %ld %s", key, &value, unit) == 3) {
        if (strcmp(key, "MemTotal:") == 0)     stat->total     = value;
        if (strcmp(key, "MemAvailable:") == 0) stat->available = value;
        if (stat->total && stat->available) break;
    }

    fclose(fp);
    return stat->total > 0;
}

const char *get_icon(double pct) {
    if (pct < 50)  return "\uefc5";
    if (pct < 75)  return "<span color='#FF8B00'>\uefc5</span>";
    return "<span color='#FF1500'>\uefc5</span>";
}

const char *get_class(double pct) {
    if (pct < 50)  return "normal";
    if (pct < 75)  return "warning";
    return "critical";
}

int main() {
    MemStat mem;

    while (1) {
        if (read_mem_stat(&mem)) {
            long used = mem.total - mem.available;
            double pct = (double)used / mem.total * 100.0;
            double used_gb = used / 1024.0 / 1024.0;

            printf("{\"text\": \"%s  %.0f%% [%.1fGi]\", \"class\": \"%s\"}\n",
                get_icon(pct), pct, used_gb, get_class(pct));
            fflush(stdout);
        }

        usleep(SLEEP_US);
    }

    return 0;
}

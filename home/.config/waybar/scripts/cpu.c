#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define SLEEP_US 2000000  // 2 seconds

typedef struct {
    long user, nice, system, idle, iowait, irq, softirq, steal;
} CpuStat;

int read_cpu_stat(CpuStat *stat) {
    FILE *fp = fopen("/proc/stat", "r");
    if (!fp) return 0;

    char label[16];
    int ret = fscanf(fp, "%s %ld %ld %ld %ld %ld %ld %ld %ld",
        label,
        &stat->user, &stat->nice, &stat->system, &stat->idle,
        &stat->iowait, &stat->irq, &stat->softirq, &stat->steal);

    fclose(fp);
    return ret == 9;
}

double cpu_percent(CpuStat *prev, CpuStat *curr) {
    long prev_idle  = prev->idle + prev->iowait;
    long curr_idle  = curr->idle + curr->iowait;

    long prev_total = prev->user + prev->nice + prev->system + prev_idle
                    + prev->irq + prev->softirq + prev->steal;
    long curr_total = curr->user + curr->nice + curr->system + curr_idle
                    + curr->irq + curr->softirq + curr->steal;

    long delta_total = curr_total - prev_total;
    long delta_idle  = curr_idle  - prev_idle;

    if (delta_total == 0) return 0.0;
    return (double)(delta_total - delta_idle) / delta_total * 100.0;
}

const char *get_icon(double pct) {
    if (pct < 50)  return "\uf4bc";
    if (pct < 75)  return "<span color='#FF8B00'>\uf4bc</span>";
    return "<span color='#FF1500'>\uf4bc</span>";
}

const char *get_class(double pct) {
    if (pct < 50)  return "normal";
    if (pct < 75)  return "warning";
    return "critical";
}

int main() {
    CpuStat prev, curr;

    if (!read_cpu_stat(&prev)) {
        fprintf(stderr, "Failed to read /proc/stat\n");
        return 1;
    }

    while (1) {
        usleep(SLEEP_US);

        if (!read_cpu_stat(&curr)) continue;

        double pct = cpu_percent(&prev, &curr);
        prev = curr;

        printf("{\"text\": \"%s  %.0f%%\", \"class\": \"%s\"}\n",
            get_icon(pct), pct, get_class(pct));
        fflush(stdout);
    }

    return 0;
}

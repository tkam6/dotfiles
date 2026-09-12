#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/statvfs.h>

#define SLEEP_US 5000000  // 5 seconds
#define MOUNT "/"

const char *get_class(double pct) {
    if (pct < 60)  return "normal";
    if (pct < 85)  return "warning";
    return "critical";
}

int main() {
    struct statvfs stat;

    while (1) {
        if (statvfs(MOUNT, &stat) == 0) {
            double total = (double)stat.f_blocks * stat.f_frsize;
            double avail = (double)stat.f_bavail * stat.f_frsize;
            double used  = total - avail;
            double pct   = used / total * 100.0;
            double used_gb  = used  / 1024.0 / 1024.0 / 1024.0;
            double total_gb = total / 1024.0 / 1024.0 / 1024.0;

            printf("{\"text\": \"󰋊 %.0f%% [%.1fGi]\", \"class\": \"%s\"}\n",
                pct, used_gb, get_class(pct));
            fflush(stdout);
        }

        usleep(SLEEP_US);
    }

    return 0;
}

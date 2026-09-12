#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define ZONE "/sys/class/thermal/thermal_zone7/temp"
#define SLEEP_SEC 3

int main() {
    FILE *fp;
    int temp;

    while (1) {
        fp = fopen(ZONE, "r");
        if (!fp) {
            printf("{\"text\": \"N/A\"}\n");
            fflush(stdout);
            sleep(SLEEP_SEC);
            continue;
        }

        if (fscanf(fp, "%d", &temp) != 1) {
            fclose(fp);
            printf("{\"text\": \"N/A\"}\n");
            fflush(stdout);
            sleep(SLEEP_SEC);
            continue;
        }

        fclose(fp);

        temp /= 1000;

        const char *icon;
        const char *colour;

        if (temp < 70) {
            icon = "\uf2ca";
            colour = "";
        } else if (temp < 85) {
            icon = "\uf2c9";
            colour = " color='#FF8B00'";
        } else {
            icon = "\uf2c7";
            colour = " color='#FF1500'";
        }

        printf("{\"text\": \"<span font='13'%s>%s</span> %d°C\"}\n",
               colour, icon, temp);

        fflush(stdout);
        sleep(SLEEP_SEC);
    }

    return 0;
}

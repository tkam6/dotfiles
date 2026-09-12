#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define SLEEP_US 2000000  // 2 seconds

// Returns: "off", "on", "connected", "unknown"
const char *get_bt_status() {
    FILE *fp = popen("bluetoothctl show", "r");
    if (!fp) return "unknown";

    char line[256];
    int powered = 0;

    while (fgets(line, sizeof(line), fp)) {
        if (strstr(line, "Powered: yes"))  { powered = 1; }
    }
    pclose(fp);

    if (!powered) return "off";

    // Check for any connected devices
    fp = popen("bluetoothctl devices Connected", "r");
    if (!fp) return "on";

    int connected = 0;
    if (fgets(line, sizeof(line), fp) && strlen(line) > 1)
        connected = 1;
    pclose(fp);

    return connected ? "connected" : "on";
}

int main() {
    while (1) {
        const char *status = get_bt_status();
        const char *text;

        if (strcmp(status, "off") == 0) {
            // \udb80\udcb2 -> U+F00B2
            text = "<span font='12'>\U000F00B2</span>";
        } else if (strcmp(status, "on") == 0) {
            // \udb80\udcaf -> U+F002F
            text = "<span color='#FFD145' font='12'>\U000F00AF</span>";
        } else if (strcmp(status, "connected") == 0) {
            // \udb80\udcb1 -> U+F00B1
            text = "<span font='12' color='#00aa00'>\U000F00B1</span>";
        } else {
            // \uf128 = question mark
            text = "<span font='14' color='#FF5000'>\U000F00AF</span> <span rise='1000' color='#FF5000' font='9'>\uf128</span>";
        }

        printf("{\"text\": \"%s\", \"class\": \"%s\"}\n", text, status);
        fflush(stdout);

        usleep(SLEEP_US);
    }

    return 0;
}

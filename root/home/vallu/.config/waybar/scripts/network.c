#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>

#define TIMEOUT 5
#define INTERVAL_SECONDS 2
#define CHECK_HOST "connectivitycheck.gstatic.com"
#define CHECK_PATH "/generate_204"
#define CHECK_PORT 80

void get_ssid(char *out, size_t size) {
    FILE *fp = popen("nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2", "r");
    if (!fp) { strncpy(out, "unknown", size); return; }

    if (!fgets(out, size, fp)) strncpy(out, "unknown", size);
    pclose(fp);

    out[strcspn(out, "\n")] = '\0';
}

// Returns: "full", "portal", "none", "unknown"
const char *check_connectivity() {
    struct addrinfo hints = {0}, *res = NULL;
    hints.ai_family   = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    if (getaddrinfo(CHECK_HOST, "80", &hints, &res) != 0)
        return "none";

    int fd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (fd < 0) { freeaddrinfo(res); return "unknown"; }

    struct timeval tv = { TIMEOUT, 0 };
    setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
    setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &tv, sizeof(tv));

    if (connect(fd, res->ai_addr, res->ai_addrlen) != 0) {
        close(fd); freeaddrinfo(res); return "none";
    }
    freeaddrinfo(res);

    const char *req =
        "GET " CHECK_PATH " HTTP/1.1\r\n"
        "Host: " CHECK_HOST "\r\n"
        "Connection: close\r\n\r\n";

    if (send(fd, req, strlen(req), 0) < 0) {
        close(fd); return "unknown";
    }

    char buf[512] = {0};
    int  n = recv(fd, buf, sizeof(buf) - 1, 0);
    close(fd);

    if (n <= 0) return "unknown";

    // Parse status code from "HTTP/1.x NNN ..."
    char *sp = strchr(buf, ' ');
    if (!sp) return "unknown";

    int code = atoi(sp + 1);
    if (code == 204) return "full";
    if (code >= 300 && code < 400) return "portal";
    if (code == 200) return "portal";  // captive portal serving a page

    return "unknown";
}

// Returns: "full", "limited", "none", or "unknown" from nmcli
void nmcli_connectivity(char *out, size_t size) {
    FILE *fp = popen("nmcli networking connectivity", "r");
    if (!fp) { strncpy(out, "unknown", size); return; }
    if (!fgets(out, size, fp)) strncpy(out, "unknown", size);
    pclose(fp);
    // strip newline
    out[strcspn(out, "\n")] = '\0';
}

int main() {
    while (1) {
        const char *status = check_connectivity();

        char nmcli_out[64];
        nmcli_connectivity(nmcli_out, sizeof(nmcli_out));

        char ssid[128];
        get_ssid(ssid, sizeof(ssid));

        char text_buf[512];
        const char *text;
        const char *tooltip;

        if (strcmp(status, "full") == 0) {
            snprintf(text_buf, sizeof(text_buf),
                     "<span rise='1000' font='10' color='#00AA00'>\uf1eb</span>  %s", ssid);
            text = text_buf;
            tooltip = "Full internet access";
        } else if (strcmp(status, "portal") == 0) {
            text = "<span font='10' color='#FFD145'>\uf1eb</span> <span color='#FFD145'><sub>\uf511</sub></span>";
            tooltip = "Captive portal detected";

        } else if (strcmp(status, "none") == 0) {
            if (strcmp(nmcli_out, "full") == 0) {
                text = "<span font='10' color='#FFD145'>\uf1eb</span> <span color='#FFD145'><sub>\uf12a</sub></span>";
                tooltip = "No internet access";
            } else {
                text = "<span font='11' rise='-2000' color='#FFD145'>\uef5f</span>";
                tooltip = "Disconnected";
            }

        } else {
            text = "<span font='10' color='#FF4F4F'>\uf1eb</span>\u2002<span color='#FF4F4F'><sub>\uf128</sub></span>";
            tooltip = "Unknown network state";
        }

        char safe_text[1024] = {0};
        size_t j = 0;
        for (size_t i = 0; text[i] && j < sizeof(safe_text) - 2; i++) {
            if (text[i] == '"' || text[i] == '\\') safe_text[j++] = '\\';
            safe_text[j++] = text[i];
        }

        printf("{\"text\": \"%s\", \"class\": \"%s\", \"tooltip\": \"%s\"}\n",
               safe_text, status, tooltip);

        fflush(stdout);   // critical — Waybar reads line-by-line from the pipe

        sleep(INTERVAL_SECONDS);
    }

    return 0;
}

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Widgets
import qs.Services.UI

Item {
    id: root

    // Plugin API (injected by PluginService)
    property var pluginApi: null

    // Required properties for bar widgets
    property ShellScreen screen
    property string widgetId: ""
    property string section: ""
    property int sectionWidgetIndex: -1
    property int sectionWidgetsCount: 0

    // Per-screen bar properties
    readonly property string screenName: screen?.name ?? ""
    readonly property real capsuleHeight: Style.getCapsuleHeightForScreen(screenName)
    readonly property real barFontSize: Style.getBarFontSizeForScreen(screenName)

    // --- Plugin state (equivalent of the v5 `fullscreen` upvalue) ---
    property bool isFullscreen: false
    readonly property string glyph: isFullscreen ? "arrows-minimize" : "arrows-maximize"
    readonly property string tooltipText: isFullscreen ? "Exit fullscreen" : "Enter fullscreen"

    function setState(newState) {
        if (newState === root.isFullscreen) return
        root.isFullscreen = newState
    }

    // equivalent of check_current_state()
    function checkCurrentState() {
        // restart even if one is already in flight, cheap and avoids races
        checkProcess.running = false
        checkProcess.running = true
    }

    readonly property real contentWidth: content.implicitWidth + Style.marginM * 2
    readonly property real contentHeight: capsuleHeight
    implicitWidth: contentWidth
    implicitHeight: contentHeight

    Rectangle {
        id: visualCapsule
        x: Style.pixelAlignCenter(parent.width, width)
        y: Style.pixelAlignCenter(parent.height, height)
        width: root.contentWidth
        height: root.contentHeight
        color: mouseArea.containsMouse ? Color.mHover : Style.capsuleColor
        radius: Style.radiusL
        border.color: Style.capsuleBorderColor
        border.width: Style.capsuleBorderWidth

        RowLayout {
            id: content
            anchors.centerIn: parent
            spacing: Style.marginS

            NIcon {
                icon: root.glyph
                color: Color.mOnSurface
                pointSize: root.barFontSize
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: TooltipService.show(root, root.tooltipText, BarService.getTooltipDirection())
        onExited: TooltipService.hide()
    }

    // --- hyprctl activewindow -j, equivalent of noctalia.runAsync(...) ---
    Process {
        id: checkProcess
        command: ["hyprctl", "activewindow", "-j"]
        running: false
        stdout: StdioCollector {
            id: checkCollector
            onStreamFinished: {
                try {
                    const window = JSON.parse(text)
                    if (window) {
                        root.setState(window.fullscreen === 2 || window.fullscreen === 3)
                    }
                } catch (e) {
                    Logger.w("FullscreenIndicator", "Failed to parse hyprctl output:", e)
                }
            }
        }
    }

    // --- socat event listener, equivalent of wait_for_next_event() ---
    // Unlike the Luau version we don't need to respawn per-event: the
    // process just stays connected and we filter each line as it arrives.
    Process {
        id: eventProcess
        command: ["sh", "-c", "socat -u UNIX-CONNECT:\"$XDG_RUNTIME_DIR\"/hypr/\"$HYPRLAND_INSTANCE_SIGNATURE\"/.socket2.sock -"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                if (data.startsWith("fullscreen>>") || data.startsWith("activewindow>>")) {
                    root.checkCurrentState()
                }
            }
        }
        onExited: restartTimer.start()
    }

    // If socat dies (Hyprland restart, socket not ready yet, etc.) retry
    Timer {
        id: restartTimer
        interval: 2000
        repeat: false
        onTriggered: eventProcess.running = true
    }

    Component.onCompleted: {
        root.checkCurrentState()   // initial state, like the v5 load-time call
        eventProcess.running = true // then live off events
    }
}

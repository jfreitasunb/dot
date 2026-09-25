import QtQuick
import Quickshell
import Quickshell.Io

// Command menu: quick actions that have NO other bar surface — power
// profile, keep-awake, mic mute, night light, bluetooth power, brightness
// (laptops), updates, screen off, power menu.
BarModule {
    id: root

    icon: "󰘳"
    iconColor: Qt.alpha(Theme.fg, 0.7)
    color: hovered ? Qt.alpha(Theme.fg, 0.14) : Qt.alpha(Theme.fg, 0.07)

    onClicked: menu.visible = !menu.visible

    property string profile: "balanced"
    property bool caffeine: false
    property bool nightLight: false
    property bool hasBacklight: false
    property int brightness: 50
    property bool micMuted: false

    // Atualização de estado do sistema
    Process {
        id: stateProc
        command: ["sh", "-c",
            "printf '%s\\n' " +
            "\"$(powerprofilesctl get 2>/dev/null)\" " +
            "\"$(brightnessctl -m -c backlight 2>/dev/null | head -n1)\" " +
            "\"$(pgrep -f '[w]hy=quickshell-caffeine' >/dev/null && echo awake)\" " +
            "\"$(pgrep -x wlsunset >/dev/null && echo night)\" " +
            "\"$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -q '\\[MUTED\\]' && echo muted)\""]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split("\n")
                if (root.profileOrder.indexOf(lines[0]) >= 0)
                    root.profile = lines[0]
                const bl = (lines[1] ?? "").split(",")
                root.hasBacklight = bl.length >= 4
                if (root.hasBacklight)
                    root.brightness = parseInt(bl[3]) || root.brightness
                root.caffeine = lines[2] === "awake"
                root.nightLight = lines[3] === "night"
                root.micMuted = lines[4] === "muted"
            }
        }
    }

    function toggleMic() {
        Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"])
        root.micMuted = !root.micMuted
    }

    readonly property var profileOrder: ["performance", "balanced", "power-saver"]
    readonly property var profileIcons: ({ performance: "󰓅", balanced: "󰾅", "power-saver": "󰾆" })

    function cycleProfile() {
        const next = profileOrder[(profileOrder.indexOf(profile) + 1) % profileOrder.length]
        Quickshell.execDetached(["powerprofilesctl", "set", next])
        profile = next
    }

    component CommandRow: Rectangle {
        id: rowRect
        required property var modelData

        width: parent.width
        height: 34
        radius: 8
        color: rowMa.containsMouse ? Qt.alpha(Theme.fg, 0.12) : "transparent"

        Behavior on color { ColorAnimation { duration: 120 } }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            spacing: 10

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: rowRect.modelData.icon
                color: Theme.cyan
                font.family: Theme.fontFamily
                font.pixelSize: 15
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: rowRect.modelData.label
                color: Qt.alpha(Theme.fg, 0.9)
                font.family: Theme.fontFamily
                font.pixelSize: 13
            }
        }

        MouseArea {
            id: rowMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                menu.visible = false
                rowRect.modelData.run()
            }
        }
    }

    NotifyPopup {
        id: notifHistory
        anchorItem: root
    }

    Popout {
        id: menu
        anchorItem: root
        cardWidth: 270
        cardHeight: col.implicitHeight + 2 * cardPadding

        onVisibleChanged: if (visible) stateProc.running = true

        IpcHandler {
            target: "commands"
            function toggle(): void { menu.visible = !menu.visible }
        }

        Column {
            id: col
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 6

            Grid {
                width: parent.width
                columns: 2
                spacing: 6

                Repeater {
                    model: [
                        { 
                            icon: root.profileIcons[root.profile],
                            label: root.profile,
                            active: root.profile !== "balanced",
                            run: () => root.cycleProfile() 
                        },
                        { 
                            icon: root.caffeine ? "󰅶" : "󰾪", 
                            label: root.caffeine ? "Awake" : "Sleep OK",
                            active: root.caffeine,
                            run: () => {
                                root.caffeine = !root.caffeine
                                Quickshell.execDetached(["sh", "-c", root.caffeine
                                    ? "systemd-inhibit --what=idle --who=quickshell --why=quickshell-caffeine sleep infinity >/dev/null 2>&1 &"
                                    : "pkill -f '[w]hy=quickshell-caffeine'"])
                            } 
                        },
                        { 
                            icon: root.micMuted ? "󰍭" : "󰍬",
                            label: root.micMuted ? "Muted" : "Mic",
                            active: root.micMuted, alert: root.micMuted,
                            alt: ["pavucontrol", "-t", "4"],
                            run: () => root.toggleMic() 
                        },
                        { 
                            icon: "󱩌", 
                            label: "Night light",
                            active: root.nightLight,
                            run: () => {
                                root.nightLight = !root.nightLight
                                Quickshell.execDetached(["sh", "-c", root.nightLight
                                    ? "wlsunset -t 4500 -T 6500 >/dev/null 2>&1 &"
                                    : "pkill -x wlsunset"])
                            } 
                        }
                    ]
                    TogglePill { closeFn: () => menu.visible = false }
                }
            }

            TweakSlider {
                visible: root.hasBacklight
                label: "brightness"
                from: 5; to: 100
                value: root.brightness
                suffix: "%"
                applyFn: v => Quickshell.execDetached(
                    ["brightnessctl", "-c", "backlight", "set", v + "%"])
                persistFn: v => {}
            }

            Rectangle {
                width: parent.width - 8
                anchors.horizontalCenter: parent.horizontalCenter
                height: 1
                color: Qt.alpha(Theme.fg, 0.15)
            }

            Repeater {
                model: [
                    { 
                        icon: "󰚰", label: "Check updates",
                        run: () => Quickshell.execDetached(["kitty", "--class", "system-update", "-e", "sh", "-c",
                            "sudo apt update && apt list --upgradable; " +
                            "printf '\\ndone - press enter to close '; read _"]) 
                    },
                    { 
                        icon: "󰌢", label: "Screen off",
                        run: () => Quickshell.execDetached(["swaymsg", "output * power off"]) 
                    },
                    { 
                        icon: "󰐥", label: "Power menu",
                        run: () => Quickshell.execDetached(["wlogout"]) 
                    }
                ]
                CommandRow {}
            }
        }
    }
}

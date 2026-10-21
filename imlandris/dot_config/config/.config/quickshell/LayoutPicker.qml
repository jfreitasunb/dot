import QtQuick
import Quickshell
import Quickshell.Io

// Layout + tweaks popup adaptado para Sway
Popout {
    id: root

    cardWidth: 340
    cardHeight: col.implicitHeight + 2 * cardPadding

    // Ponto de entrada IPC para atalhos do Sway:
    // bindsym $mod+t exec qs -p ~/.config/sway/quickshell ipc call tweaks toggle
    IpcHandler {
        target: "layouts"
        function toggle(): void { root.visible = !root.visible }
    }
    IpcHandler {
        target: "tweaks"
        function toggle(): void { root.visible = !root.visible }
    }

    function persistFile(name, v) {
        Quickshell.execDetached(["sh", "-c",
            "mkdir -p '" + Theme.configDir + "'; printf '%s\\n' " + v + " > '" + Theme.configDir + "/" + name + "'"])
    }

    // Variáveis de estado do Sway
    property string activeLayout: "splith"
    property int currentGaps: 8
    property int currentBorder: 2
    property int currentOpacity: 100

    // Lê configurações de gaps e borda na abertura
    onVisibleChanged: {
        if (visible) {
            swayTreeProc.running = true
        }
    }

    Process {
        id: swayTreeProc
        command: ["sh", "-c", "swaymsg -t get_tree | jq -r '.. | (.nodes? // empty)[] | select(.focused == true) | .layout // empty'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const l = text.trim()
                if (l === "splitv" || l === "splith" || l === "tabbed" || l === "stacking") {
                    root.activeLayout = l
                }
            }
        }
    }

    readonly property var swayLayouts: [
        { name: "Split H", glyph: "󰤼", cmd: "splith" },
        { name: "Split V", glyph: "󰤻", cmd: "splitv" },
        { name: "Tabbed",  glyph: "󰓩", cmd: "tabbed" },
        { name: "Stacked", glyph: "󰪍", cmd: "stacking" }
    ]

    component SectionLabel: Text {
        color: Theme.accent
        font.family: Theme.fontFamily
        font.pixelSize: 12
        font.bold: true
        topPadding: 6
    }

    Column {
        id: col
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 6

        SectionLabel { text: "Layout (Sway)" }

        Grid {
            id: layoutGrid
            width: parent.width
            columns: 2
            spacing: 6

            Repeater {
                model: root.swayLayouts

                Rectangle {
                    id: tile
                    required property var modelData
                    readonly property bool current: root.activeLayout === modelData.cmd

                    width: (layoutGrid.width - 6) / 2
                    height: 48
                    radius: 8
                    color: current ? Theme.selbg
                         : tileMa.containsMouse ? Qt.alpha(Theme.fg, 0.12)
                         : Qt.alpha(Theme.fg, 0.04)

                    Behavior on color { ColorAnimation { duration: 120 } }

                    Row {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: tile.modelData.glyph
                            color: tile.current ? Theme.selfg : Theme.cyan
                            font.family: Theme.fontFamily
                            font.pixelSize: 18
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: tile.modelData.name
                            color: tile.current ? Theme.selfg : Qt.alpha(Theme.fg, 0.8)
                            font.family: Theme.fontFamily
                            font.pixelSize: 11
                            font.bold: tile.current
                        }
                    }

                    MouseArea {
                        id: tileMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.activeLayout = tile.modelData.cmd
                            Quickshell.execDetached(["swaymsg", "layout", tile.modelData.cmd])
                        }
                    }
                }
            }
        }

        SectionLabel { text: "Desktop" }

        TweakSlider {
            label: "window gap"
            from: 0; to: 30
            value: root.currentGaps
            suffix: " px"
            applyFn: v => {
                root.currentGaps = v
                Quickshell.execDetached(["swaymsg", "gaps", "inner", "current", "set", String(v)])
            }
            persistFn: v => root.persistFile("sway-gaps", v)
        }

        TweakSlider {
            label: "border width"
            from: 0; to: 6
            value: root.currentBorder
            suffix: " px"
            applyFn: v => {
                root.currentBorder = v
                Quickshell.execDetached(["swaymsg", "border", "pixel", String(v)])
            }
            persistFn: v => root.persistFile("sway-border", v)
        }

        SectionLabel { text: "Opacity" }

        TweakSlider {
            label: "window opacity"
            from: 50; to: 100
            value: root.currentOpacity
            suffix: "%"
            applyFn: v => {
                root.currentOpacity = v
                const op = (v / 100).toFixed(2)
                Quickshell.execDetached(["swaymsg", "opacity", String(op)])
            }
            persistFn: v => root.persistFile("sway-opacity", v)
        }

        SectionLabel { text: "Bar" }

        TweakSlider {
            label: "bar height"
            from: 36; to: 72
            value: Theme.barHeight
            suffix: " px"
            applyFn: v => Theme.barHeight = v
            persistFn: v => root.persistFile("bar-height", v)
        }

        TweakSlider {
            label: "element scale"
            from: 0.7; to: 2.0
            value: Theme.barUserScale
            isInt: false
            suffix: "×"
            applyFn: v => Theme.barUserScale = v
            persistFn: v => root.persistFile("bar-scale", v)
        }
    }
}

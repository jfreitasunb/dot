import QtQuick
import Quickshell
import Quickshell.Io

// Workspaces indicator adaptado para Sway (12 slots, estilo bspwm)
Item {
    id: root

    implicitWidth: tagRow.implicitWidth
    implicitHeight: Math.round(22 * Theme.barScale)

    readonly property int totalTags: 12

    // Estado interno derivado do IPC do Sway
    property var workspacesList: []
    property int focusedIndex: 0

    function isOccupied(idx) {
        const num = idx + 1
        return workspacesList.some(w => w.num === num)
    }

    function isSelected(idx) {
        const num = idx + 1
        return workspacesList.some(w => w.num === num && w.focused)
    }

    function isUrgent(idx) {
        const num = idx + 1
        return workspacesList.some(w => w.num === num && w.urgent)
    }

    function updateState(jsonText) {
        try {
            const list = JSON.parse(jsonText)
            if (Array.isArray(list)) {
                root.workspacesList = list
                const focused = list.find(w => w.focused)
                if (focused && focused.num > 0) {
                    root.focusedIndex = focused.num - 1
                }
            }
        } catch (_) {}
    }

    // Leitura inicial dos workspaces
    Process {
        id: initProc
        running: true
        command: ["swaymsg", "-t", "get_workspaces"]
        stdout: StdioCollector {
            onStreamFinished: root.updateState(text)
        }
    }

    // Escuta eventos em tempo real do Sway
    Process {
        id: eventProc
        running: true
        command: ["swaymsg", "-m", "-t", "subscribe", "[\"workspace\"]"]
        stdout: SplitParser {
            onRead: _ => {
                // A cada alteração (init, focus, empty, move, urgent), recarrega a lista
                if (!refreshProc.running) {
                    refreshProc.running = true
                }
            }
        }
    }

    Process {
        id: refreshProc
        command: ["swaymsg", "-t", "get_workspaces"]
        stdout: StdioCollector {
            onStreamFinished: root.updateState(text)
        }
    }

    // Ciclar workspaces pelo scroll
    WheelHandler {
        onWheel: ev => {
            const dir = ev.angleDelta.y > 0 ? "prev" : "next"
            Quickshell.execDetached(["swaymsg", "workspace", dir])
        }
    }

    Row {
        id: tagRow
        spacing: 4
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: root.totalTags

            Rectangle {
                id: tag
                required property int index

                readonly property bool selected: root.isSelected(index)
                readonly property bool occupied: root.isOccupied(index)
                readonly property bool urgent: root.isUrgent(index)

                width: Math.round((selected ? 30 : occupied ? 22 : 12) * Theme.barScale)
                height: Math.round(22 * Theme.barScale)
                radius: Math.round(7 * Theme.barScale)
                anchors.verticalCenter: parent.verticalCenter
                color: urgent ? Theme.red
                     : selected ? Theme.selbg
                     : occupied ? Qt.alpha(Theme.fg, 0.08)
                     : "transparent"

                Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: 180 } }

                SequentialAnimation on opacity {
                    running: tag.urgent
                    loops: Animation.Infinite
                    alwaysRunToEnd: true
                    NumberAnimation { to: 0.5; duration: 500; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 1.0; duration: 500; easing.type: Easing.InOutQuad }
                }

                Text {
                    anchors.centerIn: parent
                    visible: tag.occupied || tag.selected
                    text: tag.index + 1
                    color: tag.urgent ? Theme.bg
                         : tag.selected ? Theme.selfg
                         : Qt.alpha(Theme.fg, 0.85)
                    font.family: Theme.fontFamily
                    font.pixelSize: Math.round(12 * Theme.barScale)
                    font.bold: tag.selected
                    Behavior on color { ColorAnimation { duration: 180 } }
                }

                Rectangle {
                    visible: !tag.occupied && !tag.selected
                    anchors.centerIn: parent
                    width: Math.round(5 * Theme.barScale)
                    height: width
                    radius: width / 2
                    color: Qt.alpha(Theme.fg, 0.25)
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    onClicked: m => {
                        const targetNum = tag.index + 1
                        if (m.button === Qt.MiddleButton) {
                            Quickshell.execDetached(["swaymsg", "move", "container", "to", "workspace", "number", String(targetNum)])
                        } else {
                            Quickshell.execDetached(["swaymsg", "workspace", "number", String(targetNum)])
                        }
                    }
                }
            }
        }
    }
}

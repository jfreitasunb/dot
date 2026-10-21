import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    // Monitor associado a esta instância da barra
    property var targetScreen: null

    // Adota a altura padrão dos módulos da barra
    readonly property real wsHeight: (typeof Theme.moduleHeight !== "undefined") ? Theme.moduleHeight : 28

    implicitWidth: wsRow.implicitWidth
    implicitHeight: wsHeight
    height: wsHeight

    // Identificação da saída atual (eDP-1, DP-1, HDMI-A-1, etc.)
    readonly property string screenName: {
        if (targetScreen && targetScreen.name)
            return targetScreen.name
        const win = root.QsWindow.window
        return (win && win.screen) ? win.screen.name : ""
    }

    readonly property bool isExternalScreen: screenName === "DP-1" || screenName === "HDMI-A-1"

    // Faixas estritas e isoladas por saída:
    // - eDP-1: estritamente 1 a 5
    // - Externos (DP-1 / HDMI-A-1): estritamente 6 a 10
    readonly property int minWs: isExternalScreen ? 6 : 1
    readonly property int maxWs: isExternalScreen ? 10 : 5

    // Workspaces obtidos via IPC do Sway
    property var swayWorkspaces: []

    Process {
        id: wsProc
        command: ["swaymsg", "-t", "get_workspaces"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.swayWorkspaces = JSON.parse(text)
                } catch (_) {}
            }
        }
    }

    Process {
        id: wsSub
        running: true
        command: ["swaymsg", "-m", "-t", "subscribe", "[\"workspace\", \"output\"]"]
        stdout: SplitParser {
            onRead: _ => {
                if (!wsProc.running) wsProc.running = true
            }
        }
    }

    // Monta estritamente a lista de botões da saída atual
    readonly property var currentWorkspaces: {
        const list = []
        for (let i = minWs; i <= maxWs; i++) {
            list.push(i)
        }
        return list
    }

    Row {
        id: wsRow
        spacing: 4
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: root.currentWorkspaces

            Rectangle {
                id: wsButton
                required property int modelData

                readonly property var wsInfo: {
                    for (let i = 0; i < root.swayWorkspaces.length; i++) {
                        if (root.swayWorkspaces[i].num === modelData)
                            return root.swayWorkspaces[i]
                    }
                    return null
                }

                readonly property bool isFocused: wsInfo ? wsInfo.focused : false
                readonly property bool isVisible: wsInfo ? wsInfo.visible : false
                readonly property bool isUrgent: wsInfo ? wsInfo.urgent : false
                readonly property bool hasWindows: wsInfo !== null

                width: root.wsHeight
                height: root.wsHeight
                radius: (typeof Theme.moduleRadius !== "undefined") ? Theme.moduleRadius : 6

                color: isFocused ? Theme.accent
                     : isUrgent  ? Theme.alert
                     : wsMa.containsMouse ? Qt.alpha(Theme.fg, 0.15)
                     : hasWindows ? Qt.alpha(Theme.fg, 0.08)
                     : "transparent"

                border.width: 1
                border.color: isFocused ? Theme.accent
                            : isUrgent ? Theme.alert
                            : hasWindows ? Qt.alpha(Theme.fg, 0.2)
                            : Qt.alpha(Theme.fg, 0.05)

                Behavior on color { ColorAnimation { duration: 120 } }

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    topPadding: 2

                    text: wsButton.modelData
                    font.family: Theme.fontFamily
                    font.pixelSize: (typeof Theme.fontSize !== "undefined") ? Theme.fontSize : 13
                    font.bold: wsButton.isFocused
                    color: wsButton.isFocused ? Theme.selfg
                         : wsButton.isUrgent ? Theme.selfg
                         : wsButton.hasWindows ? Theme.fg
                         : Qt.alpha(Theme.fg, 0.4)
                }

                MouseArea {
                    id: wsMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Quickshell.execDetached(["swaymsg", "workspace", "number", String(wsButton.modelData)])
                    }
                }
            }
        }
    }
}
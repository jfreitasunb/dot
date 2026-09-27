import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    implicitWidth: wsRow.implicitWidth
    implicitHeight: wsRow.implicitHeight

    // Identifica o nome do monitor onde esta barra está renderizada
    readonly property string screenName: {
        const win = root.QsWindow.window
        return (win && win.screen) ? win.screen.name : ""
    }

    // Identifica se a instância atual está em uma saída externa
    readonly property bool isExternalScreen: screenName === "DP-1" || screenName === "HDMI-A-1"

    // Verifica se qualquer monitor externo compatível está conectado no momento
    readonly property bool hasExternalConnected: {
        const screens = Quickshell.screens || []
        for (let i = 0; i < screens.length; i++) {
            const name = screens[i].name
            if (name === "DP-1" || name === "HDMI-A-1") return true
        }
        return false
    }

    // Intervalo de workspaces:
    // - Se for a tela externa (DP-1 ou HDMI-A-1): 6 a 10
    // - Se for a tela embutida (eDP-1): 1 a 5 se houver tela externa, ou 1 a 10 se estiver sozinho
    readonly property int minWs: isExternalScreen ? 6 : 1
    readonly property int maxWs: isExternalScreen ? 10 : (hasExternalConnected ? 5 : 10)

    // Lista de workspaces monitorada via IPC do Sway
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
        command: ["swaymsg", "-m", "-t", "subscribe", "[\"workspace\"]"]
        stdout: SplitParser {
            onRead: _ => {
                if (!wsProc.running) wsProc.running = true
            }
        }
    }

    // Gera o intervalo numérico para a tela atual
    readonly property var currentRange: {
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
            model: root.currentRange

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

                width: 24
                height: 24
                radius: 6

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
                    anchors.centerIn: parent
                    text: wsButton.modelData
                    font.family: Theme.fontFamily
                    font.pixelSize: 12
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
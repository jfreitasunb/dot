import QtQuick
import Quickshell
import Quickshell.Wayland

// The bar window adaptada para Sway via wlr-layer-shell
PanelWindow {
    id: root

    // Integração com o compositor Sway (wlr-layer-shell)
    WlrLayershell.namespace: "sway-bar"
    WlrLayershell.layer: WlrLayer.Top
    exclusionMode: ExclusionMode.Auto

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.effectiveBarHeight
    color: "transparent"
    visible: Theme.barStateReady

    Rectangle {
        id: panel
        anchors.fill: parent
        // Margens simétricas em todas as extremidades para preservar o aspeto flutuante
        anchors.topMargin: Theme.edgeInset
        anchors.leftMargin: Theme.edgeInset
        anchors.rightMargin: Theme.edgeInset
        anchors.bottomMargin: Theme.edgeInset

        radius: Theme.barRadius
        color: Qt.alpha(Theme.bg, 0.94)
        border.width: 1
        border.color: Qt.alpha(Theme.accent, 0.35)

        Behavior on color { ColorAnimation { duration: 400 } }
        Behavior on border.color { ColorAnimation { duration: 400 } }

        // Botão direito no fundo abre as opções de layout/ajustes
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            onClicked: {
                if (typeof layoutBtn !== "undefined" && layoutBtn) {
                    layoutBtn.pickerVisible = !layoutBtn.pickerVisible
                }
            }
        }

        Row {
            id: leftCluster
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Launcher {}

            // Passa o ecrã atual para exibir apenas os workspaces deste monitor
            Workspaces {
                targetScreen: root.screen
            }

            // LayoutButton { id: layoutBtn }
        }

        Title {
            anchors.verticalCenter: parent.verticalCenter
            readonly property real gapL: leftCluster.x + leftCluster.width + 24
            readonly property real gapR: rightCluster.x - 24
            width: Math.max(0, Math.min(implicitWidth, gapR - gapL))
            x: Math.max(gapL, Math.min((parent.width - width) / 2, gapR - width))
            visible: width > 40
        }

        Row {
            id: rightCluster
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            Media {}
            //Weather {}
            Metrics {}
            Volume {}
            Network {}
           // Updates {}
            Tray {}
            Bell {}
            Clock {}
            MicMute {}
            CapsLock {}
            Screenshot {}
            Commands {}
        }
    }
}

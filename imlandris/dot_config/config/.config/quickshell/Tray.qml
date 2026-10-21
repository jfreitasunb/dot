import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

// StatusNotifierItem tray (SNI via DBus) compatível com Sway / Wayland
Rectangle {
    id: root

    readonly property var trayItems: SystemTray.items.values || []

    visible: trayItems.length > 0
    implicitWidth: trayRow.implicitWidth + Math.round(14 * Theme.barScale)
    implicitHeight: Theme.moduleHeight
    radius: 8
    color: Qt.alpha(Theme.fg, 0.07)

    Row {
        id: trayRow
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: root.trayItems

            MouseArea {
                id: trayItem
                required property SystemTrayItem modelData

                width: Math.round(20 * Theme.barScale)
                height: Theme.moduleHeight
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                hoverEnabled: true

                IconImage {
                    anchors.centerIn: parent
                    implicitSize: Math.round(16 * Theme.barScale)
                    source: trayItem.modelData.icon || ""
                }

                // Ancoragem compatível com Quickshell
                QsMenuAnchor {
                    id: menuAnchor
                    menu: trayItem.modelData.menu
                    anchor.item: trayItem
                    anchor.rect.y: trayItem.height + 4
                }

                onClicked: m => {
                    if (m.button === Qt.LeftButton) {
                        modelData.activate(m.x, m.y)
                    } else if (m.button === Qt.MiddleButton) {
                        modelData.secondaryActivate(m.x, m.y)
                    } else if (modelData.hasMenu) {
                        menuAnchor.open()
                    }
                }
            }
        }
    }
}

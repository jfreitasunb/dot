import QtQuick
import Quickshell
import Quickshell.Wayland

// Shared shell for every bar popup — adaptado para Sway
PanelWindow {
    id: root

    property Item anchorItem
    property real cardWidth: 300
    property real cardHeight: 300
    readonly property real cardPadding: 14
    property bool alignRight: false

    default property alias content: inner.data

    visible: false
    color: "transparent"

    screen: (anchorItem && anchorItem.QsWindow.window) ? anchorItem.QsWindow.window.screen : null
    anchors { top: true; bottom: true; left: true; right: true }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-popup"
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    property real ax: 0
    property real ay: 0

    onVisibleChanged: {
        if (visible && anchorItem) {
            const win = anchorItem.QsWindow.window
            if (win && win.contentItem) {
                const pos = anchorItem.mapToItem(win.contentItem, 0, 0)
                ax = pos.x
                ay = pos.y
            } else {
                const p = anchorItem.mapToGlobal(0, 0)
                ax = p.x
                ay = p.y
            }
            inner.forceActiveFocus()
            enterAnim.restart()
        }
    }

    // Catcher externo: clique fora da área do card fecha o popout
    MouseArea {
        anchors.fill: parent
        onClicked: mouse => {
            const cardPos = card.mapFromItem(parent, mouse.x, mouse.y)
            const inside = cardPos.x >= 0 && cardPos.x <= card.width &&
                           cardPos.y >= 0 && cardPos.y <= card.height
            if (!inside) {
                root.visible = false
            }
        }
    }

    Rectangle {
        id: card

        x: root.alignRight ? root.width - width - 8
         : Math.min(Math.max(root.ax + (root.anchorItem?.width ?? 0) / 2 - width / 2, 8),
                    root.width - width - 8)
        y: root.ay + (root.anchorItem?.height ?? 0) + 12

        transform: Translate { id: slide; y: 0 }

        ParallelAnimation {
            id: enterAnim
            NumberAnimation { target: slide; property: "y"; from: -10; to: 0
                              duration: 160; easing.type: Easing.OutCubic }
            NumberAnimation { target: card; property: "opacity"; from: 0; to: 1
                              duration: 160 }
        }

        width: root.cardWidth
        height: root.cardHeight
        radius: 12
        color: Qt.alpha(Theme.bg, 0.94)
        border.width: 1
        border.color: Qt.alpha(Theme.accent, 0.4)

        Behavior on color { ColorAnimation { duration: 250 } }

        Item {
            id: inner
            anchors.fill: parent
            anchors.margins: root.cardPadding
            focus: true
            // Keys anexado estritamente ao Item interno
            Keys.onEscapePressed: root.visible = false
        }
    }
}

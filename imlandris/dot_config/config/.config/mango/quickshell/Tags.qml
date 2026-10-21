import QtQuick

// Split desktops: displays a subset of tags based on startIndex and numTags.
// Widths and colors animate on every report line.
Item {
    property int startIndex: 0
    property int numTags: 5

    implicitWidth: tagRow.implicitWidth
    implicitHeight: Math.round(22 * Theme.barScale)

    WheelHandler {
        onWheel: ev => Wm.cycleTag(ev.angleDelta.y > 0 ? -1 : 1)
    }

    Row {
        id: tagRow
        spacing: 4
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: numTags

            Rectangle {
                id: tag
                required property int index
                
                // Mapeia o índice local do Repeater (0 a 4) para o índice real do Wm (ex: 0 a 4 ou 5 a 9)
                readonly property int realIndex: index + startIndex
                
                readonly property bool selected: (Wm.seltags & (1 << realIndex)) !== 0
                readonly property bool occupied: (Wm.occtags & (1 << realIndex)) !== 0
                readonly property bool urgent: (Wm.urgtags & (1 << realIndex)) !== 0

                width: Math.round((selected ? 30 : 22) * Theme.barScale)
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
                    // O texto exibe o índice real da tag + 1 (ex: 1 a 5 ou 6 a 10)
                    text: tag.realIndex + 1
                    color: tag.urgent ? Theme.bg
                         : tag.selected ? Theme.selfg
                         : tag.occupied ? Qt.alpha(Theme.fg, 0.85)
                         : Qt.alpha(Theme.fg, 0.4)
                    font.family: Theme.fontFamily
                    font.pixelSize: Math.round(12 * Theme.barScale)
                    font.bold: tag.selected
                    Behavior on color { ColorAnimation { duration: 180 } }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    onClicked: m => {
                        if (m.button === Qt.MiddleButton)
                            Wm.sendToTag(tag.realIndex)
                        else
                            Wm.viewTag(tag.realIndex)
                    }
                }
            }
        }
    }
}
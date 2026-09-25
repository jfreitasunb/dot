import QtQuick

// Month calendar popup ancorado sob o relógio compatível com Sway
Popout {
    id: root

    property date shown: new Date()

    cardWidth: 280
    cardHeight: 310

    onVisibleChanged: {
        if (visible)
            shown = new Date()
    }

    Column {
        anchors.fill: parent
        spacing: 8

        // Header: ‹ mês ano ›
        Item {
            width: parent.width
            height: 28

            Text {
                id: prevBtn
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: "󰅁"
                color: Theme.accent
                font.family: Theme.fontFamily
                font.pixelSize: 18

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -6
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.shown = new Date(root.shown.getFullYear(), root.shown.getMonth() - 1, 1)
                }
            }

            Text {
                anchors.centerIn: parent
                text: Qt.formatDate(root.shown, "MMMM yyyy")
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: 14
                font.bold: true

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.shown = new Date()
                }
            }

            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: "󰅂"
                color: Theme.accent
                font.family: Theme.fontFamily
                font.pixelSize: 18

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -6
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.shown = new Date(root.shown.getFullYear(), root.shown.getMonth() + 1, 1)
                }
            }
        }

        // Cabeçalho dos dias da semana
        Row {
            width: parent.width

            Repeater {
                model: 7

                Text {
                    required property int index
                    width: parent.width / 7
                    text: Qt.locale().dayName((Qt.locale().firstDayOfWeek + index) % 7, Locale.ShortFormat)
                    color: Qt.alpha(Theme.fg, 0.5)
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        // Grid dos dias
        Grid {
            id: dayGrid
            width: parent.width
            columns: 7
            rowSpacing: 2

            readonly property real cellW: width / 7
            readonly property date firstDayOfMonth: new Date(root.shown.getFullYear(), root.shown.getMonth(), 1)
            readonly property int startOffset: (firstDayOfMonth.getDay() - Qt.locale().firstDayOfWeek + 7) % 7

            Repeater {
                model: 42

                Item {
                    id: cell
                    required property int index

                    width: dayGrid.cellW
                    height: 28

                    readonly property date cellDate: new Date(
                        dayGrid.firstDayOfMonth.getFullYear(),
                        dayGrid.firstDayOfMonth.getMonth(),
                        1 - dayGrid.startOffset + index
                    )

                    readonly property bool inMonth: cellDate.getMonth() === root.shown.getMonth()
                    readonly property bool isToday: {
                        const now = new Date()
                        return cellDate.getFullYear() === now.getFullYear()
                            && cellDate.getMonth() === now.getMonth()
                            && cellDate.getDate() === now.getDate()
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: 24
                        height: 24
                        radius: 12
                        color: cell.isToday ? Theme.selbg : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: cell.cellDate.getDate()
                            color: cell.isToday ? Theme.selfg
                                 : cell.inMonth ? Theme.fg
                                 : Qt.alpha(Theme.fg, 0.25)
                            font.family: Theme.fontFamily
                            font.pixelSize: 12
                            font.bold: cell.isToday
                        }
                    }
                }
            }
        }
    }
}

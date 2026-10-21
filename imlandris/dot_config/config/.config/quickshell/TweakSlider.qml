import QtQuick

// Labeled slider para popups de ajustes (brilho, volume, gaps, etc.)
Item {
    id: ts

    property string label
    property real from: 0
    property real to: 40
    property real value: 0
    property bool isInt: true
    property string suffix: ""

    required property var applyFn
    required property var persistFn

    signal committed(real v)

    property real drag: 0
    readonly property real shown: ma.pressed ? drag : value

    function fmt(v) { 
        return isInt ? Math.round(v) : Math.round(v * 100) / 100 
    }

    width: parent.width
    height: 36

    Text {
        anchors.left: parent.left
        anchors.top: parent.top
        text: ts.label
        color: Theme.fg
        font.family: Theme.fontFamily
        font.pixelSize: 11
    }

    Text {
        anchors.right: parent.right
        anchors.top: parent.top
        text: ts.fmt(ts.shown) + ts.suffix
        color: Theme.accent
        font.family: Theme.fontFamily
        font.pixelSize: 11
        font.bold: true
    }

    Rectangle {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 7
        height: 4
        radius: 2
        color: Qt.alpha(Theme.fg, 0.12)

        // Prevenção contra divisão por zero
        readonly property real range: Math.max(0.0001, ts.to - ts.from)
        readonly property real frac: Math.min(Math.max((ts.shown - ts.from) / range, 0), 1)

        Rectangle {
            width: track.frac * parent.width
            height: parent.height
            radius: parent.radius
            color: Theme.accent
        }

        Rectangle {
            x: track.frac * parent.width - width / 2
            anchors.verticalCenter: parent.verticalCenter
            width: 12
            height: 12
            radius: 6
            color: Theme.fg
            border.width: 2
            border.color: Theme.bg
        }
    }

    // Limita chamadas ao backend durante o arraste
    Timer {
        id: applyThrottle
        interval: 60
        onTriggered: ts.applyFn(ts.fmt(ts.drag))
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        anchors.topMargin: 12
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        function at(mx) {
            const f = Math.min(Math.max(mx / width, 0), 1)
            return ts.from + f * (ts.to - ts.from)
        }

        onPressed: m => { 
            ts.drag = at(m.x)
            applyThrottle.restart() 
        }

        onPositionChanged: m => {
            if (pressed) { 
                ts.drag = at(m.x)
                applyThrottle.restart() 
            }
        }

        onReleased: {
            applyThrottle.stop()
            const v = ts.fmt(ts.drag)
            ts.applyFn(v)
            ts.persistFn(v)
            ts.committed(v)
        }

        // Ajuste fino via scroll
        onWheel: wheel => {
            const step = ts.isInt ? 1 : (ts.to - ts.from) / 100
            const dir = wheel.angleDelta.y > 0 ? 1 : -1
            const next = Math.min(Math.max(ts.shown + dir * step, ts.from), ts.to)
            const v = ts.fmt(next)
            ts.drag = v
            ts.applyFn(v)
            ts.persistFn(v)
            ts.committed(v)
        }
    }
}

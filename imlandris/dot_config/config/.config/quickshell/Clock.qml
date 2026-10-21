import QtQuick
import Quickshell

// Date + 12-hour time (the slstatus formats), with a calendar on click.
BarModule {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    label: Qt.formatDateTime(clock.date, "dd/MM/yyyy") + "  " + Qt.formatDateTime(clock.date, "hh:mm")

    onClicked: calendar.visible = !calendar.visible

    CalendarPopup {
        id: calendar
        anchorItem: root
    }
}

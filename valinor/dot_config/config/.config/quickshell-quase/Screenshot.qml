import QtQuick
import Quickshell

// Screenshot: left = region (slurp), right = full screen. grim saves to
// ~/Screenshots (scripts/screenshot).
BarModule {
    icon: "󰻛"
    iconColor: Theme.magenta
    onClicked: mouse => Quickshell.execDetached(["/home/jfreitas/.bin/screenshot",
        mouse.button === Qt.RightButton ? "full" : "region"])
}

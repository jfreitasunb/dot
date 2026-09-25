import QtQuick
import Quickshell
import Quickshell.Io

// Pending-updates indicator para Sway
BarModule {
    id: root

    property int count: 0
    visible: count > 0
    icon: "󰚰"
    iconColor: Theme.accent
    label: String(count)

    function runCheck() {
        if (!checkProc.running) {
            checkProc.running = true
        }
    }

    Process {
        id: checkProc
        command: ["sh", "-c",
            "apt-get -s -o Debug::NoLocking=1 dist-upgrade 2>/dev/null | grep -c '^Inst'"]
        stdout: StdioCollector {
            onStreamFinished: root.count = parseInt(text.trim()) || 0
        }
    }

    Timer {
        interval: 3600 * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.runCheck()
    }

    Timer {
        id: recheck
        interval: 3 * 60 * 1000
        onTriggered: root.runCheck()
    }

    onClicked: mouse => {
        if (mouse.button === Qt.MiddleButton) {
            root.runCheck()
        } else {
            // Usa --class/--app-id para facilitar regras no sway/config:
            // for_window [app_id="system-update"] floating enable
            Quickshell.execDetached([
                "kitty", 
                "--class", "system-update", 
                "-e", "sh", "-c",
                "sudo apt update && sudo apt full-upgrade; " +
                "printf '\\ndone - press enter to close '; read _"
            ])
            recheck.restart()
        }
    }
}

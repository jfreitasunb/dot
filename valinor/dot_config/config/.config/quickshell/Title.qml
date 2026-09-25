import QtQuick
import Quickshell
import Quickshell.Io

// Focused window title para Sway via IPC
Text {
    id: root

    property string focusedTitle: ""

    text: focusedTitle
    color: Qt.alpha(Theme.fg, 0.75)
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    elide: Text.ElideRight
    horizontalAlignment: Text.AlignHCenter
    Behavior on color { ColorAnimation { duration: 250 } }

    // Busca o título da janela já focada na inicialização
    Process {
        id: initProc
        command: ["sh", "-c", "swaymsg -t get_tree | jq -r '.. | (.nodes? // empty)[] | select(.focused == true) | .name // empty'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim().length > 0) {
                    root.focusedTitle = text.trim()
                }
            }
        }
    }

    // Monitora eventos em tempo real do Sway (focus, title, close)
    Process {
        id: eventProc
        running: true
        command: ["swaymsg", "-m", "-t", "subscribe", "[\"window\"]"]

        stdout: SplitParser {
            onRead: data => {
                try {
                    const evt = JSON.parse(data)
                    if (evt.change === "focus" || evt.change === "title") {
                        root.focusedTitle = evt.container?.name || ""
                    } else if (evt.change === "close") {
                        // Quando fecha, solicita refresh rápido ou limpa
                        initProc.running = true
                    }
                } catch (_) {
                    // Ignora linhas malformadas eventuais
                }
            }
        }
    }
}

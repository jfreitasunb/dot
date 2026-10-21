//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    // Cria uma barra para cada monitor conectado
    Variants {
        model: Quickshell.screens

        delegate: Bar {
            required property var modelData
            screen: modelData
        }
    }

    // Gerenciador de wallpapers (inicializa o Timer de 2h e o IPC target "wallpapers")
    Wallpapers {
        id: wallpapers
    }

    // Handler IPC para controle da barra e do compositor via atalhos/scripts
    // Exemplo de chamada: qs -p ~/.config/sway/quickshell ipc call wm reload
    IpcHandler {
        target: "wm"

        function reload(): void {
            Quickshell.execDetached(["swaymsg", "reload"])
        }

        function applyGaps(innerGaps: int): void {
            Quickshell.execDetached(["swaymsg", "gaps", "inner", "all", "set", String(innerGaps)])
        }
    }
}
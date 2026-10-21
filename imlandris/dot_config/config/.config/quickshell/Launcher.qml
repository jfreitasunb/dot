import QtQuick
import Quickshell

// Debian swirl — menu de controle e lançador para Sway
BarModule {
    id: root

    icon: ""  // Debian swirl (Font Logos)
    iconFont: "FiraCode Nerd Font"
    iconColor: Theme.accent

    // Executa o wofi alternando (se já estiver aberto, fecha; senão, abre)
    readonly property var launcherCmd: [
        "sh", "-c",
        "pkill -x wofi || wofi --show drun --allow-images --prompt 'Buscar...'"
    ]

    // Se preferir a chamada direta simples sem toggle:
    // readonly property var launcherCmd: ["wofi", "--show", "drun", "--allow-images"]

    onClicked: mouse => {
        if (mouse.button === Qt.RightButton) {
            picker.toggle()
        } else if (mouse.button === Qt.MiddleButton) {
            picker.applyRandom()
        } else {
            Quickshell.execDetached(launcherCmd)
        }
    }

    WallpaperPicker {
        id: picker
        anchorItem: root
    }
}
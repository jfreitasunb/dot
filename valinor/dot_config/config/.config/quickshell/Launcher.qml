import QtQuick
import Quickshell

// Debian swirl — menu de controle e lançador para Sway
BarModule {
    id: root

    icon: ""  // Debian swirl (Font Logos)
    iconFont: "FiraCode Nerd Font"
    iconColor: Theme.accent

    // Ajuste para o lançador de sua preferência no Sway:
    // Exemplos: ["fuzzel"], ["rofi", "-show", "drun"], ["wofi", "--show", "drun"]
    readonly property var launcherCmd: ["fuzzel"]

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

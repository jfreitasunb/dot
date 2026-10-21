pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Live palette e tema global adaptado para Sway
Singleton {
    id: root

    // Diretório base da configuração (~/.config/sway)
    readonly property string configDir: {
        const xdg = Quickshell.env("XDG_CONFIG_HOME")
        if (xdg && xdg.trim().length > 0)
            return xdg.trim() + "/sway"

        const home = Quickshell.env("HOME") || ("/home/" + (Quickshell.env("USER") || ""))
        return home + "/.config/sway"
    }

    // Altura da barra e multiplicador de escala
    property int barHeight: 42
    property real barUserScale: 1.0

    // Sinalizador de prontidão para mapear a janela na camada superior
    property int _barStateLoads: 0
    readonly property bool barStateReady: _barStateLoads >= 2

    Timer {
        running: !root.barStateReady
        interval: 800
        onTriggered: root._barStateLoads = 2
    }

    // Paleta padrão (fallback dark)
    property color bg: "#0d1117"
    property color altbg: "#161b22"
    property color fg: "#c9d1d9"
    property color border: "#30363d"
    property color primary: "#58a6ff"
    property color secondary: "#8b949e"
    property color alert: "#f85149"
    property color disabled: "#484f58"

    readonly property color accent: primary
    readonly property color selbg: primary
    readonly property color selfg: bg
    readonly property color red: alert
    readonly property color yellow: primary
    readonly property color blue: secondary
    readonly property color green: secondary
    readonly property color cyan: secondary
    readonly property color magenta: secondary

    readonly property string fontFamily: "JetBrainsMono Nerd Font"

    // Cálculo seguro de escala lógica compatível com saídas Wayland/Sway
    readonly property real autoScale: {
        const screens = Quickshell.screens || []
        const s = screens.length > 0 ? screens[0] : null
        const h = (s && s.height > 0) ? s.height : 1080
        const factor = h / 1080
        return isNaN(factor) ? 1.0 : Math.min(Math.max(factor, 0.75), 2.5)
    }

    readonly property int edgeInset: Math.round(8 * autoScale)
    readonly property int barRadius: 8

    readonly property real barScale: autoScale * barUserScale
    readonly property int fontSize: Math.round(13 * barScale)
    readonly property int iconSize: Math.round(15 * barScale)
    readonly property int moduleHeight: Math.round(26 * barScale)
    readonly property int effectiveBarHeight: Math.max(barHeight, moduleHeight + edgeInset + 8)

    // Persistência da altura da barra (~/.config/sway/bar-height)
    FileView {
        path: root.configDir + "/bar-height"
        watchChanges: true
        onFileChanged: reload()
        onLoadFailed: root._barStateLoads++
        onLoaded: {
            root._barStateLoads++
            const v = parseInt(text().trim())
            if (!isNaN(v))
                root.barHeight = Math.min(Math.max(v, 32), 80)
        }
    }

    // Persistência da escala do usuário (~/.config/sway/bar-scale)
    FileView {
        path: root.configDir + "/bar-scale"
        watchChanges: true
        onFileChanged: reload()
        onLoadFailed: root._barStateLoads++
        onLoaded: {
            root._barStateLoads++
            const v = parseFloat(text().trim())
            if (!isNaN(v))
                root.barUserScale = Math.min(Math.max(v, 0.7), 2.0)
        }
    }

    // Monitora paleta de cores dinâmica do tema (~/.config/sway/colors.ini)
    FileView {
        path: root.configDir + "/colors.ini"
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.parseIni(text())
    }

    function parseIni(t) {
        if (!t) return
        const map = {}
        for (const line of t.split("\n")) {
            const m = line.match(/^\s*([A-Za-z-]+)\s*=\s*(#[0-9a-fA-F]{3,8})/)
            if (m)
                map[m[1]] = m[2]
        }
        if (map["background"]) bg = map["background"]
        if (map["background-alt"]) altbg = map["background-alt"]
        if (map["foreground"]) fg = map["foreground"]
        if (map["border"]) border = map["border"]
        if (map["primary"]) primary = map["primary"]
        if (map["secondary"]) secondary = map["secondary"]
        if (map["alert"]) alert = map["alert"]
        if (map["disabled"]) disabled = map["disabled"]
    }
}

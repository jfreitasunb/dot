import QtQuick
import Quickshell
import Quickshell.Io

// Current layout indicator adaptado para Sway
BarModule {
    id: root

    property alias pickerVisible: picker.visible

    // Modos do Sway: splith, splitv, tabbed, stacking, floating
    property string currentLayout: "splith"
    property bool isFloating: false

    readonly property var glyphs: ({
        "splith": "󰤼",
        "splitv": "󰤻",
        "tabbed": "󰓩",
        "stacking": "󰪍",
        "floating": "󰉈"
    })

    icon: isFloating ? glyphs["floating"] : (glyphs[currentLayout] || "󰤼")
    iconColor: Theme.fg

    function parseTree(jsonStr) {
        try {
            const rootNode = JSON.parse(jsonStr)
            
            // Busca recursiva pelo nó focado
            function findFocused(node) {
                if (!node) return null
                if (node.focused) return node
                const list = (node.nodes || []).concat(node.floating_nodes || [])
                for (const child of list) {
                    const res = findFocused(child)
                    if (res) return res
                }
                return null
            }

            const target = findFocused(rootNode)
            if (target) {
                root.isFloating = target.type === "floating_con"
                // No Sway, se for uma janela filha, o layout relevante vem do nó pai (workspace ou split container)
                root.currentLayout = target.layout || "splith"
            }
        } catch (_) {}
    }

    // Leitura inicial do layout atual
    Process {
        id: initProc
        running: true
        command: ["swaymsg", "-t", "get_tree"]
        stdout: StdioCollector {
            onStreamFinished: root.parseTree(text)
        }
    }

    // Monitora alterações de foco e layout em tempo real
    Process {
        id: eventProc
        running: true
        command: ["swaymsg", "-m", "-t", "subscribe", "[\"window\", \"workspace\"]"]
        stdout: SplitParser {
            onRead: _ => {
                if (!initProc.running) {
                    initProc.running = true
                }
            }
        }
    }

    readonly property var layoutCycle: ["splith", "tabbed", "stacking"]

    function cycleLayout(dir) {
        let idx = layoutCycle.indexOf(currentLayout)
        if (idx < 0) idx = 0
        const nextIdx = (idx + dir + layoutCycle.length) % layoutCycle.length
        const nextLayout = layoutCycle[nextIdx]
        Quickshell.execDetached(["swaymsg", "layout", nextLayout])
        currentLayout = nextLayout
    }

    onClicked: picker.visible = !picker.visible
    onScrolled: dir => root.cycleLayout(dir > 0 ? 1 : -1)

    LayoutPicker {
        id: picker
        anchorItem: root
    }
}

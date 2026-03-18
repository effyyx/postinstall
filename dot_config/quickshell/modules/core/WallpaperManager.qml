pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // ── state ─────────────────────────────────────────────────────────────
    property var wallpaperList: []
    property var wallHashMap: ({})
    property string currentWallpaper: ""
    property bool wallsLoaded: false
    property bool thumbsReady: false
    property bool walApplying: false

    // ── matugen colors ────────────────────────────────────────────────────
    property color walBackground: "#141318"
    property color walForeground: "#e6e1e9"
    property color walColor1: "#ffb4ab"
    property color walColor2: "#eeb8c9"
    property color walColor4: "#cbc3dc"
    property color walColor5: "#cdbdff"
    property color walColor8: "#938f99"
    property color walColor13: "#eeb8c9"

    // ── filtered wallpapers ───────────────────────────────────────────────
    property var filteredWallpapers: {
        if (AppState.wallSearchTerm === "") return wallpaperList
        var result = []
        for (var i = 0; i < wallpaperList.length; i++) {
            if (wallpaperList[i].name.toLowerCase().includes(AppState.wallSearchTerm))
                result.push(wallpaperList[i])
        }
        return result
    }

    // ── functions ─────────────────────────────────────────────────────────
    function load() {
        root.wallpaperList = []
        root.wallsLoaded = false
        root.thumbsReady = false
        wallpaperListProc.running = true
    }

    function apply(wallpaper) {
        root.currentWallpaper = wallpaper.path
        root.walApplying = true
        applyWallProc.command = ["bash", "-c",
            "ln -sf '" + wallpaper.path + "' '" + Config.wallpaperDir + "/current' && " +
            "swww img '" + wallpaper.path + "' --transition-type any --transition-duration 2 & " +
            "matugen image '" + wallpaper.path + "' --source-color-index 0 && " +
            "sleep 0.3"
        ]
        applyWallProc.running = true
    }

    // ── processes ─────────────────────────────────────────────────────────
    Process {
        id: thumbDirProc
        command: ["bash", "-c", "mkdir -p '" + Config.thumbCacheDir + "'"]
        onExited: root.load()
    }

    Process {
        id: wallpaperListProc
        command: ["bash", "-c",
            "find '" + Config.wallpaperDir + "' -maxdepth 1 -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.png' -o -iname '*.webp' \\) ! -name '.*' ! -name 'tn_*' ! -name '.current-blurred*' | sort"
        ]
        stdout: SplitParser {
            onRead: data => {
                var path = data.trim()
                if (path.length === 0) return
                var parts = path.split("/")
                var name = parts[parts.length - 1]
                var current = root.wallpaperList.slice()
                current.push({ name: name, path: path })
                root.wallpaperList = current
            }
        }
        onExited: {
            root.wallsLoaded = true
            batchHashProc.running = true
        }
    }

    Process {
        id: batchHashProc
        command: ["bash", "-c",
            "find '" + Config.wallpaperDir + "' -maxdepth 1 -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.png' -o -iname '*.webp' \\) ! -name '.*' ! -name 'tn_*' ! -name '.current-blurred*' | " +
            "while IFS= read -r f; do hash=$(echo -n \"$f\" | md5sum | cut -d' ' -f1); echo \"$f|$hash\"; done"
        ]
        stdout: SplitParser {
            onRead: data => {
                var line = data.trim()
                if (line.length === 0) return
                var parts = line.split("|")
                if (parts.length < 2) return
                var map = Object.assign({}, root.wallHashMap)
                map[parts[0]] = parts[1]
                root.wallHashMap = map
            }
        }
        onExited: thumbGenProc.running = true
    }

    Process {
        id: thumbGenProc
        command: ["bash", "-c",
            "cd '" + Config.thumbCacheDir + "' && " +
            "if command -v vipsthumbnail >/dev/null 2>&1; then " +
            " find '" + Config.wallpaperDir + "' -maxdepth 1 -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.png' -o -iname '*.webp' \\) ! -name '.*' ! -name 'tn_*' ! -name '.current-blurred*' | " +
            " while IFS= read -r f; do " +
            " hash=$(echo -n \"$f\" | md5sum | cut -d' ' -f1); " +
            " thumb='" + Config.thumbCacheDir + "/${hash}.jpg'; " +
            " if [ ! -f \"$thumb\" ] || [ \"$f\" -nt \"$thumb\" ]; then " +
            " case \"$f\" in " +
            " *.gif) convert \"${f}[0]\" -define jpeg:size=400x300 -thumbnail 180x120^ -gravity center -extent 180x120 -strip -interlace none -quality 85 \"$thumb\" 2>/dev/null & ;; " +
            " *) vipsthumbnail \"$f\" -s 180x120 -o \"${thumb}[Q=85,strip]\" 2>/dev/null || " +
            " convert \"$f\" -define jpeg:size=400x300 -thumbnail 180x120^ -gravity center -extent 180x120 -strip -interlace none -quality 85 \"$thumb\" 2>/dev/null & ;; " +
            " esac; " +
            " fi; " +
            " done; " +
            "else " +
            " find '" + Config.wallpaperDir + "' -maxdepth 1 -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.png' -o -iname '*.webp' \\) ! -name '.*' ! -name 'tn_*' ! -name '.current-blurred*' | " +
            " while IFS= read -r f; do " +
            " hash=$(echo -n \"$f\" | md5sum | cut -d' ' -f1); " +
            " thumb='" + Config.thumbCacheDir + "/${hash}.jpg'; " +
            " if [ ! -f \"$thumb\" ] || [ \"$f\" -nt \"$thumb\" ]; then " +
            " case \"$f\" in " +
            " *.gif) convert \"${f}[0]\" -define jpeg:size=400x300 -thumbnail 180x120^ -gravity center -extent 180x120 -strip -interlace none -quality 85 \"$thumb\" 2>/dev/null & ;; " +
            " *) convert \"$f\" -define jpeg:size=400x300 -thumbnail 180x120^ -gravity center -extent 180x120 -strip -interlace none -quality 85 \"$thumb\" 2>/dev/null & ;; " +
            " esac; " +
            " fi; " +
            " done; " +
            "fi; wait"
        ]
        onExited: root.thumbsReady = true
    }

    Process {
        id: applyWallProc
        onExited: {
            matugenColorsProc.running = true
            walStepMako.running = true
        }
    }

    Process {
        id: matugenColorsProc
        command: ["bash", "-c",
            "matugen image $(readlink -f '" + Config.wallpaperDir + "/current' 2>/dev/null || echo '') --dry-run --json hex --old-json-output --source-color-index 0 2>/dev/null | python3 -c \"\nimport sys,json\nd=json.load(sys.stdin)\nc=d['colors']\nprint(json.dumps({'background':c['surface']['default'],'foreground':c['on_surface']['default'],'color1':c['error']['default'],'color2':c['tertiary']['default'],'color4':c['secondary']['default'],'color5':c['primary']['default'],'color8':c['outline']['default'],'color13':c['tertiary']['default']}))\n\""
        ]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                try {
                    var json = JSON.parse(data)
                    if (json.background) root.walBackground = json.background
                    if (json.foreground) root.walForeground = json.foreground
                    if (json.color1) root.walColor1 = json.color1
                    if (json.color2) root.walColor2 = json.color2
                    if (json.color4) root.walColor4 = json.color4
                    if (json.color5) root.walColor5 = json.color5
                    if (json.color8) root.walColor8 = json.color8
                    if (json.color13) root.walColor13 = json.color13
                } catch(e) {}
            }
        }
        onExited: {
            if (root.walApplying) walStepBlur.running = true
        }
    }

    Process {
        id: walStepMako
        command: ["bash", "-c", "makoctl reload"]
    }

    Process {
        id: walStepBlur
        command: {
            var wp = root.currentWallpaper
            var res = Config.resolution
            var out = Config.wallpaperDir + "/.current-blurred.jpg"
            return wp.endsWith(".gif")
                ? ["bash", "-c", "ffmpeg -y -i '" + wp + "' -vf 'scale=" + res + ":force_original_aspect_ratio=increase,crop=" + res + ",gblur=sigma=40' -vframes 1 -q:v 2 '" + out + "'"]
                : ["bash", "-c", "ffmpeg -y -i '" + wp + "' -vf 'scale=" + res + ":force_original_aspect_ratio=increase,crop=" + res + ",gblur=sigma=40' -q:v 2 '" + out + "'"]
        }
        onExited: {
            root.walApplying = false
        }
    }

    Process {
        id: currentWallProc
        command: ["bash", "-c", "readlink -f '" + Config.wallpaperDir + "/current' 2>/dev/null || echo ''"]
        stdout: SplitParser { onRead: data => root.currentWallpaper = data.trim() }
    }

    Component.onCompleted: {
        matugenColorsProc.running = true
        currentWallProc.running = true
        thumbDirProc.running = true
    }
}

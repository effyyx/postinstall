import "../core"
pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property var appList: []
    property var appUsage: ({})
    property var filteredApps: {
        var source = appList
        var usage = appUsage
        if (AppState.searchTerm !== "") {
            var result = []
            for (var i = 0; i < source.length; i++) {
                var entry = source[i]
                if (entry.name.toLowerCase().includes(AppState.searchTerm) || entry.exec.toLowerCase().includes(AppState.searchTerm))
                    result.push(entry)
            }
            source = result
        }
        return source.slice().sort(function(a, b) {
            var countA = usage[a.name] || 0
            var countB = usage[b.name] || 0
            if (countB !== countA) return countB - countA
            return a.name.localeCompare(b.name)
        })
    }

    function launch(app) {
        launchProc.command = ["bash", "-c", "nohup " + app.exec + " >/dev/null 2>&1 &"]
        launchProc.running = true
        var updated = Object.assign({}, root.appUsage)
        updated[app.name] = (updated[app.name] || 0) + 1
        root.appUsage = updated
        saveUsageProc.command = ["bash", "-c", "echo '" + JSON.stringify(updated) + "' > '" + Config.appUsageFile + "'"]
        saveUsageProc.running = true
        AppState.launcherVisible = false
    }

    Process {
        id: loadUsageProc
        command: ["bash", "-c", "cat '" + Config.appUsageFile + "' 2>/dev/null || echo '{}'"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                try { root.appUsage = JSON.parse(data.trim()) } catch(e) { root.appUsage = {} }
            }
        }
    }
    Process { id: saveUsageProc }
    Process { id: launchProc }
    Process {
        id: appListProc
        command: ["bash", "-c",
            "for f in /usr/share/applications/*.desktop '" + Config.localAppsDir + "'/*.desktop; do\n" +
            "    [ -f \"$f\" ] || continue\n" +
            "    nodisplay=$(grep -i '^NoDisplay=true' \"$f\")\n" +
            "    [ -n \"$nodisplay\" ] && continue\n" +
            "    hidden=$(grep -i '^Hidden=true' \"$f\")\n" +
            "    [ -n \"$hidden\" ] && continue\n" +
            "    name=$(grep -m1 '^Name=' \"$f\" | cut -d= -f2-)\n" +
            "    exec=$(grep -m1 '^Exec=' \"$f\" | cut -d= -f2- | sed 's/ %[fFuUdDnNickvm]//g')\n" +
            "    icon=$(grep -m1 '^Icon=' \"$f\" | cut -d= -f2-)\n" +
            "    [ -z \"$name\" ] && continue\n" +
            "    [ -z \"$exec\" ] && continue\n" +
            "    printf '%s\\t%s\\t%s\\n' \"$name\" \"$exec\" \"$icon\"\n" +
            "done | sort -f -t$'\\t' -k1,1 | awk -F'\\t' '!seen[$1]++'"
        ]
        stdout: SplitParser {
            onRead: data => {
                var line = data.trim()
                if (line.length === 0) return
                var parts = line.split("\t")
                if (parts.length < 2) return
                var current = root.appList.slice()
                current.push({ name: parts[0], exec: parts[1], icon: parts.length > 2 ? parts[2] : "" })
                root.appList = current
            }
        }
    }

    Component.onCompleted: {
        loadUsageProc.running = true
        appListProc.running = true
    }
}

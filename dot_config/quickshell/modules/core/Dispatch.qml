pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    function run(cmd) {
        dispatchProc.command = ["bash", "-c",
            "hyprctl dispatch exec \"bash -c '" + cmd + "'\""]
        dispatchProc.running = true
    }

    Process {
        id: dispatchProc
        onExited: running = false
    }
}

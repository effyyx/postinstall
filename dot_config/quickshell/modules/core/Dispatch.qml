pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    function run(cmd) {
        dispatchProc.command = ["bash", "-c", "setsid bash -c " + JSON.stringify(cmd) + " &"]
        dispatchProc.running = true
    }

    Process {
        id: dispatchProc
        onExited: running = false
    }
}

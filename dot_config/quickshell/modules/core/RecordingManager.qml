pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool isRecording: false
    property string recordingMode: ""
    property string recordingTime: "00:00"
    property int recordingSeconds: 0

    readonly property int maxSeconds: 3 * 60 * 60  // 3 hours

    Timer {
        id: recordTimer
        interval: 1000
        repeat: true
        running: root.isRecording
        onTriggered: {
            root.recordingSeconds++
            var m = Math.floor(root.recordingSeconds / 60)
            var s = root.recordingSeconds % 60
            root.recordingTime = (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s

            if (root.recordingSeconds >= root.maxSeconds) {
                console.warn("RecordingManager: 3 hour limit reached, stopping automatically")
                root.stop()
            }
        }
    }

    function start(flags) {
        root.recordingSeconds = 0
        root.recordingTime = "00:00"
        Dispatch.run(Config.scriptsDir + "/record.sh " + flags + " >/tmp/qs-record.log 2>&1")
    }

    function stop() {
        root.isRecording = false
        root.recordingSeconds = 0
        root.recordingTime = "00:00"
        root.recordingMode = ""
        Dispatch.run("pkill wf-recorder")
    }
}

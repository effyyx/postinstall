import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import "./modules/core"
import "./modules/processes"
import "./modules/components"
import "./modules/ui"

ShellRoot {
    id: root

    Bar {}
    NotificationPopups {}
    Calendar {}
    MusicPanel {}
    LauncherPanel {}
    Cheatsheet {}

    LazyPanel {
        shown: AppState.wallpickerVisible
        panel: Component {
            Menu {
                visible: AppState.wallpickerVisible
                Component.onCompleted: {
                    if (AppState.wallpickerVisible) forceActiveFocus()
                }
            }
        }
    }

    IpcHandler {
        target: "launcher"
        function toggle() {
            AppState.activeTab = 0
            AppState.launcherVisible = !AppState.launcherVisible
        }
    }

    IpcHandler {
        target: "calendar"
        function toggle() { AppState.dashboardVisible = !AppState.dashboardVisible }
    }

    IpcHandler {
        target: "music"
        function toggle() { AppState.musicVisible = !AppState.musicVisible }
    }

    IpcHandler {
        target: "menu"
        function toggle()        { AppState.activeTab = 0; AppState.wallpickerVisible = !AppState.wallpickerVisible }
        function wallpaper()     { AppState.activeTab = 0; AppState.wallpickerVisible = true }
        function recorder()      { AppState.activeTab = 1; AppState.wallpickerVisible = true }
        function screenshot()    { AppState.activeTab = 2; AppState.wallpickerVisible = true }
        function notifications() { AppState.activeTab = 3; AppState.wallpickerVisible = true }
    }

    IpcHandler {
        target: "screenshot"
        function take()     { ScreenshotManager.take("--fullscreen", false) }
        function region()   { ScreenshotManager.take("--region", true) }
        function ocr()      { ScreenshotManager.ocr() }
        function mangaOcr() { ScreenshotManager.mangaOcr() }
        function annotate() { ScreenshotManager.annotate() }
    }

    IpcHandler {
    target: "cheatsheet"
    function toggle() { AppState.cheatsheetVisible = !AppState.cheatsheetVisible }
    }

    IpcHandler {
        target: "recorder"
        function startRecording() {
            RecordingManager.isRecording = true
        }
        function stopRecording() {
            RecordingManager.stop()
        }
        function regionRecord() {
            if (RecordingManager.isRecording) { RecordingManager.stop(); return }
            RecordingManager.recordingMode = "Region"
            AppState.wallpickerVisible = false
            RecordingManager.start("")
        }
        function regionRecordAudio() {
            if (RecordingManager.isRecording) { RecordingManager.stop(); return }
            RecordingManager.recordingMode = "Region + Audio"
            AppState.wallpickerVisible = false
            RecordingManager.start("--sound")
        }
        function fullscreenRecord() {
            if (RecordingManager.isRecording) { RecordingManager.stop(); return }
            RecordingManager.recordingMode = "Fullscreen"
            RecordingManager.isRecording = true
            RecordingManager.start("--fullscreen")
        }
        function fullscreenRecordAudio() {
            if (RecordingManager.isRecording) { RecordingManager.stop(); return }
            RecordingManager.recordingMode = "Fullscreen + Audio"
            RecordingManager.isRecording = true
            RecordingManager.start("--fullscreen --sound")
        }
    }
}

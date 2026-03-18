pragma Singleton
import Quickshell
import QtQuick

Singleton {
    function take(flags, closeFirst) {
        if (closeFirst) AppState.wallpickerVisible = false
        Dispatch.run(Config.scriptsDir + "/screenshot.sh " + flags + " >/tmp/qs-screenshot.log 2>&1")
    }
    function ocr() {
        AppState.wallpickerVisible = false
        Dispatch.run(Config.scriptsDir + "/screenshot.sh --ocr >/tmp/qs-screenshot.log 2>&1")
    }
    function mangaOcr() {
        AppState.wallpickerVisible = false
        Dispatch.run(Config.scriptsDir + "/screenshot.sh --manga-ocr >/tmp/qs-screenshot.log 2>&1")
    }
    function annotate() {
        AppState.wallpickerVisible = false
        Dispatch.run(Config.scriptsDir + "/screenshot.sh --annotate >/tmp/qs-screenshot.log 2>&1")
    }
}

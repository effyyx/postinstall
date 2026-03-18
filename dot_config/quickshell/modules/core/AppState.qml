pragma Singleton
import Quickshell
import QtQuick

Singleton {
    // ── panel visibility ──────────────────────────────────────────────────
    property bool dashboardVisible: false
    property bool musicVisible: false
    property bool launcherVisible: false
    property bool wallpickerVisible: false
    property bool wifiVisible: false
    property bool btVisible: false
    property bool cheatsheetVisible: false

    // ── navigation ────────────────────────────────────────────────────────
    property int activeTab: 0
    property int selectedIndex: 0
    property int savedGifIndex: 0

    // ── search ────────────────────────────────────────────────────────────
    property string searchTerm: ""
    property string wallSearchTerm: ""
    property int wallSelectedIndex: 0

    // ── misc ──────────────────────────────────────────────────────────────
    property var pfpFiles: []

    // ── matugen colors (temp until WallpaperManager) ──────────────────────
    property color walBackground: "#141318"
    property color walForeground: "#e6e1e9"
    property color walColor1: "#ffb4ab"
    property color walColor2: "#eeb8c9"
    property color walColor4: "#cbc3dc"
    property color walColor5: "#cdbdff"
    property color walColor8: "#938f99"
    property color walColor13: "#eeb8c9"
}

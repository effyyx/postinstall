import "../core"
import "../components"
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

PanelWindow {
    id: menu
    visible: AppState.wallpickerVisible
    exclusionMode: ExclusionMode.Ignore
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    focusable: true
    WlrLayershell.keyboardFocus: AppState.wallpickerVisible
        ? WlrKeyboardFocus.OnDemand
        : WlrKeyboardFocus.None
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "qs-menu"

    property int pickerTab: 0
    property real ani: 0

    Keys.onEscapePressed: AppState.wallpickerVisible = false

    onPickerTabChanged: {
        if (pickerTab !== 0) menu.forceActiveFocus()
    }
    Behavior on ani { NumberAnimation { duration: 240; easing.type: Easing.OutCubic } }

    onVisibleChanged: {
        if (visible) {
            menu.pickerTab = AppState.activeTab
            ani = 1
            if (!WallpaperManager.wallsLoaded) WallpaperManager.load()
            NotificationManager.clearUnread()
            focusTimer.start()
        } else {
            ani = 0
        }
    }

    // ── dim backdrop ──────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.52 * menu.ani)
        MouseArea {
            anchors.fill: parent
            onClicked: AppState.wallpickerVisible = false
        }
    }

    // ── main card ─────────────────────────────────────────────────────────
    Rectangle {
        id: card
        anchors.centerIn: parent
        width: 1100
        height: 620
        opacity: menu.ani
        scale: 0.92 + 0.08 * menu.ani
        color: Qt.rgba(WallpaperManager.walBackground.r, WallpaperManager.walBackground.g, WallpaperManager.walBackground.b, 0.92)
        border.width: 1
        border.color: WallpaperManager.walColor5
        layer.enabled: true
        layer.effect: DropShadow {
            radius: 24; samples: 25
            color: "#72000000"; verticalOffset: 10
        }
        MouseArea { anchors.fill: parent; onClicked: {} }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 0

            // ── tab bar ───────────────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: 46
                color: "transparent"

                Row {
                    anchors.centerIn: parent
                    spacing: 4

                    // Tab 0 — Wallpapers
                    Rectangle {
                        width: 34; height: 34; radius: 10
                        color: menu.pickerTab === 0
                            ? Qt.rgba(WallpaperManager.walColor5.r, WallpaperManager.walColor5.g, WallpaperManager.walColor5.b, 0.18)
                            : tab0Hov.containsMouse ? Qt.rgba(1,1,1,0.06) : "transparent"
                        Behavior on color { ColorAnimation { duration: 120 } }
                        Text {
                            anchors.centerIn: parent
                            text: "󰸉"
                            font.pixelSize: 16; font.family: "Hiragino Sans"
                            color: menu.pickerTab === 0 ? WallpaperManager.walColor5 : WallpaperManager.walColor8
                            Behavior on color { ColorAnimation { duration: 120 } }
                        }
                        Rectangle {
                            visible: menu.pickerTab === 0
                            anchors.bottom: parent.bottom; anchors.bottomMargin: 3
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 4; height: 4; radius: 2; color: WallpaperManager.walColor5
                        }
                        MouseArea {
                            id: tab0Hov; anchors.fill: parent
                            hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: { menu.pickerTab = 0; wallpaperTab.focusGrid() }
                        }
                    }

                    // Tab 1 — Screen Recorder
                    Rectangle {
                        width: 34; height: 34; radius: 10
                        color: menu.pickerTab === 1
                            ? Qt.rgba(WallpaperManager.walColor5.r, WallpaperManager.walColor5.g, WallpaperManager.walColor5.b, 0.18)
                            : tab1Hov.containsMouse ? Qt.rgba(1,1,1,0.06) : "transparent"
                        Behavior on color { ColorAnimation { duration: 120 } }
                        Text {
                            anchors.centerIn: parent
                            text: RecordingManager.isRecording ? "󰻃" : "󰄀"
                            font.pixelSize: 16; font.family: "Hiragino Sans"
                            color: RecordingManager.isRecording ? WallpaperManager.walColor1
                                 : menu.pickerTab === 1 ? WallpaperManager.walColor5 : WallpaperManager.walColor8
                            Behavior on color { ColorAnimation { duration: 120 } }
                            SequentialAnimation on opacity {
                                running: RecordingManager.isRecording
                                loops: Animation.Infinite
                                NumberAnimation { to: 0.3; duration: 600 }
                                NumberAnimation { to: 1.0; duration: 600 }
                            }
                        }
                        Rectangle {
                            visible: menu.pickerTab === 1
                            anchors.bottom: parent.bottom; anchors.bottomMargin: 3
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 4; height: 4; radius: 2; color: WallpaperManager.walColor5
                        }
                        MouseArea {
                            id: tab1Hov; anchors.fill: parent
                            hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: menu.pickerTab = 1
                        }
                    }

                    // Tab 2 — Screenshot
                    Rectangle {
                        width: 34; height: 34; radius: 10
                        color: menu.pickerTab === 2
                            ? Qt.rgba(WallpaperManager.walColor5.r, WallpaperManager.walColor5.g, WallpaperManager.walColor5.b, 0.18)
                            : tab2Hov.containsMouse ? Qt.rgba(1,1,1,0.06) : "transparent"
                        Behavior on color { ColorAnimation { duration: 120 } }
                        Text {
                            anchors.centerIn: parent
                            text: "󰹑"
                            font.pixelSize: 16; font.family: "Hiragino Sans"
                            color: menu.pickerTab === 2 ? WallpaperManager.walColor5 : WallpaperManager.walColor8
                            Behavior on color { ColorAnimation { duration: 120 } }
                        }
                        Rectangle {
                            visible: menu.pickerTab === 2
                            anchors.bottom: parent.bottom; anchors.bottomMargin: 3
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 4; height: 4; radius: 2; color: WallpaperManager.walColor5
                        }
                        MouseArea {
                            id: tab2Hov; anchors.fill: parent
                            hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: menu.pickerTab = 2
                        }
                    }

                    // Tab 3 — Notifications
                    Rectangle {
                        width: 34; height: 34; radius: 10
                        color: menu.pickerTab === 3
                            ? Qt.rgba(WallpaperManager.walColor13.r, WallpaperManager.walColor13.g, WallpaperManager.walColor13.b, 0.18)
                            : tab3Hov.containsMouse ? Qt.rgba(1,1,1,0.06) : "transparent"
                        Behavior on color { ColorAnimation { duration: 120 } }

                        Text {
                            anchors.centerIn: parent
                            text: "󰂚"
                            font.pixelSize: 16; font.family: "Hiragino Sans"
                            color: menu.pickerTab === 3 ? WallpaperManager.walColor5 : WallpaperManager.walColor8
                            Behavior on color { ColorAnimation { duration: 120 } }
                        }

                        // unread badge
                        Rectangle {
                            visible: NotificationManager.unreadCount > 0 && menu.pickerTab !== 3
                            anchors.top: parent.top; anchors.right: parent.right
                            anchors.topMargin: 4; anchors.rightMargin: 4
                            width: 8; height: 8; radius: 4
                            color: WallpaperManager.walColor13
                        }

                        Rectangle {
                            visible: menu.pickerTab === 3
                            anchors.bottom: parent.bottom; anchors.bottomMargin: 3
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 4; height: 4; radius: 2; color: WallpaperManager.walColor5
                        }

                        MouseArea {
                            id: tab3Hov; anchors.fill: parent
                            hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                menu.pickerTab = 3
                                NotificationManager.clearUnread()
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: Qt.rgba(WallpaperManager.walForeground.r, WallpaperManager.walForeground.g, WallpaperManager.walForeground.b, 0.07)
                }
            }

            // ── tab content ───────────────────────────────────────────────
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 16

                WallpaperTab {
                    id: wallpaperTab
                    anchors.fill: parent
                    visible: menu.pickerTab === 0
                }

                ScreenRecorder {
                    anchors.fill: parent
                    visible: menu.pickerTab === 1
                }

                ScreenshotTab {
                    anchors.fill: parent
                    visible: menu.pickerTab === 2
                }

                NotificationTab {
                    anchors.fill: parent
                    visible: menu.pickerTab === 3
                }
            }
        }
    }

    Timer {
        id: focusTimer
        interval: 60; repeat: false
        onTriggered: if (menu.pickerTab === 0) wallpaperTab.focusGrid()
    }

    Connections {
        target: AppState
        function onWallpickerVisibleChanged() {
            if (!AppState.wallpickerVisible) return
            menu.pickerTab = AppState.activeTab
            AppState.wallSelectedIndex = 0
            if (!WallpaperManager.wallsLoaded) WallpaperManager.load()
        }
        function onActiveTabChanged() {
            menu.pickerTab = AppState.activeTab
        }
    }
}

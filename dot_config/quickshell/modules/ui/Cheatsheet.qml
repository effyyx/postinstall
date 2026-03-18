import "../core"
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

PanelWindow {
    id: cheatsheet

    visible: AppState.cheatsheetVisible
    exclusionMode: ExclusionMode.Ignore
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    focusable: true
    WlrLayershell.keyboardFocus: AppState.cheatsheetVisible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "qs-cheatsheet"

    property int activeTab: 0
    property real ani: 0
    Behavior on ani { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

    onVisibleChanged: {
        if (visible) { ani = 1; forceActiveFocus() }
        else { ani = 0; activeTab = 0 }
    }

    Keys.onEscapePressed: AppState.cheatsheetVisible = false
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Left || event.key === Qt.Key_H) {
            activeTab = Math.max(0, activeTab - 1); event.accepted = true
        } else if (event.key === Qt.Key_Right || event.key === Qt.Key_L) {
            activeTab = Math.min(3, activeTab + 1); event.accepted = true
        } else if (event.key === Qt.Key_1) { activeTab = 0; event.accepted = true }
        else if (event.key === Qt.Key_2) { activeTab = 1; event.accepted = true }
        else if (event.key === Qt.Key_3) { activeTab = 2; event.accepted = true }
        else if (event.key === Qt.Key_4) { activeTab = 3; event.accepted = true }
    }

    // ── dim backdrop ──────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.55 * cheatsheet.ani)
        MouseArea {
            anchors.fill: parent
            onClicked: AppState.cheatsheetVisible = false
        }
    }

    // ── main card ─────────────────────────────────────────────────────────
    Rectangle {
        id: card
        anchors.centerIn: parent
        width: 1200
        height: 680
        opacity: cheatsheet.ani
        scale: 0.93 + 0.07 * cheatsheet.ani
        color: Qt.rgba(WallpaperManager.walBackground.r, WallpaperManager.walBackground.g, WallpaperManager.walBackground.b, 0.95)
        border.width: 1
        border.color: Qt.rgba(WallpaperManager.walColor5.r, WallpaperManager.walColor5.g, WallpaperManager.walColor5.b, 0.4)
        layer.enabled: true
        layer.effect: DropShadow {
            radius: 28; samples: 29
            color: "#80000000"; verticalOffset: 12
        }
        MouseArea { anchors.fill: parent; onClicked: {} }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // ── tab bar ───────────────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: 44
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20

                    Row {
                        spacing: 4
                        Layout.alignment: Qt.AlignVCenter

                        Repeater {
                            model: [
                                { label: "Hyprland", icon: "",  showIcon: true },
                                { label: "Neovim",   icon: "",  showIcon: true },
                                { label: "Yazi",     icon: "",   showIcon: false },
                                { label: "QS / IPC", icon: "",   showIcon: false }
                            ]

                            Rectangle {
                                width: tabRow.implicitWidth + 24
                                height: 28
                                radius: 6
                                color: cheatsheet.activeTab === index
                                    ? Qt.rgba(WallpaperManager.walColor5.r, WallpaperManager.walColor5.g, WallpaperManager.walColor5.b, 0.18)
                                    : tabHov.containsMouse ? Qt.rgba(1,1,1,0.06) : "transparent"
                                border.width: cheatsheet.activeTab === index ? 1 : 0
                                border.color: Qt.rgba(WallpaperManager.walColor5.r, WallpaperManager.walColor5.g, WallpaperManager.walColor5.b, 0.3)
                                Behavior on color { ColorAnimation { duration: 100 } }

                                Row {
                                    id: tabRow
                                    anchors.centerIn: parent
                                    spacing: 6
                                    Text {
                                        visible: modelData.showIcon
                                        text: modelData.icon
                                        font.pixelSize: 13; font.family: "Hiragino Sans"
                                        color: cheatsheet.activeTab === index ? WallpaperManager.walColor5 : WallpaperManager.walColor8
                                        anchors.verticalCenter: parent.verticalCenter
                                        Behavior on color { ColorAnimation { duration: 100 } }
                                    }
                                    Text {
                                        text: modelData.label
                                        font.pixelSize: 12; font.family: "Hiragino Sans"
                                        color: cheatsheet.activeTab === index ? WallpaperManager.walColor5 : WallpaperManager.walColor8
                                        anchors.verticalCenter: parent.verticalCenter
                                        Behavior on color { ColorAnimation { duration: 100 } }
                                    }
                                }

                                MouseArea {
                                    id: tabHov; anchors.fill: parent
                                    hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                                    onClicked: cheatsheet.activeTab = index
                                }
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "チートシート"
                        color: WallpaperManager.walColor8
                        font.pixelSize: 11; font.family: "Hiragino Sans"
                        opacity: 0.45
                    }

                    Text {
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left; anchors.right: parent.right
                    height: 1
                    color: Qt.rgba(WallpaperManager.walForeground.r, WallpaperManager.walForeground.g, WallpaperManager.walForeground.b, 0.06)
                }
            }

            // ── tab content ───────────────────────────────────────────────
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                CheatsheetHyprland { anchors.fill: parent; visible: cheatsheet.activeTab === 0 }
                CheatsheetNeovim   { anchors.fill: parent; visible: cheatsheet.activeTab === 1 }
                CheatsheetYazi     { anchors.fill: parent; visible: cheatsheet.activeTab === 2 }
                CheatsheetQs       { anchors.fill: parent; visible: cheatsheet.activeTab === 3 }
            }
        }
    }
}

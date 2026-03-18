import "../core"
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData

            exclusionMode: ExclusionMode.Auto
            anchors { top: true; left: true; right: true }
            implicitHeight: 32
            color: "transparent"

            property MprisPlayer mprisPlayer: {
                var players = Mpris.players.values
                for (var i = 0; i < players.length; i++) {
                    if (players[i].desktopEntry === "mpdris2" || players[i].identity === "Music Player Daemon")
                        return players[i]
                }
                return players.length > 0 ? players[0] : null
            }

            property string playerTitle:  mprisPlayer ? mprisPlayer.trackTitle  ?? "" : ""
            property string playerArtist: mprisPlayer ? mprisPlayer.trackArtist ?? "" : ""

            readonly property var wsLabels: ["一","二","三","四","五","六","七","八","九","十"]

            function wsToKanji(id) {
                return id >= 1 && id <= 10 ? wsLabels[id - 1] : id.toString()
            }

            // ── live workspace data from Hyprland IPC ─────────────────────
            property var screenWorkspaces: {
                var monitorName = bar.screen ? bar.screen.name : ""
                var result = []
                for (var i = 0; i < Hyprland.workspaces.values.length; i++) {
                    var ws = Hyprland.workspaces.values[i]
                    if (ws.monitor && ws.monitor.name === monitorName)
                        result.push(ws)
                }
                result.sort(function(a, b) { return a.id - b.id })
                return result
            }

            property var activeWs: Hyprland.focusedMonitor ? Hyprland.focusedMonitor.activeWorkspace : null

            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(
                    WallpaperManager.walBackground.r,
                    WallpaperManager.walBackground.g,
                    WallpaperManager.walBackground.b,
                    0.88
                )
                Behavior on color {
                    ColorAnimation { duration: 220; easing.type: Easing.InOutQuad }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Row {
                        spacing: 8
                        Layout.alignment: Qt.AlignVCenter

                        Repeater {
                            model: bar.screenWorkspaces
                            delegate: Item {
                                required property var modelData
                                width: wsLabel.implicitWidth
                                height: bar.implicitHeight

                                property bool isActive: bar.activeWs && modelData.id === bar.activeWs.id

                                Text {
                                    id: wsLabel
                                    anchors.centerIn: parent
                                    text: bar.wsToKanji(modelData.id)
                                    color: isActive ? WallpaperManager.walColor5 : WallpaperManager.walColor8
                                    opacity: isActive ? 1.0 : 0.5
                                    font.pixelSize: 14
                                    font.family: "Hiragino Sans"
                                    Behavior on color { ColorAnimation { duration: 150 } }
                                    Behavior on opacity { NumberAnimation { duration: 150 } }
                                }

                                Rectangle {
                                    visible: isActive
                                    anchors.bottom: parent.bottom
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: wsLabel.implicitWidth
                                    height: 1
                                    color: WallpaperManager.walColor5
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: modelData.activate()
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        height: bar.implicitHeight

                        Text {
                            anchors.centerIn: parent
                            text: bar.playerTitle !== ""
                                ? (bar.playerArtist !== "" ? bar.playerArtist + "  —  " + bar.playerTitle : bar.playerTitle)
                                : "再生なし"
                            color: bar.playerTitle !== "" ? WallpaperManager.walColor5 : WallpaperManager.walColor8
                            opacity: bar.playerTitle !== "" ? 1.0 : 0.4
                            font.pixelSize: 14
                            font.family: "Hiragino Sans"
                            elide: Text.ElideRight
                            width: Math.min(implicitWidth, parent.width - 20)
                            horizontalAlignment: Text.AlignHCenter

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: AppState.musicVisible = !AppState.musicVisible
                            }
                        }
                    }

                    Row {
                        spacing: 8
                        Layout.alignment: Qt.AlignVCenter

                        Rectangle {
                            visible: RecordingManager.isRecording
                            width: recRow.implicitWidth
                            height: bar.implicitHeight
                            color: "transparent"

                            Row {
                                id: recRow
                                spacing: 6
                                anchors.verticalCenter: parent.verticalCenter

                                Rectangle {
                                    width: 7; height: 7; radius: 4
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: WallpaperManager.walColor1
                                    SequentialAnimation on opacity {
                                        running: RecordingManager.isRecording
                                        loops: Animation.Infinite
                                        NumberAnimation { to: 0.2; duration: 500 }
                                        NumberAnimation { to: 1.0; duration: 500 }
                                    }
                                }

                                Text {
                                    text: RecordingManager.recordingTime
                                    color: WallpaperManager.walColor1
                                    font.pixelSize: 14
                                    font.family: "Hiragino Sans"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: RecordingManager.stop()
                            }
                        }

                        Text {
                            id: clockText
                            text: "00:00"
                            color: WallpaperManager.walColor5
                            font.pixelSize: 14
                            font.family: "Hiragino Sans"
                            anchors.verticalCenter: parent.verticalCenter

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: AppState.dashboardVisible = !AppState.dashboardVisible
                            }
                        }
                    }
                }
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    var now = new Date()
                    clockText.text = now.getHours().toString().padStart(2,'0') + ":" + now.getMinutes().toString().padStart(2,'0')
                }
            }

        }
    }
}

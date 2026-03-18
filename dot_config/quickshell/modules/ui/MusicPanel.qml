import "../core"
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
    id: musicPanel

    visible: AppState.musicVisible
    exclusionMode: ExclusionMode.Ignore
    anchors.top: true
    WlrLayershell.margins.top: 32
    implicitWidth: 430
    implicitHeight: 180
    color: "transparent"
    focusable: true
    WlrLayershell.keyboardFocus: AppState.musicVisible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    // ── find mpd player from MPRIS ────────────────────────────────────────
    property MprisPlayer player: {
        var players = Mpris.players.values
        for (var i = 0; i < players.length; i++) {
            if (players[i].desktopEntry === "mpdris2" || players[i].identity === "Music Player Daemon")
                return players[i]
        }
        return players.length > 0 ? players[0] : null
    }

    property bool hasTrack:  player !== null && player.playbackState !== MprisPlaybackState.Stopped
    property bool isPlaying: player !== null && player.isPlaying

    function formatTime(seconds) {
        var mins = Math.floor(seconds / 60)
        var secs = Math.floor(seconds % 60)
        return mins + ":" + (secs < 10 ? "0" : "") + secs
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(WallpaperManager.walBackground.r, WallpaperManager.walBackground.g, WallpaperManager.walBackground.b, 0.88)
        radius: 0
        focus: true

        Keys.onEscapePressed: AppState.musicVisible = false
        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Escape) {
                AppState.musicVisible = false
                event.accepted = true
            } else if (event.key === Qt.Key_Space) {
                if (musicPanel.player) musicPanel.player.togglePlaying()
                event.accepted = true
            } else if (event.key === Qt.Key_N) {
                if (musicPanel.player) musicPanel.player.next()
                event.accepted = true
            } else if (event.key === Qt.Key_P) {
                if (musicPanel.player) musicPanel.player.previous()
                event.accepted = true
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 15
            anchors.rightMargin: 20
            spacing: 15

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                spacing: 8

                Text {
                    text: musicPanel.player ? (musicPanel.player.trackTitle || "再生なし") : "再生なし"
                    color: WallpaperManager.walColor5
                    font.pixelSize: 15
                    font.bold: true
                    font.family: "Hiragino Sans"
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                    Layout.maximumWidth: 220
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                }

                Text {
                    text: musicPanel.player ? (musicPanel.player.trackArtist || "") : ""
                    color: WallpaperManager.walForeground
                    font.pixelSize: 12
                    font.family: "Hiragino Sans"
                    opacity: 0.7
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                    Layout.maximumWidth: 220
                    elide: Text.ElideRight
                    visible: musicPanel.player !== null && musicPanel.player.trackArtist !== ""
                }

                Item { Layout.fillHeight: true; Layout.minimumHeight: 4 }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 8
                    visible: musicPanel.hasTrack

                    Text {
                        text: musicPanel.player ? musicPanel.formatTime(musicPanel.player.position) : "0:00"
                        color: WallpaperManager.walColor8
                        font.pixelSize: 10
                        font.family: "Hiragino Sans"
                    }

                    Rectangle {
                        Layout.preferredWidth: 160
                        height: 4
                        radius: 2
                        color: Qt.rgba(0, 0, 0, 0.3)

                        Rectangle {
                            width: musicPanel.player && musicPanel.player.length > 0
                                ? parent.width * (musicPanel.player.position / musicPanel.player.length)
                                : 0
                            height: parent.height
                            radius: 2
                            color: WallpaperManager.walColor5
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: function(mouse) {
                                if (musicPanel.player && musicPanel.player.length > 0) {
                                    var seekPos = (mouse.x / parent.width) * musicPanel.player.length
                                    musicPanel.player.position = seekPos
                                }
                            }
                        }
                    }

                    Text {
                        text: musicPanel.player ? musicPanel.formatTime(musicPanel.player.length) : "0:00"
                        color: WallpaperManager.walColor8
                        font.pixelSize: 10
                        font.family: "Hiragino Sans"
                    }
                }

                Row {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 16
                    opacity: musicPanel.hasTrack ? 1.0 : 0.5

                    Rectangle {
                        width: 36; height: 36; radius: 10
                        color: prevMa.containsMouse ? Qt.rgba(1,1,1,0.12) : "transparent"
                        Text {
                            anchors.centerIn: parent
                            text: "󰒮"
                            color: WallpaperManager.walForeground
                            font.pixelSize: 18
                            font.family: "Hiragino Sans"
                        }
                        MouseArea {
                            id: prevMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (musicPanel.player) musicPanel.player.previous()
                        }
                    }

                    Rectangle {
                        width: 48; height: 48; radius: 24
                        color: WallpaperManager.walColor5
                        Text {
                            anchors.centerIn: parent
                            text: musicPanel.isPlaying ? "󰏤" : "󰐊"
                            color: WallpaperManager.walBackground
                            font.pixelSize: 22
                            font.family: "Hiragino Sans"
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (musicPanel.player) musicPanel.player.togglePlaying()
                        }
                    }

                    Rectangle {
                        width: 36; height: 36; radius: 10
                        color: nextMa.containsMouse ? Qt.rgba(1,1,1,0.12) : "transparent"
                        Text {
                            anchors.centerIn: parent
                            text: "󰒭"
                            color: WallpaperManager.walForeground
                            font.pixelSize: 18
                            font.family: "Hiragino Sans"
                        }
                        MouseArea {
                            id: nextMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (musicPanel.player) musicPanel.player.next()
                        }
                    }
                }
            }

            Image {
                Layout.preferredWidth: 150
                Layout.preferredHeight: 150
                Layout.alignment: Qt.AlignVCenter
                source: musicPanel.player ? (musicPanel.player.trackArtUrl || "") : ""
                fillMode: Image.PreserveAspectFit
                mipmap: true
                asynchronous: true
                smooth: true

                Rectangle {
                    anchors.fill: parent
                    color: Qt.rgba(0,0,0,0.35)
                    visible: parent.status !== Image.Ready
                    Text {
                        anchors.centerIn: parent
                        text: musicPanel.hasTrack ? "カバーなし" : "再生なし"
                        color: Qt.rgba(1,1,1,0.65)
                        font.pixelSize: 13
                        font.family: "Hiragino Sans"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }

    // ── position timer (MPRIS position doesn't auto-update) ───────────────
    Timer {
        interval: 1000
        running: AppState.musicVisible && musicPanel.isPlaying
        repeat: true
        onTriggered: {
            if (musicPanel.player) musicPanel.player.position
        }
    }
}

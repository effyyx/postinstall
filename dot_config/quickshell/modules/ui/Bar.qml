import "../core"
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

Scope {
    // ── shared niri workspace state (polled once, shared across all bars) ─
    property var niriWorkspaces: ({})   // { "DP-1": [{idx,active},...], "DP-2": [...] }
    property string niriFocusedOutput: ""

    Process {
        id: niriPollProc
        command: ["bash", "-c", "niri msg workspaces"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var lines = data.trim().split("\n")
                var result = {}
                var currentOutput = ""
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim()
                    // Output "DP-1":
                    var outMatch = line.match(/^Output "([^"]+)":/)
                    if (outMatch) {
                        currentOutput = outMatch[1]
                        result[currentOutput] = []
                        continue
                    }
                    // "  * 1    2" or "    1    2"
                    if (currentOutput && line.length > 0) {
                        var isFocused = line.startsWith("*")
                        var clean = line.replace(/^\*\s*/, "").trim()
                        var parts = clean.split(/\s+/)
                        for (var j = 0; j < parts.length; j++) {
                            var idx = parseInt(parts[j])
                            if (!isNaN(idx)) {
                                var isActive = (j === 0 && isFocused) || line.indexOf("* " + parts[j]) !== -1
                                // active workspace is marked with *
                                result[currentOutput].push({
                                    idx: idx,
                                    active: isFocused && j === 0
                                })
                            }
                        }
                        if (isFocused) niriFocusedOutput = currentOutput
                    }
                }
                niriWorkspaces = result
            }
        }
    }

    // Poll on startup and every 500ms via event stream trigger
    Timer {
        interval: 500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: niriPollProc.running = true
    }

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

            property string screenName: bar.screen ? bar.screen.name : ""

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

            function wsToKanji(idx) {
                return idx >= 1 && idx <= 10 ? wsLabels[idx - 1] : idx.toString()
            }

            property var screenWorkspaces: {
                var ws = niriWorkspaces[bar.screenName] || []
                return ws.slice(0, ws.length - 1)
            }

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

                                property bool isActive: modelData.active

                                Text {
                                    id: wsLabel
                                    anchors.centerIn: parent
                                    text: bar.wsToKanji(modelData.idx)
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
                                    onClicked: {
                                        var proc = Qt.createQmlObject('import Quickshell.Io; Process {}', bar)
                                        proc.command = ["niri", "msg", "action", "focus-workspace", modelData.idx.toString()]
                                        proc.running = true
                                    }
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

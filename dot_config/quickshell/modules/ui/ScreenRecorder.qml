import "../core"
import "../components"
import QtQuick
import QtQuick.Layouts

Item {
    focus: true
    Keys.onEscapePressed: AppState.wallpickerVisible = false

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 32
        width: 480

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 80

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 8
                visible: !RecordingManager.isRecording
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "󰄀"
                    font.pixelSize: 42; font.family: "Hiragino Sans"
                    color: WallpaperManager.walColor8; opacity: 0.4
                }
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "録画待機中"
                    color: WallpaperManager.walColor8; font.pixelSize: 12
                    font.family: "Hiragino Sans"; opacity: 0.4
                }
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 8
                visible: RecordingManager.isRecording
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10
                    Rectangle {
                        width: 10; height: 10; radius: 5
                        color: WallpaperManager.walColor1
                        SequentialAnimation on opacity {
                            running: RecordingManager.isRecording
                            loops: Animation.Infinite
                            NumberAnimation { to: 0.2; duration: 500 }
                            NumberAnimation { to: 1.0; duration: 500 }
                        }
                    }
                    Text {
                        text: "REC  " + RecordingManager.recordingTime
                        color: WallpaperManager.walColor1; font.pixelSize: 18
                        font.family: "Hiragino Sans"; font.bold: true
                    }
                }
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: RecordingManager.recordingMode
                    color: WallpaperManager.walColor8; font.pixelSize: 11
                    font.family: "Hiragino Sans"; opacity: 0.6
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            visible: !RecordingManager.isRecording

            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                RecordButton {
                    Layout.fillWidth: true
                    icon: "󰹑"; label: "全画面"; sublabel: "音声なし"
                    accent: WallpaperManager.walColor5
                    onTriggered: {
                        RecordingManager.isRecording = true
                        RecordingManager.recordingMode = "全画面"
                        AppState.wallpickerVisible = false
                        RecordingManager.start("--fullscreen")
                    }
                }
                RecordButton {
                    Layout.fillWidth: true
                    icon: "󰹑"; label: "全画面"; sublabel: "音声あり"
                    accent: WallpaperManager.walColor5
                    onTriggered: {
                        RecordingManager.isRecording = true
                        RecordingManager.recordingMode = "全画面 + 音声"
                        AppState.wallpickerVisible = false
                        RecordingManager.start("--fullscreen --sound")
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                RecordButton {
                    Layout.fillWidth: true
                    icon: "󰆞"; label: "範囲選択"; sublabel: "音声なし"
                    accent: WallpaperManager.walColor5
                    onTriggered: {
                        RecordingManager.recordingMode = "範囲選択"
                        AppState.wallpickerVisible = false
                        regionDelayTimer.flags = ""
                        regionDelayTimer.start()
                    }
                }
                RecordButton {
                    Layout.fillWidth: true
                    icon: "󰆞"; label: "範囲選択"; sublabel: "音声あり"
                    accent: WallpaperManager.walColor5
                    onTriggered: {
                        RecordingManager.recordingMode = "範囲選択 + 音声"
                        AppState.wallpickerVisible = false
                        regionDelayTimer.flags = "--sound"
                        regionDelayTimer.start()
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 52; radius: 0
            visible: RecordingManager.isRecording
            color: stopHov.containsMouse
                ? Qt.rgba(WallpaperManager.walColor1.r, WallpaperManager.walColor1.g, WallpaperManager.walColor1.b, 0.25)
                : Qt.rgba(WallpaperManager.walColor1.r, WallpaperManager.walColor1.g, WallpaperManager.walColor1.b, 0.12)
            border.width: 1
            border.color: Qt.rgba(WallpaperManager.walColor1.r, WallpaperManager.walColor1.g, WallpaperManager.walColor1.b, 0.4)
            Behavior on color { ColorAnimation { duration: 110 } }
            RowLayout {
                anchors.centerIn: parent
                spacing: 10
                Rectangle { width: 14; height: 14; radius: 2; color: WallpaperManager.walColor1 }
                Text {
                    text: "録画停止"
                    color: WallpaperManager.walColor1; font.pixelSize: 13
                    font.family: "Hiragino Sans"; font.bold: true
                }
            }
            MouseArea {
                id: stopHov; anchors.fill: parent
                hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                onClicked: RecordingManager.stop()
            }
        }
    }

    Timer {
        id: regionDelayTimer
        interval: 300
        repeat: false
        property string flags: ""
        onTriggered: {
            RecordingManager.isRecording = true
            RecordingManager.start(flags)
        }
    }
}

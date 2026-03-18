import "../core"
import "../components"
import QtQuick
import QtQuick.Layouts

Item {
    id: screenshotRoot
    focus: true
    Keys.onEscapePressed: AppState.wallpickerVisible = false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 16

        Text {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: "スクリーンショット"
            color: WallpaperManager.walColor5
            font.pixelSize: 13
            font.family: "Hiragino Sans"
            opacity: 0.7
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            columnSpacing: 10
            rowSpacing: 10

            RecordButton {
                Layout.fillWidth: true
                icon: "󰹑"
                label: "範囲選択"
                sublabel: "保存 + クリップボード"
                accent: WallpaperManager.walColor5
                onTriggered: ScreenshotManager.take("--region", true)
            }
            RecordButton {
                Layout.fillWidth: true
                icon: "󰹑"
                label: "全画面"
                sublabel: "保存 + クリップボード"
                accent: WallpaperManager.walColor5
                onTriggered: ScreenshotManager.take("--fullscreen", false)
            }
            RecordButton {
                Layout.fillWidth: true
                icon: "󰹑"
                label: "注釈"
                sublabel: "範囲 + swappy"
                accent: WallpaperManager.walColor5
                onTriggered: ScreenshotManager.take("--annotate", true)
            }
            RecordButton {
                Layout.fillWidth: true
                icon: "󰹑"
                label: "OCR"
                sublabel: "tesseract → クリップボード"
                accent: WallpaperManager.walColor5
                onTriggered: ScreenshotManager.take("--ocr", true)
            }
        }

        RecordButton {
            Layout.fillWidth: true
            icon: "󰹑"
            label: "manga-ocr"
            sublabel: "日本語OCR → クリップボード"
            accent: WallpaperManager.walColor5
            onTriggered: ScreenshotManager.take("--manga-ocr", true)
        }

        Item { Layout.fillHeight: true }
    }
}

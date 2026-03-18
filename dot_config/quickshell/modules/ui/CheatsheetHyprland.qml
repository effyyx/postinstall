import "../core"
import "../components"
import QtQuick
import QtQuick.Controls

Item {
    focus: true
    Keys.onEscapePressed: AppState.cheatsheetVisible = false

    ScrollView {
        anchors.fill: parent
        anchors.margins: 16
        clip: true
        ScrollBar.vertical.width: 4

        Flow {
            width: parent.width
            spacing: 16

            Column {
                width: (parent.width - 16) / 2
                spacing: 8

                KbSection {
                    width: parent.width
                    title: "ウィンドウ"
                    entries: [
                        { key: "Super + Q",           desc: "ウィンドウを閉じる" },
                        { key: "Super + F",           desc: "フルスクリーン切替" },
                        { key: "Super + Shift + F",   desc: "フロート切替" },
                        { key: "Super + Shift + Q",   desc: "ウィンドウ強制終了" },
                        { key: "Super + L",           desc: "画面ロック" },
                    ]
                }

                KbSection {
                    width: parent.width
                    title: "フォーカス / 移動"
                    entries: [
                        { key: "Super + ↑↓",            desc: "フォーカス上/下" },
                        { key: "Super + Shift + ←↑↓→",  desc: "ウィンドウ移動" },
                        { key: "Super + マウス左",        desc: "ウィンドウをドラッグ" },
                        { key: "Super + マウス右",        desc: "ウィンドウをリサイズ" },
                    ]
                }

                KbSection {
                    width: parent.width
                    title: "リサイズ  (Super + R でサブマップ)"
                    entries: [
                        { key: "h / j / k / l",       desc: "リサイズ" },
                        { key: "← ↑ ↓ →",            desc: "リサイズ" },
                        { key: "Ctrl+Shift + hjkl",   desc: "リサイズ (通常モード)" },
                        { key: "Escape",               desc: "サブマップ終了" },
                    ]
                }

                KbSection {
                    width: parent.width
                    title: "ズーム"
                    entries: [
                        { key: "マウスボタン4 / 5",     desc: "ズームイン/アウト" },
                    ]
                }
            }

            Column {
                width: (parent.width - 16) / 2
                spacing: 8

                KbSection {
                    width: parent.width
                    title: "ワークスペース"
                    entries: [
                        { key: "Super + 1-6",           desc: "ワークスペース切替" },
                        { key: "Super + Ctrl + 1-6",    desc: "ウィンドウを移動" },
                        { key: "Super + Shift + 1-6",   desc: "サイレント移動" },
                        { key: "Super + /",             desc: "前のワークスペース" },
                        { key: "Super + マウスホイール", desc: "列移動" },
                    ]
                }

                KbSection {
                    width: parent.width
                    title: "アプリ"
                    entries: [
                        { key: "Super + Space",         desc: "ターミナル (ghostty)" },
                        { key: "Super + N",             desc: "yazi" },
                        { key: "Super + Shift + N",     desc: "thunar" },
                        { key: "Super + W",             desc: "Firefox" },
                        { key: "Super + E",             desc: "rmpc (音楽)" },
                        { key: "Super + A",             desc: "Anki" },
                        { key: "Super + H",             desc: "hyprland.conf を開く" },
                        { key: "Super + T",             desc: "透明度調整" },
                    ]
                }

                KbSection {
                    width: parent.width
                    title: "メディア"
                    entries: [
                        { key: "Ctrl + ↑ / ↓",          desc: "音量 +5% / -5%" },
                        { key: "Ctrl + M",               desc: "ミュート切替" },
                        { key: "Ctrl + P",               desc: "再生/一時停止" },
                        { key: "Ctrl + → / ←",           desc: "次/前のトラック" },
                    ]
                }

                KbSection {
                    width: parent.width
                    title: "その他"
                    entries: [
                        { key: "Super + Alt + C",        desc: "カラーピッカー" },
                        { key: "Super + Ctrl + R",       desc: "Quickshell 再起動" },
                        { key: "Super + Delete",         desc: "Hyprland 終了" },
                    ]
                }
            }
        }
    }
}

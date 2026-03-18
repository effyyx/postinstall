pragma Singleton
import Quickshell
import QtQuick

Singleton {
    readonly property string home:          Quickshell.env("HOME")
    readonly property string configDir:     home + "/.config/quickshell"
    readonly property string cacheDir:      home + "/.cache"
    readonly property string wallpaperDir:  home + "/Pictures/Wallpaper"
    readonly property string thumbCacheDir: home + "/.cache/wallpaper-thumbs"
    readonly property string appUsageFile:  configDir + "/modules/app_usage.json"
    readonly property string localAppsDir:  home + "/.local/share/applications"
    readonly property string scriptsDir:    configDir + "/modules/scripts"
    readonly property string resolution:    "2560:1440"
}

import QtQuick

Item {
    id: lazyPanel

    property bool shown: false
    property int destroyDelay: 200
    property Component panel

    Loader {
        id: loader
        asynchronous: false
        active: lazyPanel.shown || destroyTimer.running
        sourceComponent: lazyPanel.panel
    }

    Timer {
        id: destroyTimer
        interval: lazyPanel.destroyDelay
        repeat: false
    }

    onShownChanged: {
        if (!shown) destroyTimer.restart()
    }
}

import QtQuick

Shortcut {
    sequences: []
    signal windowsEvent
    signal androidEvent
    signal iosEvent

    onActivated: {
        if (Qt.platform.os === "windows") {
            windowsEvent();
            return;
        }
        if (Qt.platform.os === "ios") {
            iosEvent();
            return;
        }
        if (Qt.platform.os === "android") {
            androidEvent();
            return;
        }
    }
}

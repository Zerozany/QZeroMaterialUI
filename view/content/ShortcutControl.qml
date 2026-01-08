import QtQuick

Item {
    id: root

    property var sequences: null
    signal windowsEvent
    signal androidEvent
    signal iosEvent

    Shortcut {
        sequences: root.sequences
        onActivated: {
            if (Qt.platform.os === "windows") {
                root.windowsEvent();
                return;
            }
            if (Qt.platform.os === "ios") {
                root.iosEvent();
                return;
            }
            if (Qt.platform.os === "android") {
                root.androidEvent();
                return;
            }
        }
    }
}

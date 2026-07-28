pragma Singleton
import QtQuick

QtObject {

    enum LandScapeType {
        Horizontal = 0,
        Vertical = 1
    }

    // 横屏返回true
    readonly property bool landScape: Screen.orientation === Qt.LandscapeOrientation || Screen.orientation === Qt.InvertedLandscapeOrientation ? true : false
}

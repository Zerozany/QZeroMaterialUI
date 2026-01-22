pragma Singleton
import QtQuick

QtObject {
    // 横屏返回true
    readonly property bool landScape: Screen.orientation === Qt.LandscapeOrientation || Screen.orientation === Qt.InvertedLandscapeOrientation ? true : false
}

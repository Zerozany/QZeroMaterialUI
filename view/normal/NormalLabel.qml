import QtQuick
import QtQuick.Templates as T
import QZeroZanyUI

T.Label {
    id: root
    color: root.textColor
    background: Rectangle {
        radius: root.radius
        color: root.labelColor
        border.width: root.borderWidth
        border.color: root.borderColor
    }
    verticalAlignment: root.isPortrait ? Text.AlignTop : Text.AlignVCenter
    horizontalAlignment: root.isPortrait ? Text.AlignHCenter : Text.AlignLeft
    leftPadding: root.isPortrait ? undefined : iconSize.width + labelIcon.anchors.leftMargin + root.elementMargins
    topPadding: root.isPortrait ? iconSize.height + labelIcon.anchors.topMargin + root.elementMargins : undefined

    property url source: ""
    property int borderWidth: 1
    property int radius: ElementStyle.elementRadius
    property string borderColor: ThemeManager.currentTheme["LabelColor"]
    property string labelColor: ThemeManager.currentTheme["LabelColor"]

    readonly property bool isPortrait: root.width <= root.height
    readonly property string textColor: ThemeManager.currentTheme["TextColor"]
    readonly property int elementMargins: ElementStyle.elementMargins
    readonly property size iconSize: Qt.size(isPortrait ? root.width * 0.5 : root.height * 0.5, isPortrait ? root.width * 0.5 : root.height * 0.5)

    Image {
        id: labelIcon
        source: root.source
        visible: root.source.toString() !== ""
        fillMode: Image.PreserveAspectFit
        width: root.iconSize.width
        height: root.iconSize.height
        anchors.horizontalCenter: root.isPortrait ? parent.horizontalCenter : undefined
        anchors.verticalCenter: root.isPortrait ? undefined : parent.verticalCenter
        anchors.top: root.isPortrait ? parent.top : undefined
        anchors.left: root.isPortrait ? undefined : parent.left
        anchors.topMargin: root.isPortrait ? root.height * 0.5 - root.iconSize.height + root.elementMargins : undefined
        anchors.leftMargin: root.isPortrait ? undefined : root.width * 0.5 - root.iconSize.width * 1.5 - root.elementMargins
    }
}

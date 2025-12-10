import QtQuick

Rectangle {
    id: root
    x: (parent.width - root.width) * 0.5
    y: ComponentConf.landScape ? parent.height * 0.025 : parent.height * 0.015
    width: ComponentConf.landScape ? parent.width * 0.4 : parent.width * 0.4
    height: ComponentConf.landScape ? parent.height * 0.05 : parent.height * 0.025
    color: root.elementColor
    radius: root.elementRadius

    readonly property string elementColor: ThemeManager.currentTheme["elementColor"]
    readonly property int elementRadius: ElementStyle.elementRadius * 3
}

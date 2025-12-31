import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: ComponentConf.landScape ? parent.height * 0.025 : parent.height * 0.015
    parent: Overlay.overlay
    width: root.selfWidth
    height: root.selfHeight
    color: root.elementColor
    radius: root.elementRadius

    readonly property int selfWidth: ComponentConf.landScape ? parent.Window.window.contentItem.width * 0.4 : parent.Window.window.contentItem.width * 0.4
    readonly property int selfHeight: ComponentConf.landScape ? parent.Window.window.contentItem.height * 0.05 : parent.Window.window.contentItem.height * 0.025
    readonly property int elementRadius: ElementStyle.elementRadius * 4
    readonly property string elementColor: ThemeManager.currentTheme["elementColor"]

    property bool clickedAnimationStart: false
    property bool pressedAnimationStart: false
    property bool animationEnd: false

    MouseArea {
        x: -(root.x)
        y: -(root.y)
        width: parent.Window.window.contentItem.width
        height: parent.Window.window.contentItem.height
        enabled: root.clickedAnimationStart || root.pressedAnimationStart
        onClicked: {
            root.clickedAnimationStart = false;
            root.pressedAnimationStart = false;
            root.animationEnd = true;
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        pressAndHoldInterval: 300

        onClicked: {
            if (root.pressedAnimationStart) {
                return;
            }
            root.clickedAnimationStart = false;
            root.clickedAnimationStart = true;
        }

        onPressAndHold: {
            root.clickedAnimationStart = false;
            root.pressedAnimationStart = false;
            root.pressedAnimationStart = true;
        }
    }

    SequentialAnimation {
        running: root.clickedAnimationStart || root.pressedAnimationStart

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "height"
                duration: 150
                to: {
                    if (root.clickedAnimationStart) {
                        return root.selfHeight * 1.8;
                    } else if (root.pressedAnimationStart) {
                        return root.selfHeight * 4;
                    }
                    return root.selfHeight;
                }
            }

            NumberAnimation {
                target: root
                property: "width"
                duration: 150
                to: root.selfWidth * 1.6
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "height"
                duration: 150
                to: {
                    if (root.clickedAnimationStart) {
                        return root.selfHeight * 1.6;
                    } else if (root.pressedAnimationStart) {
                        return root.selfHeight * 3.9;
                    }
                    return root.selfHeight;
                }
            }

            NumberAnimation {
                target: root
                property: "width"
                duration: 150
                to: root.selfWidth * 1.4
            }
        }
    }

    ParallelAnimation {
        running: root.animationEnd

        NumberAnimation {
            target: root
            property: "height"
            duration: 150
            to: root.selfHeight
        }

        NumberAnimation {
            target: root
            property: "width"
            duration: 150
            to: root.selfWidth
        }

        onStopped: {
            root.animationEnd = false;
        }
    }
}

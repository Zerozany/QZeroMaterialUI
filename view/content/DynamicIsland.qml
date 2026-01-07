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

    readonly property int selfWidth: ComponentConf.landScape ? Overlay.overlay.width * 0.4 : Overlay.overlay.width * 0.4
    readonly property int selfHeight: ComponentConf.landScape ? Overlay.overlay.height * 0.05 : Overlay.overlay.height * 0.025
    readonly property int elementRadius: ElementStyle.elementRadius * 4
    readonly property string elementColor: ThemeManager.currentTheme["elementColor"]

    property bool clickedAnimationStart: false
    property bool pressedAnimationStart: false
    property bool animationEnd: false

    MouseArea {
        parent: Overlay.overlay
        anchors.fill: root.clickedAnimationStart || root.pressedAnimationStart ? parent : root
        pressAndHoldInterval: 300
        propagateComposedEvents: true

        onClicked: function (_mouse) {
            var localPos = root.mapFromItem(parent, _mouse.x, _mouse.y);
            if (root.contains(localPos)) {
                if (root.pressedAnimationStart) {
                    return;
                }
                root.clickedAnimationStart = false;
                root.clickedAnimationStart = true;
            } else {
                root.clickedAnimationStart = false;
                root.pressedAnimationStart = false;
                root.animationEnd = true;
            }
        }

        onPressAndHold: function (_mouse) {
            var localPos = root.mapFromItem(parent, _mouse.x, _mouse.y);
            if (root.contains(localPos)) {
                if (root.pressedAnimationStart) {
                    return;
                }
                root.clickedAnimationStart = false;
                root.pressedAnimationStart = false;
                root.pressedAnimationStart = true;
            } else {
                root.clickedAnimationStart = false;
                root.pressedAnimationStart = false;
                root.animationEnd = true;
            }
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

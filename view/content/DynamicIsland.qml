import QtQuick

Rectangle {
    id: root
    x: root.selfX
    y: root.selfY
    width: root.selfWidth
    height: root.selfHeight
    color: root.elementColor
    radius: root.elementRadius
    focus: true

    readonly property int selfX: (ComponentMethod.findTopLevelWindow(parent).width - root.width) * 0.5
    readonly property int selfY: ComponentConf.landScape ? ComponentMethod.findTopLevelWindow(parent).height * 0.025 : ComponentMethod.findTopLevelWindow(parent).height * 0.015
    readonly property int selfWidth: ComponentConf.landScape ? ComponentMethod.findTopLevelWindow(parent).width * 0.4 : ComponentMethod.findTopLevelWindow(parent).width * 0.4
    readonly property int selfHeight: ComponentConf.landScape ? ComponentMethod.findTopLevelWindow(parent).height * 0.05 : ComponentMethod.findTopLevelWindow(parent).height * 0.025
    readonly property string elementColor: ThemeManager.currentTheme["elementColor"]
    readonly property int elementRadius: ElementStyle.elementRadius * 4

    property bool clickedAnimationStart: false
    property bool pressedAnimationStart: false
    property bool animationEnd: false

    MouseArea {
        x: -(root.selfX)
        y: -(root.selfY)
        width: ComponentMethod.findTopLevelWindow(root).width
        height: ComponentMethod.findTopLevelWindow(root).height
        enabled: root.focus
        onClicked: {
            if (!dynamicIslandArea.containsMouse) {
                root.animationEnd = true;
                root.clickedAnimationStart = false;
                root.pressedAnimationStart = false;
            }
        }
    }

    MouseArea {
        id: dynamicIslandArea
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

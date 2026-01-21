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
    readonly property string elementColor: ThemeManager.currentTheme["ElementColor"]
    readonly property int pressAndHoldInterval: 300

    property int __dynamicIslandIndex: 0

    MouseArea {
        parent: root.__dynamicIslandIndex !== 0 ? Overlay.overlay : root
        anchors.fill: parent
        pressAndHoldInterval: root.pressAndHoldInterval
        propagateComposedEvents: true

        onClicked: function (_mouse) {
            var localPos = root.mapFromItem(parent, _mouse.x, _mouse.y);
            if (!root.contains(localPos)) {
                closeParallelAnimation.restart();
                root.__dynamicIslandIndex = 0;
                return;
            }
            if (root.__dynamicIslandIndex === 2) {
                return;
            }
            clickSequentialAnimation.restart();
            root.__dynamicIslandIndex = 1;
        }

        onPressAndHold: function (_mouse) {
            var localPos = root.mapFromItem(parent, _mouse.x, _mouse.y);
            if (!root.contains(localPos)) {
                closeParallelAnimation.restart();
                root.__dynamicIslandIndex = 0;
                return;
            }
            pressedSequentialAnimation.restart();
            root.__dynamicIslandIndex = 2;
        }
    }

    SequentialAnimation {
        id: clickSequentialAnimation

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "height"
                duration: 150
                to: root.selfHeight * 1.8
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
                to: root.selfHeight * 1.6
            }

            NumberAnimation {
                target: root
                property: "width"
                duration: 150
                to: root.selfWidth * 1.4
            }
        }
    }

    SequentialAnimation {
        id: pressedSequentialAnimation

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "height"
                duration: 150
                to: root.selfHeight * 4
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
                to: root.selfHeight * 3.9
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
        id: closeParallelAnimation

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
    }
}

import QtQuick

Rectangle {
    id: root
    x: root.selfX
    y: root.selfY
    width: root.selfWidth
    radius: root.elementRadius
    color: root.elementColor

    property string text: ""
    property int interval: 2000

    readonly property int selfX: (ComponentMethod.findTopLevelWindow(parent).width - root.width) * 0.5
    readonly property int selfY: ComponentConf.landScape ? ComponentMethod.findTopLevelWindow(parent).height * 0.2 : ComponentMethod.findTopLevelWindow(parent).height * 0.1
    readonly property int selfWidth: ComponentConf.landScape ? ComponentMethod.findTopLevelWindow(parent).width * 0.5 : ComponentMethod.findTopLevelWindow(parent).width * 0.8
    readonly property string elementColor: ThemeManager.currentTheme["elementColor"]
    readonly property string textColor: ThemeManager.currentTheme["textColor"]
    readonly property int elementRadius: ElementStyle.elementRadius * 2
    readonly property int elementMargins: ElementStyle.elementMargins
    readonly property int fontSize: ThemeFont.fontSize["XL"]
    readonly property string fontFamily: ThemeFont.fontFamily
    readonly property string objectName: "ApplicationTip"

    Text {
        anchors.fill: parent
        text: root.text
        color: root.textColor
        font.pointSize: root.fontSize
        font.family: root.fontFamily
        wrapMode: Text.WrapAnywhere
        padding: root.elementMargins
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        Component.onCompleted: {
            root.height = implicitHeight;
        }
    }

    Component.onCompleted: {
        for (let i = parent.children.length - 1; i >= 0; --i) {
            let _item = parent.children[i];
            if (_item !== root && _item.objectName === "ApplicationTip") {
                _item.destroy();
            }
        }
    }

    SequentialAnimation {
        running: true
        ParallelAnimation {
            OpacityAnimator {
                target: root
                duration: 300
                from: 0
                to: 1
            }
            ScaleAnimator {
                target: root
                duration: 300
                from: 0.5
                to: 1
                easing.type: Easing.OutQuart
            }
        }
        PauseAnimation {
            duration: root.interval
        }
        OpacityAnimator {
            target: root
            duration: 300
            to: 0
        }
        onStopped: {
            root.destroy();
        }
    }
}

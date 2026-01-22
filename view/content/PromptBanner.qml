import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    parent: Overlay.overlay
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: ContentConf.landScape ? parent.height * 0.2 : parent.height * 0.1
    width: root.selfWidth
    radius: root.elementRadius
    color: root.elementColor

    property string text: ""
    property int interval: 2000

    readonly property int selfWidth: ContentConf.landScape ? parent.width * 0.5 : parent.width * 0.8
    readonly property string elementColor: ThemeManager.currentTheme["ElementColor"]
    readonly property string textColor: ThemeManager.currentTheme["TextColor"]
    readonly property int elementRadius: ElementStyle.elementRadius * 2
    readonly property int elementMargins: ElementStyle.elementMargins
    readonly property int fontSize: ThemeFont.fontSize["XL"]
    readonly property string fontFamily: ThemeFont.fontFamily
    readonly property int animationDuration: 300

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
            if (_item !== root && _item instanceof PromptBanner) {
                _item.destroy();
            }
        }
    }

    SequentialAnimation {
        running: true
        ParallelAnimation {
            OpacityAnimator {
                target: root
                duration: root.animationDuration
                from: 0
                to: 1
            }
            ScaleAnimator {
                target: root
                duration: root.animationDuration
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
            duration: root.animationDuration
            to: 0
        }
        onStopped: {
            root.destroy();
        }
    }
}

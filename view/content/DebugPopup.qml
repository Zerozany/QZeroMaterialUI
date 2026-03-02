pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls

Popup {
    id: root
    parent: Overlay.overlay
    anchors.centerIn: parent
    width: parent.width * 0.5
    height: parent.height * 0.5
    background: Rectangle {
        color: root.elementColor
        radius: root.elementRadius
        opacity: root.backgroundOpacity
    }

    property string message: ""
    readonly property double backgroundOpacity: 0.3
    readonly property int elementRadius: ElementStyle.elementRadius
    readonly property int elementMargins: ElementStyle.elementMargins * 2
    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property string textColor: ThemeManager.currentTheme["TextColor"]
    readonly property string elementColor: ThemeManager.currentTheme["ElementColor"]
    readonly property int fontSize: ThemeFont.fontSize["XL"]
    readonly property int maxMessagesCount: 1000

    Flickable {
        id: flick
        anchors.fill: parent
        anchors.margins: root.elementMargins
        contentWidth: width
        contentHeight: column.height
        clip: true
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: column
            width: flick.width
            spacing: root.elementSpacing
        }
    }

    Component {
        id: logTextComponent

        Text {
            width: column.width
            wrapMode: Text.WrapAnywhere
            color: root.textColor
            font.pixelSize: root.fontSize
        }
    }

    onMessageChanged: {
        logTextComponent.createObject(column, {
            text: message
        });
        if (column.children.length > root.maxMessagesCount) {
            column.children[0].destroy();
        }
        flick.contentY = Math.max(0, flick.contentHeight - flick.height);
        root.open();
    }
}

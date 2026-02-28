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
        color: "white"
        radius: root.backgroundRadius
        opacity: root.backgroundOpacity
    }

    readonly property int backgroundRadius: 5
    readonly property double backgroundOpacity: 0.3
    readonly property int textMargins: 10
    readonly property int textSpacing: 5
    readonly property string textColor: "black"
    readonly property int textFontSize: 14
    readonly property int maxMessagesCount: 1000

    function appendLog(_message) {
        let finalText = "[" + Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss") + "] : " + _message;
        logTextComponent.createObject(column, {
            text: finalText
        });
        if (column.children.length > root.maxMessagesCount) {
            column.children[0].destroy();
        }
        flick.contentY = Math.max(0, flick.contentHeight - flick.height);
        root.open();
    }

    Flickable {
        id: flick
        anchors.fill: parent
        anchors.margins: root.textMargins
        contentWidth: width
        contentHeight: column.height
        clip: true
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: column
            width: flick.width
            spacing: root.textSpacing
        }
    }

    Component {
        id: logTextComponent

        Text {
            width: column.width
            wrapMode: Text.WrapAnywhere
            color: root.textColor
            font.pixelSize: root.textFontSize
        }
    }
}

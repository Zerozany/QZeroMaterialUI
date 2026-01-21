import QtQuick

Rectangle {
    id: root
    radius: root.elementRadius
    color: root.elementColor

    property string text: ""

    readonly property string elementColor: ThemeManager.currentTheme["ElementColor"]
    readonly property string textColor: ThemeManager.currentTheme["TextColor"]
    readonly property int elementRadius: ElementStyle.elementRadius
    readonly property int elementMargins: ElementStyle.elementMargins
    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property int fontSize: ThemeFont.fontSize["L"]

    Text {
        anchors.centerIn: parent
        text: root.text
        width: contentWidth
        height: contentHeight
        color: root.textColor
        font.pixelSize: root.fontSize
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        Component.onCompleted: {
            root.width = contentWidth + 2 * (root.elementMargins);
            root.height = contentHeight + 2 * (root.elementMargins);
        }
    }

    onVisibleChanged: {
        x = root._popupX();
        y = root._popupY();
    }

    function _popupX(): real {
        let relativePoint = parent.mapToItem(null, 0, 0);
        if (parent.width >= root.width) {
            return (parent.width - root.width) / 2;
        }
        if (relativePoint.x - (root.width - parent.width) / 2 <= 0) {
            return 0;
        }
        if (relativePoint.x + parent.width + (root.width - parent.width) / 2 >= parent.Window.window.contentItem.width) {
            return parent.width - root.width;
        }
        return (parent.width - root.width) / 2;
    }

    function _popupY(): real {
        let relativePoint = parent.mapToItem(null, 0, 0);
        if (relativePoint.y < root.height + root.elementMargins) {
            return parent.height + root.elementMargins;
        }
        if (relativePoint.y + parent.height + root.height + root.elementMargins > parent.Window.window.contentItem.height) {
            return -root.height - root.elementMargins;
        }
        return parent.height + root.elementMargins;
    }
}

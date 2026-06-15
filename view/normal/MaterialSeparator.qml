import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material

T.ToolSeparator {
    id: root
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding)
    horizontalPadding: vertical ? 12 : 5
    verticalPadding: vertical ? 5 : 12
    contentItem: Rectangle {
        implicitWidth: root.vertical ? 1 : 38
        implicitHeight: root.vertical ? 38 : 1
        color: root.Material.accent
    }
}

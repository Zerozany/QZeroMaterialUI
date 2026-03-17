import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material

T.ToolTip {
    id: root
    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: implicitHeight + root.elementMargins + root.elementSpacing
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding)
    margins: root.elementMargins
    verticalPadding: root.elementPadding
    horizontalPadding: root.elementPadding * 2
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent
    background: Rectangle {
        implicitHeight: Material.tooltipHeight
        color: root.color
        radius: root.radius
    }

    property int radius: ElementStyle.elementRadius * 2
    property string color: ThemeManager.currentTheme["ElementColor"]

    readonly property int elementMargins: ElementStyle.elementMargins * 2
    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property int elementPadding: ElementStyle.elementPadding

    contentItem: Text {
        text: root.text
        font: root.font
        wrapMode: Text.Wrap
        color: Material.foreground
    }
}

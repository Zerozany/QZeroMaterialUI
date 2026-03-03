import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material

T.ToolTip {
    id: root
    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: -implicitHeight - root.elementMargins
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding)
    margins: root.elementMargins
    padding: root.elementPadding
    horizontalPadding: root.elementPadding * 2
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent
    background: Rectangle {
        implicitHeight: root.Material.tooltipHeight
        color: root.elementColor
        opacity: root.elementOpacity
        radius: root.elementRadius
    }

    readonly property double elementOpacity: 0.8
    readonly property string elementColor: ThemeManager.currentTheme["ElementColor"]
    readonly property string textColor: ThemeManager.currentTheme["TextColor"]
    readonly property int elementRadius: ElementStyle.elementRadius * 2
    readonly property int elementMargins: ElementStyle.elementMargins * 2
    readonly property int elementPadding: 5
    readonly property int elementDuration: 500

    contentItem: Text {
        text: root.text
        font: root.font
        wrapMode: Text.Wrap
        color: root.textColor
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0.0
            to: 1.0
            easing.type: Easing.OutQuad
            duration: root.elementDuration
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0.0
            easing.type: Easing.InQuad
            duration: root.elementDuration
        }
    }
}

import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import QtQuick.Templates as T

T.Switch {
    id: root
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding, implicitIndicatorHeight + topPadding + bottomPadding)
    padding: root.elementSpacing
    spacing: root.elementPadding
    icon.width: root.iconSize.width
    icon.height: root.iconSize.height
    icon.color: checked ? (Material.theme === Material.Light ? enabled ? Qt.darker(Material.switchCheckedTrackColor, 1.8) : Material.switchDisabledCheckedIconColor : enabled ? Material.primaryTextColor : Material.switchDisabledCheckedIconColor) : enabled ? Material.switchUncheckedTrackColor : Material.switchDisabledUncheckedIconColor

    property var border: QtObject {
        property int width: 2
        property color color: root.checked ? Material.accent : Material.background
    }

    readonly property size iconSize: Qt.size(16, 16)
    readonly property size handleSize: Qt.size(28, 28)
    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property int elementPadding: ElementStyle.elementPadding

    indicator: SwitchIndicator {
        x: root.text ? (root.mirrored ? root.width - width - root.rightPadding : root.leftPadding) : root.leftPadding + (root.availableWidth - width) / 2
        y: root.topPadding + (root.availableHeight - height) / 2
        control: root
        border.width: root.border.width
        border.color: root.border.color

        Ripple {
            x: parent.handle.x + parent.handle.width / 2 - width / 2
            y: parent.handle.y + parent.handle.height / 2 - height / 2
            width: root.handleSize.width
            height: root.handleSize.height
            pressed: root.pressed
            active: enabled && (root.down || root.visualFocus || root.hovered)
            color: root.checked ? root.Material.highlightedRippleColor : root.Material.rippleColor
        }
    }

    contentItem: Text {
        leftPadding: root.indicator && !root.mirrored ? root.indicator.width + root.spacing : 0
        rightPadding: root.indicator && root.mirrored ? root.indicator.width + root.spacing : 0
        text: root.text
        font: root.font
        color: root.enabled ? root.Material.foreground : root.Material.hintTextColor
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }
}

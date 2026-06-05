pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.Button {
    id: root
    scale: root.elementScale
    opacity: root.elementOpacity
    spacing: root.elementSpacing
    icon.width: root.iconSize.width
    icon.height: root.iconSize.height
    display: root.width <= root.height ? AbstractButton.TextUnderIcon : AbstractButton.TextBesideIcon
    verticalPadding: root.elementPadding
    horizontalPadding: root.flat ? 0 : Material.buttonVerticalPadding
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding)
    icon.color: !enabled ? Material.hintTextColor : (root.flat && root.highlighted) || (root.checked && !root.highlighted) ? Material.accentColor : highlighted ? Material.primaryHighlightedTextColor : Material.foreground

    property int radius: ElementStyle.elementRadius * 2

    readonly property size iconSize: Qt.size(24, 24)
    readonly property size buttonimplicitSize: Qt.size(64, Material.buttonHeight)
    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property int elementPadding: ElementStyle.elementPadding
    readonly property var elementScale: root.pressed ? 0.95 : 1.0
    readonly property var elementOpacity: root.pressed || !root.enabled ? 0.6 : 1.0
    readonly property int elevation: root.down ? 8 : 2
    readonly property int scaleDuration: 120

    background: Rectangle {
        implicitWidth: root.buttonimplicitSize.width
        implicitHeight: root.buttonimplicitSize.height
        color: Material.buttonColor(Material.theme, Material.background, Material.accent, root.enabled, root.flat, root.highlighted, root.checked)
        radius: root.radius
        layer.enabled: root.enabled && color.a > 0 && !root.flat
        layer.effect: RoundedElevationEffect {
            elevation: root.elevation
            roundedScale: root.radius
        }
    }

    contentItem: IconLabel {
        spacing: root.spacing
        mirrored: root.mirrored
        display: root.display
        icon: root.icon
        text: root.text
        font: root.font
        color: !root.enabled ? Material.hintTextColor : (root.flat && root.highlighted) || (root.checked && !root.highlighted) ? Material.accentColor : root.highlighted ? Material.primaryHighlightedTextColor : Material.foreground
    }

    Ripple {
        clip: true
        anchors.fill: parent
        enabled: !root.flat
        visible: !root.flat
        clipRadius: root.radius
        pressed: root.pressed || root.hovered
        active: enabled && (root.down || root.visualFocus || root.hovered)
        color: root.highlighted ? Material.highlightedRippleColor : Material.rippleColor
    }

    Behavior on scale {
        NumberAnimation {
            duration: root.scaleDuration
        }
    }
}

pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
// import QtQuick.Layouts
import QtQuick.Controls.impl
import QtQuick.Templates as T
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.Button {
    id: root
    scale: root.elementScale
    opacity: root.elementOpacity
    spacing: root.elementSpacing
    icon.width: 24
    icon.height: 24
    display: root.width <= root.height ? AbstractButton.TextUnderIcon : AbstractButton.TextBesideIcon
    background: Rectangle {
        color: root.Material.background
        radius: root.radius
        layer.enabled: root.enabled && color.a > 0 && !root.flat
        layer.effect: RoundedElevationEffect {
            elevation: root.Material.elevation
            roundedScale: root.radius
        }
    }
    Material.elevation: root.down ? 8 : 4

    property int radius: ElementStyle.elementRadius

    readonly property string textColor: root.Material.foreground
    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property var elementScale: root.pressed ? 0.95 : 1.0
    readonly property var elementOpacity: root.pressed ? 0.6 : 1.0
    readonly property int scaleDuration: 120

    Ripple {
        clip: true
        anchors.fill: parent
        clipRadius: root.radius
        pressed: root.pressed
        active: enabled && (root.down || root.visualFocus || root.hovered)
        color: root.flat && root.highlighted ? root.Material.highlightedRippleColor : root.Material.rippleColor
    }

    contentItem: IconLabel {
        spacing: root.spacing
        mirrored: root.mirrored
        display: root.display
        icon: root.icon
        text: root.text
        font: root.font
        color: !root.enabled ? root.Material.hintTextColor : (root.flat && root.highlighted) || (root.checked && !root.highlighted) ? root.Material.accentColor : root.highlighted ? root.Material.primaryHighlightedTextColor : root.Material.foreground
    }

    Behavior on scale {
        NumberAnimation {
            duration: root.scaleDuration
        }
    }
}

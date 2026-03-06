import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.CheckBox {
    id: root
    implicitWidth: contentItem.implicitWidth
    implicitHeight: indicator.implicitHeight

    property int radius: 2

    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property size boxSize: Qt.size(18, 18)

    indicator: CheckIndicator {
        width: root.boxSize.width
        height: root.boxSize.height
        control: root
        radius: root.radius

        Ripple {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            z: -1
            anchor: root
            width: root.indicator.width * 2
            height: root.indicator.height * 2
            pressed: root.pressed || root.hovered
            active: enabled && (root.down || root.visualFocus || root.hovered)
            color: root.checked ? Material.highlightedRippleColor : Material.rippleColor
        }
    }

    contentItem: Text {
        text: root.text
        height: root.indicator.height
        color: root.enabled ? Material.foreground : Material.hintTextColor
        font: root.font
        elide: Text.ElideRight
        leftPadding: root.indicator.width + root.elementSpacing
        verticalAlignment: Text.AlignVCenter
    }
}

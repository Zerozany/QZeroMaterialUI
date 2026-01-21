import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.CheckBox {
    id: root
    implicitWidth: contentItem.implicitWidth
    implicitHeight: indicator.implicitHeight

    property string textColor: ThemeManager.currentTheme["TextColor"]
    property string boxColor: "#7FFFD4"
    property int radius: 2

    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property int boxSize: 18
    readonly property real boxRippleOpacity: 0.3
    readonly property string boxBackgroundColor: "transparent"

    indicator: CheckIndicator {
        width: root.boxSize
        height: root.boxSize
        control: root
        enabled: root.enabled
        radius: root.radius
        color: root.boxBackgroundColor
        border.color: !control.enabled ? control.Material.hintTextColor : checkState !== Qt.Unchecked ? root.boxColor : control.Material.secondaryTextColor
        border.width: checkState !== Qt.Unchecked ? width / 2 : 2
        anchors.verticalCenter: root.verticalCenter

        Ripple {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            z: -1
            anchor: root
            width: root.indicator.width * 2
            height: root.indicator.height * 2
            pressed: root.pressed
            active: root.enabled && (root.down || root.hovered)
            color: root.boxColor
            opacity: root.boxRippleOpacity
        }
    }

    contentItem: Text {
        text: root.text
        height: root.indicator.height
        color: root.textColor
        font: root.font
        elide: Text.ElideRight
        leftPadding: root.indicator.width + root.elementSpacing
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
    }
}

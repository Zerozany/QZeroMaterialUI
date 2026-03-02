import QtQuick
import QtQuick.Controls.Material.impl
import QtQuick.Templates as T

T.Switch {
    id: root

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding, implicitIndicatorHeight + topPadding + bottomPadding)
    width: root.normalWidth
    height: root.normalHeight
    spacing: root.elementSpacing
    background: MouseArea {
        cursorShape: Qt.PointingHandCursor
    }

    property color checkedColor: "#7FFFD4"
    readonly property color unCheckedColor: "#CFCFCF"
    readonly property int normalWidth: 56
    readonly property int normalHeight: 26
    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property int elementRadius: ElementStyle.elementRadius

    Keys.onSpacePressed: function (event) {
        event.accepted = true;
    }

    indicator: SwitchIndicator {
        control: root
        width: root.width
        height: root.height
        handle.width: root.width * 0.6
        handle.height: root.height * 0.9
        radius: root.elementRadius * 3
        handle.radius: root.elementRadius * 3
        color: root.checked ? root.checkedColor : root.unCheckedColor
        border.color: "transparent"
        opacity: root.enabled ? 1.0 : 0.6
    }
}

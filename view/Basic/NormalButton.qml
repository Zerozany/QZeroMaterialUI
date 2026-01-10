import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Controls.Material.impl

T.Button {
    id: root
    font.family: ThemeFont.fontFamily
    scale: root.elementScale
    opacity: root.elementOpacity
    display: root.width <= root.height ? AbstractButton.TextUnderIcon : AbstractButton.TextBesideIcon
    clip: true

    background: Rectangle {
        color: root.color
        radius: root.radius
    }

    property string color: ThemeManager.currentTheme["elementColor"]
    property string textColor: ThemeManager.currentTheme["textColor"]
    property int radius: ElementStyle.elementRadius
    property string rippleColor: ""

    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property string fontFamily: ThemeFont.fontFamily
    readonly property var elementScale: root.pressed ? 0.9 : 1.0
    readonly property var elementOpacity: root.pressed ? 0.6 : 1.0
    readonly property int scaleDuration: 120

    Ripple {
        anchors.fill: parent
        clipRadius: root.radius
        pressed: root.pressed
        active: root.down || root.hovered
        visible: root.rippleColor !== ""
        color: root.rippleColor
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: root.elementSpacing
        visible: root.display === AbstractButton.TextBesideIcon

        Image {
            source: root.icon.source
            visible: root.icon.source.toString() !== ""
            fillMode: Image.PreserveAspectFit
            Layout.preferredWidth: root.height * 0.3
            Layout.preferredHeight: root.height * 0.3
            Layout.alignment: Qt.AlignVCenter
        }
        Text {
            text: root.text
            visible: root.text !== ""
            color: root.textColor
            wrapMode: Text.WordWrap
            font: root.font
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: root.elementSpacing
        visible: root.display === AbstractButton.TextUnderIcon

        Image {
            source: root.icon.source
            visible: root.icon.source.toString() !== ""
            fillMode: Image.PreserveAspectFit
            Layout.preferredWidth: root.width * 0.5
            Layout.preferredHeight: root.width * 0.5
            Layout.alignment: Qt.AlignHCenter
        }
        Text {
            text: root.text
            visible: root.text !== ""
            color: root.textColor
            wrapMode: Text.WordWrap
            font: root.font
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter
        }
    }

    Behavior on scale {
        NumberAnimation {
            duration: root.scaleDuration
        }
    }
}

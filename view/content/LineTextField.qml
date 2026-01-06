import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: root.elementColor
    border.color: inputText.activeFocus ? "black" : "#DCDCDC"
    radius: root.elementRadius

    property var text: null
    property var placeText: null
    property url source: ""
    property url passwordSource: ""
    property url passwordPressedSource: ""
    property url clearSource: ""
    property bool password: false
    property bool fontBold: false

    readonly property string elementColor: ThemeManager.currentTheme["elementColor"]
    readonly property string textColor: ThemeManager.currentTheme["textColor"]
    readonly property int elementRadius: ElementStyle.elementRadius * 2
    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property int elementMargins: ElementStyle.elementMargins * 2
    readonly property string fontFamily: ThemeFont.fontFamily
    readonly property string placeholderTextColor: "gray"
    readonly property string passwordCharacter: "•"

    RowLayout {
        anchors.fill: parent

        Image {
            source: root.source
            Layout.preferredWidth: root.height * 0.5
            Layout.preferredHeight: root.height * 0.5
            Layout.leftMargin: root.elementMargins
            Layout.alignment: Qt.AlignVCenter
            fillMode: Image.PreserveAspectFit
        }

        TextField {
            id: inputText
            placeholderText: root.placeText
            placeholderTextColor: root.placeholderTextColor
            echoMode: root.password ? TextInput.Password : TextInput.Normal
            passwordCharacter: root.passwordCharacter
            font.letterSpacing: root.elementSpacing * 0.5
            font.bold: root.fontBold
            leftPadding: 0
            rightPadding: 0
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            background: Rectangle {
                border.color: "transparent"
                color: "transparent"
            }
        }

        Image {
            id: clearImage
            source: root.clearSource
            Layout.preferredWidth: root.height * 0.5
            Layout.preferredHeight: root.height * 0.5
            Layout.rightMargin: root.password ? 0 : root.elementMargins
            Layout.alignment: Qt.AlignVCenter
            fillMode: Image.Pad

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    inputText.clear();
                }
            }
        }

        Image {
            id: passwordImage
            source: root.passwordSource
            visible: root.password
            Layout.preferredWidth: root.height * 0.5
            Layout.preferredHeight: root.height * 0.5
            Layout.rightMargin: root.elementMargins
            Layout.alignment: Qt.AlignVCenter
            fillMode: Image.PreserveAspectFit

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    inputText.echoMode = inputText.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password;
                    parent.source = parent.source === root.passwordSource ? root.passwordPressedSource : root.passwordSource;
                }
            }
        }
    }

    MouseArea {
        parent: Overlay.overlay
        anchors.fill: parent
        enabled: inputText.activeFocus
        propagateComposedEvents: true
        onClicked: function (_mouse) {
            var localPos = passwordImage.mapFromItem(parent, _mouse.x, _mouse.y);
            if (root.password && passwordImage.contains(localPos)) {
                inputText.echoMode = inputText.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password;
                passwordImage.source = passwordImage.source === root.passwordSource ? root.passwordPressedSource : root.passwordSource;
                return;
            }
            localPos = clearImage.mapFromItem(parent, _mouse.x, _mouse.y);
            if (clearImage.contains(localPos)) {
                inputText.clear();
                return;
            }
            localPos = root.mapFromItem(parent, _mouse.x, _mouse.y);
            if (localPos.x < 0 || localPos.y < 0 || localPos.x > root.width || localPos.y > root.height) {
                inputText.focus = false;
                return;
            }
        }
    }
}

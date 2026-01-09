import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: root.elementColor
    border.color: inputText.activeFocus ? "black" : "transparent"
    radius: root.elementRadius

    property url source: ""
    property url passwordSource: ""
    property url passwordPressedSource: ""
    property url clearSource: ""
    property bool password: false
    property alias text: inputText.text
    property alias placeText: inputText.placeholderText
    property alias fontBold: inputText.font.bold
    property alias readOnly: inputText.readOnly

    readonly property string elementColor: ThemeManager.currentTheme["elementColor"]
    readonly property string textColor: ThemeManager.currentTheme["textColor"]
    readonly property int elementRadius: ElementStyle.elementRadius * 2
    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property int elementMargins: ElementStyle.elementMargins * 2
    readonly property string placeholderTextColor: "gray"
    readonly property string passwordCharacter: "•"

    function __switchPasswordVisible() {
        inputText.echoMode = inputText.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password;
        passwordImage.source = passwordImage.source === root.passwordSource ? root.passwordPressedSource : root.passwordSource;
    }

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
            placeholderTextColor: root.placeholderTextColor
            echoMode: root.password ? TextInput.Password : TextInput.Normal
            passwordCharacter: root.passwordCharacter
            color: root.textColor
            font.letterSpacing: root.elementSpacing * 0.5
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            background: Rectangle {
                border.color: "transparent"
                color: "transparent"
            }

            onActiveFocusChanged: {
                if (activeFocus) {
                    cursorPosition = text.length;
                    return;
                }
                cursorPosition = 0;
            }
        }

        Image {
            id: clearImage
            source: root.clearSource
            Layout.preferredWidth: root.height * 0.5
            Layout.preferredHeight: root.height * 0.5
            Layout.alignment: Qt.AlignVCenter
            fillMode: Image.Pad
        }

        Image {
            id: passwordImage
            source: root.password ? root.passwordSource : ""
            Layout.preferredWidth: root.height * 0.5
            Layout.preferredHeight: root.height * 0.5
            Layout.rightMargin: root.elementMargins
            Layout.alignment: Qt.AlignVCenter
            fillMode: Image.PreserveAspectFit
        }
    }

    MouseArea {
        parent: inputText.activeFocus ? Overlay.overlay : root
        anchors.fill: parent

        onClicked: function (_mouse) {
            var localPos = inputText.mapFromItem(parent, _mouse.x, _mouse.y);
            if (inputText.contains(localPos)) {
                inputText.forceActiveFocus(true);
                return;
            }
            localPos = passwordImage.mapFromItem(parent, _mouse.x, _mouse.y);
            if (root.password && passwordImage.contains(localPos)) {
                root.__switchPasswordVisible();
                return;
            }
            localPos = clearImage.mapFromItem(parent, _mouse.x, _mouse.y);
            if (clearImage.contains(localPos)) {
                inputText.clear();
                return;
            }
            localPos = root.mapFromItem(parent, _mouse.x, _mouse.y);
            if (!root.contains(localPos)) {
                inputText.focus = false;
                return;
            }
        }
    }
}

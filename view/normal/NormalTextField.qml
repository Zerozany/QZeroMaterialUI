pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.TextField {
    id: root
    leftPadding: root.height * 0.5 + root.elementMargins * 2
    rightPadding: root.height + root.elementMargins * 2.5
    color: enabled && activeFocus ? root.textColor : Material.hintTextColor
    selectionColor: root.borderColor
    selectedTextColor: root.constSelectedTextColor
    placeholderTextColor: enabled && activeFocus ? root.textColor : Material.hintTextColor
    verticalAlignment: TextInput.AlignVCenter
    Material.containerStyle: Material.Outlined
    cursorDelegate: CursorDelegate {
        color: root.borderColor
    }

    property url source: ""
    property url lockSource: "qrc:/qt/qml/QZeroZanyUI/view/resource/NormalTextField/Lock.png"
    property url unlockSource: "qrc:/qt/qml/QZeroZanyUI/view/resource/NormalTextField/UnLock.png"
    property url clearSource: "qrc:/qt/qml/QZeroZanyUI/view/resource/NormalTextField/Clear.png"
    property color borderColor: "#7FFFD4"

    readonly property string textColor: ThemeManager.currentTheme["textColor"]
    readonly property int elementMargins: ElementStyle.elementMargins * 2
    readonly property string constSelectedTextColor: "white"
    readonly property size childElementSize: Qt.size(root.height * 0.5, root.height * 0.5)

    FloatingPlaceholderText {
        id: placeholder
        width: root.width - (root.leftPadding + root.rightPadding)
        text: root.placeholderText
        font: root.font
        color: root.placeholderTextColor
        elide: Text.ElideRight
        controlHasActiveFocus: root.activeFocus
        controlHasText: root.length > 0
        controlImplicitBackgroundHeight: root.implicitBackgroundHeight
        controlHeight: root.height
        leftPadding: root.leftPadding
        floatingLeftPadding: root.Material.textFieldHorizontalPadding
    }

    Image {
        source: root.source
        width: root.childElementSize.width
        height: root.childElementSize.height
        anchors.left: parent.left
        anchors.leftMargin: root.elementMargins
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        fillMode: Image.PreserveAspectFit
    }

    Image {
        source: root.clearSource
        width: root.childElementSize.width
        height: root.childElementSize.height
        anchors.right: root.right
        anchors.rightMargin: root.elementMargins * 1.5 + root.childElementSize.width
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        fillMode: Image.Pad

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.clear();
            }
        }
    }

    Image {
        source: root.lockSource
        width: root.childElementSize.width
        height: root.childElementSize.height
        anchors.right: parent.right
        anchors.rightMargin: root.elementMargins
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.echoMode = root.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password;
                parent.source = parent.source === root.lockSource ? root.unlockSource : root.lockSource;
            }
        }

        Component.onCompleted: {
            if (root.echoMode !== TextInput.Password) {
                visible = false;
            }
        }
    }

    background: MaterialTextContainer {
        implicitWidth: root.height
        implicitHeight: root.Material.textFieldHeight
        filled: root.Material.containerStyle === Material.Filled
        fillColor: root.Material.textFieldFilledContainerColor
        outlineColor: (enabled && root.hovered) ? root.Material.primaryTextColor : root.Material.hintTextColor
        focusedOutlineColor: root.borderColor
        placeholderTextWidth: Math.min(placeholder.width, placeholder.implicitWidth) * placeholder.scale
        placeholderTextHAlign: root.effectiveHorizontalAlignment
        controlHasActiveFocus: root.activeFocus
        controlHasText: root.length > 0
        placeholderHasText: placeholder.text.length > 0
        horizontalPadding: root.Material.textFieldHorizontalPadding
    }

    MouseArea {
        parent: root.enabled && root.activeFocus ? root.Window.window.contentItem : root
        anchors.fill: parent
        z: -99

        onClicked: function (_mouse) {
            var localPos = root.mapFromItem(parent, _mouse.x, _mouse.y);
            if (!root.contains(localPos)) {
                root.focus = false;
                return;
            }
        }
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            cursorPosition = text.length;
            return;
        }
        cursorPosition = 0;
    }
}

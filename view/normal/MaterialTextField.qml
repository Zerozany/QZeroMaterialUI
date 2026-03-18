import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.TextField {
    id: root
    implicitWidth: implicitBackgroundWidth + leftInset + rightInset || Math.max(contentWidth, placeholder.implicitWidth) + leftPadding + rightPadding
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, contentHeight + topPadding + bottomPadding)
    leftPadding: leftSource.toString().length > 0 ? root.height * 0.5 + root.elementMargins * 2 : root.elementMargins
    rightPadding: root.height + root.elementMargins * 2.5
    color: enabled && activeFocus ? Material.foreground : Material.hintTextColor
    selectionColor: Material.foreground
    selectedTextColor: Material.primaryHighlightedTextColor
    placeholderTextColor: enabled && activeFocus ? Material.accentColor : Material.hintTextColor
    verticalAlignment: TextInput.AlignVCenter
    Material.containerStyle: Material.Outlined
    cursorDelegate: CursorDelegate {
        color: Material.foreground
    }

    property url leftSource: ""
    property url rightSource: ""
    property url clearSource: "qrc:/qt/qml/QZeroMaterialUI/view/resource/normalTextField/clear.png"

    readonly property int elementMargins: ElementStyle.elementMargins * 2
    readonly property size imageSize: Qt.size(root.height * 0.5, root.height * 0.5)
    readonly property int materialTextContainerWidht: 300

    background: MaterialTextContainer {
        implicitWidth: root.materialTextContainerWidht
        implicitHeight: Material.textFieldHeight
        filled: parent.Material.containerStyle === Material.Filled
        fillColor: Material.textFieldFilledContainerColor
        outlineColor: (enabled && root.hovered) ? Material.foreground : Material.hintTextColor
        focusedOutlineColor: Material.foreground
        placeholderTextWidth: Math.min(placeholder.width, placeholder.implicitWidth) * placeholder.scale
        placeholderTextHAlign: root.effectiveHorizontalAlignment
        controlHasActiveFocus: root.activeFocus
        controlHasText: root.length > 0
        placeholderHasText: placeholder.text.length > 0
        horizontalPadding: Material.textFieldHorizontalPadding
    }

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
        floatingLeftPadding: Material.textFieldHorizontalPadding
    }

    Image {
        source: root.leftSource
        width: root.imageSize.width
        height: root.imageSize.height
        anchors.left: parent.left
        anchors.leftMargin: root.elementMargins
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        visible: source.toString().length > 0
    }

    Image {
        source: root.clearSource
        width: root.imageSize.width
        height: root.imageSize.height
        anchors.right: root.right
        anchors.rightMargin: root.elementMargins * 1.5 + root.imageSize.width
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.Pad
        scale: 0.5

        TapHandler {
            onTapped: {
                root.clear();
            }
        }
    }

    Image {
        source: root.rightSource
        width: root.imageSize.width
        height: root.imageSize.height
        anchors.right: parent.right
        anchors.rightMargin: root.elementMargins
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit

        TapHandler {
            onTapped: {
                root.echoMode = root.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password;
            }
        }

        Component.onCompleted: {
            visible = root.echoMode !== TextInput.Password ? false : true;
        }
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            root.cursorPosition = text.length;
            return;
        }
        root.cursorPosition = 0;
    }
}

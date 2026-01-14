pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.TextField {
    id: root
    leftPadding: Material.textFieldHorizontalPadding
    rightPadding: Material.textFieldHorizontalPadding
    color: enabled ? root.textColor : Material.hintTextColor
    // selectionColor: Material.accentColor
    // selectedTextColor: Material.primaryHighlightedTextColor
    placeholderTextColor: enabled && activeFocus ? Material.accentColor : Material.hintTextColor
    verticalAlignment: TextInput.AlignVCenter
    Material.containerStyle: Material.Outlined
    cursorDelegate: CursorDelegate {
        color: root.borderColor
    }

    property color borderColor: "#7FFFD4"

    readonly property string textColor: ThemeManager.currentTheme["textColor"]

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
}

pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Window
import QtQuick.Controls.impl
import QtQuick.Templates as T
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.ComboBox {
    id: root
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding, implicitIndicatorHeight + topPadding + bottomPadding)
    leftPadding: padding + (!root.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: padding + (root.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)

    property int radius: root.elementRadius * 2

    readonly property int elementRadius: ElementStyle.elementRadius
    readonly property int elementPadding: ElementStyle.elementPadding
    readonly property int elementMargins: ElementStyle.elementMargins
    readonly property size indicatorSize: Qt.size(10, 10)
    readonly property url indicatorSource: "qrc:/qt/qml/QZeroMaterialUI/view/resource/normalComboBox/cursor.png"
    readonly property int backgroundWidth: 120

    Material.background: flat ? "transparent" : undefined
    Material.foreground: flat ? undefined : Material.primaryTextColor

    delegate: MenuItem {
        required property var model
        required property int index

        width: ListView.view.width
        text: model[root.textRole]
        Material.foreground: root.currentIndex === index ? ListView.view.contentItem.Material.accent : ListView.view.contentItem.Material.foreground
        highlighted: root.highlightedIndex === index
        hoverEnabled: root.hoverEnabled
    }

    indicator: ColorImage {
        x: root.mirrored ? root.elementPadding : root.width - width - root.elementPadding
        y: root.topPadding + (root.availableHeight - height) / 2
        color: root.enabled ? Material.foreground : Material.hintTextColor
        source: root.indicatorSource
        fillMode: Image.PreserveAspectFit
        width: root.indicatorSize.width
        height: root.indicatorSize.height
        rotation: root.popup.visible ? 180 : 0

        Behavior on rotation {
            NumberAnimation {
                duration: 50
                easing.type: Easing.OutCubic
            }
        }
    }

    contentItem: T.TextField {
        leftPadding: Material.textFieldHorizontalPadding
        topPadding: Material.textFieldVerticalPadding
        bottomPadding: Material.textFieldVerticalPadding
        text: root.editable ? root.editText : root.displayText
        enabled: root.editable
        autoScroll: root.editable
        readOnly: root.down
        inputMethodHints: root.inputMethodHints
        validator: root.validator
        selectByMouse: root.selectTextByMouse
        color: root.enabled ? root.Material.foreground : root.Material.hintTextColor
        selectionColor: root.Material.accentColor
        selectedTextColor: root.Material.primaryHighlightedTextColor
        verticalAlignment: Text.AlignVCenter
        cursorDelegate: CursorDelegate {}
    }

    background: MaterialTextContainer {
        implicitWidth: root.backgroundWidth
        implicitHeight: root.Material.textFieldHeight
        outlineColor: (enabled && root.hovered) ? root.Material.primaryTextColor : root.Material.hintTextColor
        focusedOutlineColor: root.Material.accentColor
        controlHasActiveFocus: root.activeFocus
        controlHasText: true
        horizontalPadding: root.Material.textFieldHorizontalPadding
    }

    popup: T.Popup {
        y: root.height + root.elementPadding
        width: root.width
        height: Math.min(contentItem.implicitHeight + verticalPadding * 2, root.Window.height - topMargin - bottomMargin)
        transformOrigin: Item.Top
        topMargin: root.elementMargins
        bottomMargin: root.elementMargins
        verticalPadding: root.elementPadding

        Material.theme: root.Material.theme
        Material.accent: root.Material.accent
        Material.primary: root.Material.primary

        enter: Transition {
            NumberAnimation {
                property: "scale"
                from: 0.9
                easing.type: Easing.OutQuint
                duration: 220
            }
            NumberAnimation {
                property: "opacity"
                from: 0.0
                easing.type: Easing.OutCubic
                duration: 150
            }
        }

        exit: Transition {
            NumberAnimation {
                property: "scale"
                to: 0.9
                easing.type: Easing.OutQuint
                duration: 220
            }
            NumberAnimation {
                property: "opacity"
                to: 0.0
                easing.type: Easing.OutCubic
                duration: 150
            }
        }

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: root.delegateModel
            currentIndex: root.highlightedIndex
            highlightMoveDuration: 0
            T.ScrollIndicator.vertical: ScrollIndicator {}
        }

        background: Rectangle {
            radius: root.radius
            color: parent.Material.dialogColor
            layer.enabled: root.enabled
            layer.effect: RoundedElevationEffect {
                elevation: 4
                roundedScale: Material.ExtraSmallScale
            }
        }
    }
}

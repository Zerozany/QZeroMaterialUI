pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls

T.ComboBox {
    id: root

    property int radius: root.elementRadius
    property int popupWidth: root.width
    property string borderColor: "#52f5be"
    property string color: root.elementColor
    property string popupColor: root.elementColor
    property url cursorSource: "qrc:/qt/qml/QZeroMaterialUI/view/resource/normalComboBox/cursor.png"

    readonly property string elementColor: ThemeManager.currentTheme["ElementColor"]
    readonly property string borderDefaultColor: "#CCCCCC"
    readonly property int elementRadius: ElementStyle.elementRadius
    readonly property int elementMargins: ElementStyle.elementMargins
    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property string fontFamily: ThemeFont.fontFamily
    readonly property size cursorSize: Qt.size(12, 12)

    contentItem: Text {
        text: root.displayText
        font.family: root.fontFamily
        leftPadding: root.elementMargins * 2
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }

    background: Rectangle {
        radius: root.radius
        color: root.color
        border.color: root.down ? root.borderDefaultColor : root.borderColor
    }

    indicator: Image {
        anchors.right: parent.right
        anchors.rightMargin: root.elementMargins * 2
        anchors.verticalCenter: parent.verticalCenter
        source: root.cursorSource
        width: root.cursorSize.width
        height: root.cursorSize.height
        fillMode: Image.PreserveAspectFit
        rotation: root.popup.visible ? 180 : 0

        Behavior on rotation {
            NumberAnimation {
                duration: 50
                easing.type: Easing.OutCubic
            }
        }
    }

    popup: Popup {
        x: (root.width - width) * 0.5
        y: root.height + root.elementMargins
        width: root.popupWidth
        padding: root.elementSpacing
        clip: true
        background: Rectangle {
            radius: root.elementRadius
            color: root.popupColor
            border.color: root.borderColor
        }

        contentItem: ListView {
            implicitHeight: contentHeight
            model: root.delegateModel
            delegate: ItemDelegate {
                required property int index
                required property var modelData
                width: ListView.view.width
                text: modelData
                highlighted: root.currentIndex === index

                onClicked: {
                    // root.highlightedIndex = index;
                    root.activated(index);
                    root.popup.close();
                }
            }
        }
    }
}

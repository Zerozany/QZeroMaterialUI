pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls

T.ComboBox {
    id: root

    property string color: ThemeManager.currentTheme["ElementColor"]
    property string borderColor: '#52f5be'
    property url cursorSource: "qrc:/qt/qml/QZeroZanyUI/view/resource/normalComboBox/cursor.png"

    readonly property string borderDefaultColor: "#CCCCCC"
    readonly property int elementRadius: ElementStyle.elementRadius
    readonly property int elementMargins: ElementStyle.elementMargins
    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property string fontFamily: ThemeFont.fontFamily
    readonly property size cursorSize: Qt.size(12, 12)

    contentItem: Text {
        text: root.displayText
        font.family: root.fontFamily
        leftPadding: root.elementMargins * 3
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        radius: root.elementRadius
        color: root.color
        border.color: root.down ? root.borderColor : root.borderDefaultColor
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
        y: root.height
        width: root.width
        padding: root.elementSpacing
        clip: true
        background: Rectangle {
            radius: root.elementRadius
            color: root.color
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
                    root.currentIndex = index;
                    root.popup.close();
                }
            }
        }
    }
}

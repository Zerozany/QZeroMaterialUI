pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    radius: root.elementRadius
    color: root.elementColor

    signal clicked

    property var text: null
    property url source: ""
    property url sourcePressed: ""
    property bool fontBold: false

    property bool _pressedTag: false
    readonly property string textPressedColor: ThemeManager.currentTheme["textPressedColor"]
    readonly property string elementColor: ThemeManager.currentTheme["elementColor"]
    readonly property string textColor: ThemeManager.currentTheme["textColor"]
    readonly property int elementRadius: ElementStyle.elementRadius
    readonly property int elementMargins: ElementStyle.elementMargins
    readonly property int elementSpacing: ElementStyle.elementSpacing
    readonly property string fontFamily: ThemeFont.fontFamily

    Loader {
        sourceComponent: root.width <= root.height ? verticalCom : horizontalCom
        anchors.centerIn: parent
    }

    Component {
        id: horizontalCom

        RowLayout {
            anchors.centerIn: parent
            spacing: root.elementSpacing

            Image {
                source: root._pressedTag ? root.sourcePressed : root.source
                visible: root.sourcePressed || root.source
                fillMode: Image.PreserveAspectFit
                Layout.preferredWidth: root.height * 0.3
                Layout.preferredHeight: root.height * 0.3
                Layout.alignment: Qt.AlignVCenter
            }
            Text {
                text: root.text
                color: root._pressedTag ? root.textPressedColor : root.textColor
                wrapMode: Text.WordWrap
                font.pixelSize: Math.floor(root.height * 0.3)
                font.bold: root.fontBold
                font.family: root.fontFamily
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    Component {
        id: verticalCom

        ColumnLayout {
            anchors.centerIn: parent
            spacing: root.elementSpacing

            Image {
                source: root._pressedTag ? root.sourcePressed : root.source
                visible: root.sourcePressed || root.source
                fillMode: Image.PreserveAspectFit
                Layout.preferredWidth: root.width * 0.5
                Layout.preferredHeight: root.width * 0.5
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: root.text
                color: root._pressedTag ? root.textPressedColor : root.textColor
                wrapMode: Text.WordWrap
                font.pixelSize: Math.floor(root.width * 0.25)
                font.bold: root.fontBold
                font.family: root.fontFamily
                verticalAlignment: Text.AlignVCenter
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onPressed: {
            root._pressedTag = true;
        }

        onPositionChanged: mouse => {
            if (!containsMouse && pressed) {
                root._pressedTag = false;
                mouse.accepted = false;
            }
        }

        onReleased: {
            root._pressedTag = false;
        }

        onCanceled: {
            root._pressedTag = false;
        }

        onClicked: root.clicked()
    }
}

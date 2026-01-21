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
    property bool fontBold: false

    readonly property string elementColor: ThemeManager.currentTheme["ElementColor"]
    readonly property string textColor: ThemeManager.currentTheme["TextColor"]
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
                source: root.source
                visible: root.source.toString() !== ""
                fillMode: Image.PreserveAspectFit
                Layout.preferredWidth: root.height * 0.3
                Layout.preferredHeight: root.height * 0.3
                Layout.alignment: Qt.AlignVCenter
            }
            Text {
                text: root.text
                color: root.textColor
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
                source: root.source
                visible: root.source.toString() !== ""
                fillMode: Image.PreserveAspectFit
                Layout.preferredWidth: root.width * 0.5
                Layout.preferredHeight: root.width * 0.5
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: root.text
                color: root.textColor
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
}

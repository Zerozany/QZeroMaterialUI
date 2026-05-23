import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    parent: Overlay.overlay
    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, root.brightness)

    property real brightness: 0.0
}

import QtQuick
import QtQuick.Controls.Material

Rectangle {
    id: root
    width: radius * 2
    height: radius * 2
    radius: 10
    color: Qt.hsla((Math.random() * 137.5) % 1, 0.7, 0.55, 1)
    border.color: Material.background
    border.width: 2
    antialiasing: true

    readonly property alias active: dragHandler.active
    readonly property alias activeTranslation: dragHandler.activeTranslation
    readonly property alias centroid: dragHandler.centroid
    readonly property alias acceptedDevices: dragHandler.acceptedDevices

    DragHandler {
        id: dragHandler
        target: null
        cursorShape: Qt.PointingHandCursor
    }
}

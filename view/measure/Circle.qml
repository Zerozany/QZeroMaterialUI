import QtQuick
import QtQuick.Controls.Material
import QtQuick.Shapes

Item {
    id: root
    width: parent ? parent.width : defaultSize.width
    height: parent ? parent.height : defaultSize.height
    clip: false

    property string unit: "px"
    property real ratio: 1.0
    property real radius: Math.min(width, height) * 0.25
    property string text: "R " + (radius * ratio).toFixed(1) + " " + unit
    property alias centerPoint: centerPoint

    property real lastTranslation: 0
    readonly property real pointRadius: 10
    readonly property real sideWidth: 2
    readonly property size defaultSize: Qt.size(300, 300)
    readonly property color sideColor: Qt.hsla(Math.random(), 0.7, 0.55, 1)
    readonly property color color: "transparent"
    readonly property int pointSize: 12

    Shape {
        id: circleShape
        anchors.fill: parent
        containsMode: Shape.FillContains

        ShapePath {
            strokeColor: root.sideColor
            strokeWidth: root.sideWidth
            fillColor: root.color
            strokeStyle: ShapePath.DashLine
            dashPattern: [12, 4, 2, 4]
            dashOffset: 0
            startX: centerPoint.x + Math.max(0, root.radius)
            startY: centerPoint.y

            PathAngleArc {
                centerX: centerPoint.x
                centerY: centerPoint.y
                radiusX: Math.max(0, root.radius)
                radiusY: Math.max(0, root.radius)
                startAngle: 0
                sweepAngle: 360
            }

            NumberAnimation on dashOffset {
                from: 0
                to: -22
                duration: 600
                loops: Animation.Infinite
                running: moveHandler.active || pinchHandler.active || wheelHandler.active
            }
        }

        DragHandler {
            id: moveHandler
            target: null
            cursorShape: Qt.PointingHandCursor
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchScreen

            property point startCenter: Qt.point(0, 0)
            property point pressCenter: Qt.point(0, 0)

            onActiveChanged: {
                if (!active) {
                    return;
                }
                startCenter.x = centerPoint.x;
                startCenter.y = centerPoint.y;
                var p = moveHandler.centroid.position;
                var r = parent.mapToItem(root, p.x, p.y);
                pressCenter.x = r.x;
                pressCenter.y = r.y;
            }

            onActiveTranslationChanged: {
                if (!active) {
                    return;
                }
                var p = moveHandler.centroid.position;
                var r = parent.mapToItem(root, p.x, p.y);
                centerPoint.x = Math.max(root.radius, Math.min(root.width - root.radius, startCenter.x + (r.x - pressCenter.x)));
                centerPoint.y = Math.max(root.radius, Math.min(root.height - root.radius, startCenter.y + (r.y - pressCenter.y)));
            }
        }

        PinchHandler {
            id: pinchHandler
            target: null
            minimumPointCount: 2
            maximumPointCount: 2

            onActiveChanged: {
                if (!active) {
                    return;
                }
                root.lastTranslation = root.radius;
            }

            onActiveScaleChanged: {
                if (!active) {
                    return;
                }
                root.radius = Math.max(Math.min(10, Math.min(root.width, root.height) / 2), Math.min(Math.min(root.width, root.height) / 2, root.lastTranslation * activeScale));
                centerPoint.x = Math.max(root.radius, Math.min(root.width - root.radius, centerPoint.x));
                centerPoint.y = Math.max(root.radius, Math.min(root.height - root.radius, centerPoint.y));
            }
        }

        WheelHandler {
            id: wheelHandler
            acceptedDevices: PointerDevice.Mouse

            onWheel: function (wheel) {
                var delta = wheel.angleDelta.y > 0 ? root.radius * 0.05 : -root.radius * 0.05;
                root.radius = Math.max(Math.min(10, Math.min(root.width, root.height) / 2), Math.min(Math.min(root.width, root.height) / 2, root.radius + delta));
                centerPoint.x = Math.max(root.radius, Math.min(root.width - root.radius, centerPoint.x));
                centerPoint.y = Math.max(root.radius, Math.min(root.height - root.radius, centerPoint.y));
            }
        }
    }

    Point {
        id: centerPoint
        radius: root.pointRadius
        x: root.width * 0.5
        y: root.height * 0.5
        color: root.sideColor
    }

    Label {
        enabled: false
        visible: text.length > 0
        width: implicitWidth * 1.2
        height: implicitHeight * 1.3
        x: Math.max(0, Math.min(root.width - width, centerPoint.x - width / 2))
        y: Math.max(0, Math.min(root.height - height, centerPoint.y - root.radius - height - 4))
        text: root.text
        color: Material.foreground
        font.pixelSize: root.pointSize
        font.bold: true
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
        background: Rectangle {
            color: Material.background
            border.color: root.sideColor
            border.width: root.sideWidth * 0.5
            radius: ElementStyle.elementRadius
        }
    }
}

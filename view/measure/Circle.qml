import QtQuick
import QtQuick.Controls.Material

Item {
    id: root
    width: parent ? parent.width : root.defaultSize.width
    height: parent ? parent.height : root.defaultSize.height
    clip: false

    property string unit: "px"
    property real ratio: 1.0
    property real centerRadius: 10
    property real sideWidth: 2
    property real radius: Math.min(width, height) * 0.25
    property point centerPoint: Qt.point(root.width * 0.5, root.height * 0.5)
    property string text: "R " + (root.radius * root.ratio).toFixed(1) + " " + root.unit
    property real backRadius: 0
    property real dashOffset: 0

    readonly property size defaultSize: Qt.size(300, 300)
    readonly property color sideColor: Qt.hsla(Math.random(), 0.7, 0.55, 1)
    readonly property color color: "transparent"

    Canvas {
        id: canvas
        anchors.fill: parent
        enabled: false
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.strokeStyle = root.sideColor;
            ctx.lineWidth = root.sideWidth;
            ctx.lineCap = "butt";
            ctx.setLineDash([12, 4, 2, 4]);
            ctx.lineDashOffset = root.dashOffset;
            ctx.beginPath();
            ctx.arc(root.centerPoint.x, root.centerPoint.y, Math.max(0, root.radius), 0, Math.PI * 2, false);
            ctx.stroke();
        }

        Connections {
            target: root
            function onWidthChanged() {
                canvas.requestPaint();
            }
            function onHeightChanged() {
                canvas.requestPaint();
            }
            function onSideWidthChanged() {
                canvas.requestPaint();
            }
            function onDashOffsetChanged() {
                canvas.requestPaint();
            }
            function onCenterPointChanged() {
                canvas.requestPaint();
            }
        }
    }

    Rectangle {
        id: moveArea
        radius: root.radius
        x: root.centerPoint.x - radius
        y: root.centerPoint.y - radius
        width: radius * 2
        height: radius * 2
        color: root.color

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
                startCenter.x = root.centerPoint.x;
                startCenter.y = root.centerPoint.y;
                var p = moveHandler.centroid.position;
                var r = moveArea.mapToItem(root, p.x, p.y);
                pressCenter.x = r.x;
                pressCenter.y = r.y;
            }

            onActiveTranslationChanged: {
                if (!active) {
                    return;
                }
                var p = moveHandler.centroid.position;
                var r = moveArea.mapToItem(root, p.x, p.y);
                root.centerPoint.x = Math.max(root.radius, Math.min(root.width - root.radius, startCenter.x + (r.x - pressCenter.x)));
                root.centerPoint.y = Math.max(root.radius, Math.min(root.height - root.radius, startCenter.y + (r.y - pressCenter.y)));
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
                root.backRadius = root.radius;
            }

            onActiveScaleChanged: {
                if (!active) {
                    return;
                }
                root.radius = Math.max(Math.min(10, Math.min(root.width, root.height) / 2), Math.min(Math.min(root.width, root.height) / 2, root.backRadius * activeScale));
            }
        }

        WheelHandler {
            id: wheelHandler
            acceptedDevices: PointerDevice.Mouse

            onWheel: function (wheel) {
                var maxRadius = Math.min(root.width, root.height) / 2;
                var minRadius = Math.min(10, maxRadius);
                var step = root.radius * 0.05;
                if (wheel.angleDelta.y > 0) {
                    root.radius = Math.min(maxRadius, root.radius + step);
                } else if (wheel.angleDelta.y < 0) {
                    root.radius = Math.max(minRadius, root.radius - step);
                }
            }
        }
    }

    Point {
        radius: root.centerRadius
        width: radius * 2
        height: radius * 2
        x: root.centerPoint.x
        y: root.centerPoint.y
        color: root.sideColor
    }

    Label {
        enabled: false
        visible: text.length > 0
        width: implicitWidth * 1.2
        height: implicitHeight * 1.3
        x: Math.max(0, Math.min(root.width - width, root.centerPoint.x - width / 2))
        y: Math.max(0, Math.min(root.height - height, root.centerPoint.y - root.radius - height - 4))
        text: root.text
        color: Material.foreground
        font.pixelSize: 12
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

    NumberAnimation on dashOffset {
        from: 0
        to: -22
        duration: 600
        loops: Animation.Infinite
        running: moveHandler.active || pinchHandler.active
    }
}

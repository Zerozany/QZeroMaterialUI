import QtQuick
import QtQuick.Controls.Material

Item {
    id: root
    width: parent ? parent.width : basicSize.width
    height: parent ? parent.height : basicSize.height
    clip: false

    property string unit: "px"
    property real ratio: 1.0
    property real radius: 10
    property real lineWidth: 2
    property string text: root.distance.toFixed(1) + " " + root.unit
    property point startPoint: Qt.point(root.width * 0.25, root.height * 0.5)
    property point endPoint: Qt.point(root.width * 0.75, root.height * 0.5)
    property real dashOffset: 0

    readonly property size basicSize: Qt.size(300, 300)
    readonly property color lineColor: Qt.hsla(Math.random(), 0.7, 0.55, 1)
    readonly property color pointColor: Qt.hsla((Math.random() * 137.5) % 1, 0.7, 0.55, 1)
    readonly property real distance: {
        var dx = root.endPoint.x - root.startPoint.x;
        var dy = root.endPoint.y - root.startPoint.y;
        return Math.sqrt(dx * dx + dy * dy) * ratio;
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        enabled: false
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.strokeStyle = root.lineColor;
            ctx.lineWidth = root.lineWidth;
            ctx.lineCap = "butt";
            ctx.setLineDash([12, 4, 2, 4]);
            ctx.lineDashOffset = root.dashOffset;
            ctx.beginPath();
            ctx.moveTo(root.startPoint.x, root.startPoint.y);
            ctx.lineTo(root.endPoint.x, root.endPoint.y);
            ctx.stroke();
        }

        Connections {
            target: root
            function onStartPointChanged() {
                canvas.requestPaint();
            }
            function onEndPointChanged() {
                canvas.requestPaint();
            }
            function onDashOffsetChanged() {
                canvas.requestPaint();
            }
            function onWidthChanged() {
                canvas.requestPaint();
            }
            function onHeightChanged() {
                canvas.requestPaint();
            }
            function onLineColorChanged() {
                canvas.requestPaint();
            }
            function onLineWidthChanged() {
                canvas.requestPaint();
            }
            function onRadiusChanged() {
                canvas.requestPaint();
            }
        }
    }

    Point {
        id: startDrag
        radius: root.radius
        width: radius * 2
        height: radius * 2
        color: root.pointColor
        x: root.startPoint.x - radius
        y: root.startPoint.y - radius

        onActiveTranslationChanged: {
            if (!active) {
                return;
            }
            var p = startDrag.centroid.position;
            var r = startDrag.mapToItem(root, p.x, p.y);
            root.startPoint.x = Math.max(0, Math.min(root.width, r.x));
            root.startPoint.y = Math.max(0, Math.min(root.height, r.y));
        }
    }

    Point {
        id: endDrag
        radius: root.radius
        width: radius * 2
        height: radius * 2
        color: root.pointColor
        x: root.endPoint.x - radius
        y: root.endPoint.y - radius

        onActiveTranslationChanged: {
            if (!active) {
                return;
            }
            var p = endDrag.centroid.position;
            var r = endDrag.mapToItem(root, p.x, p.y);
            root.endPoint.x = Math.max(0, Math.min(root.width, r.x));
            root.endPoint.y = Math.max(0, Math.min(root.height, r.y));
        }
    }

    Label {
        enabled: false
        visible: text.length > 0
        width: implicitWidth * 1.2
        height: implicitHeight * 1.3
        x: Math.max(0, Math.min(root.width - width, (root.startPoint.x + root.endPoint.x) / 2 - width / 2))
        y: Math.max(0, Math.min(root.height - height, (root.startPoint.y + root.endPoint.y) / 2 - height / 2 - 18))
        text: root.text
        color: Material.foreground
        font.pixelSize: 12
        font.bold: true
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
        background: Rectangle {
            color: Material.background
            border.color: root.lineColor
            border.width: root.lineWidth * 0.5
            radius: ElementStyle.elementRadius
        }
    }

    NumberAnimation on dashOffset {
        from: 0
        to: -22
        duration: 600
        loops: Animation.Infinite
        running: startDrag.active || endDrag.active
    }
}

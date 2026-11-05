import QtQuick
import QtQuick.Controls.Material

Item {
    id: root
    width: parent ? parent.width : defaultSize.width
    height: parent ? parent.height : defaultSize.height
    clip: false

    property string unit: "px"
    property real ratio: 1.0
    property string text: distance.toFixed(1) + " " + unit
    property alias startPoint: startPoint
    property alias endPoint: endPoint

    property real dashOffset: 0
    readonly property real radius: 10
    readonly property real lineWidth: 2
    readonly property size defaultSize: Qt.size(300, 300)
    readonly property color lineColor: Qt.hsla(Math.random(), 0.7, 0.55, 1)
    readonly property color pointColor: Qt.hsla((Math.random() * 137.5) % 1, 0.7, 0.55, 1)
    readonly property real distance: Math.hypot(endPoint.x - startPoint.x, endPoint.y - startPoint.y) * root.ratio

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
            ctx.moveTo(startPoint.x, startPoint.y);
            ctx.lineTo(endPoint.x, endPoint.y);
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
        }
    }

    Point {
        id: startPoint
        radius: root.radius
        width: radius * 2
        height: radius * 2
        color: root.pointColor
        x: root.width * 0.25
        y: root.height * 0.5

        onActiveTranslationChanged: {
            if (!active) {
                return;
            }
            var p = startPoint.centroid.position;
            var r = startPoint.mapToItem(root, p.x, p.y);
            x = Math.max(root.radius, Math.min(root.width - root.radius, r.x));
            y = Math.max(root.radius, Math.min(root.height - root.radius, r.y));
        }
    }

    Point {
        id: endPoint
        radius: root.radius
        width: radius * 2
        height: radius * 2
        color: root.pointColor
        x: root.width * 0.75
        y: root.height * 0.5

        onActiveTranslationChanged: {
            if (!active) {
                return;
            }
            var p = endPoint.centroid.position;
            var r = endPoint.mapToItem(root, p.x, p.y);
            x = Math.max(root.radius, Math.min(root.width - root.radius, r.x));
            y = Math.max(root.radius, Math.min(root.height - root.radius, r.y));
        }
    }

    Label {
        enabled: false
        visible: text.length > 0
        width: implicitWidth * 1.2
        height: implicitHeight * 1.3
        x: Math.max(0, Math.min(root.width - width, (startPoint.x + endPoint.x) / 2 - width / 2))
        y: Math.max(0, Math.min(root.height - height, (startPoint.y + endPoint.y) / 2 - height / 2 - 18))
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
        running: startPoint.active || endPoint.active
    }
}

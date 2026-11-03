import QtQuick
import QtQuick.Controls.Material

Item {
    id: root
    width: parent ? parent.width : basicSize.width
    height: parent ? parent.height : basicSize.height
    clip: false

    property real pointRadius: 10
    property real lineWidth: 2
    property string unit: "px"

    readonly property size basicSize: Qt.size(300, 300)
    readonly property color lineColor: Qt.hsla(Math.random(), 0.7, 0.55, 1)
    readonly property color pointColor: Qt.hsla((Math.random() * 137.5) % 1, 0.7, 0.55, 1)
    readonly property real distance: {
        var dx = privateProperty.endX - privateProperty.startX;
        var dy = privateProperty.endY - privateProperty.startY;
        return Math.sqrt(dx * dx + dy * dy);
    }

    QtObject {
        id: privateProperty
        property real startX: root.width * 0.25
        property real startY: root.height * 0.5
        property real endX: root.width * 0.75
        property real endY: root.height * 0.5
        property real dashOffset: 0

        NumberAnimation on dashOffset {
            from: 0
            to: -22
            duration: 600
            loops: Animation.Infinite
            running: startDrag.active || endDrag.active
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        z: 0
        enabled: false          // 不接收鼠标事件
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.strokeStyle = root.lineColor;
            ctx.lineWidth = root.lineWidth;
            ctx.lineCap = "butt";
            ctx.setLineDash([12, 4, 2, 4]);
            ctx.lineDashOffset = privateProperty.dashOffset;
            ctx.beginPath();
            ctx.moveTo(privateProperty.startX, privateProperty.startY);
            ctx.lineTo(privateProperty.endX, privateProperty.endY);
            ctx.stroke();
        }

        Connections {
            target: privateProperty
            function onStartXChanged() {
                canvas.requestPaint();
            }
            function onStartYChanged() {
                canvas.requestPaint();
            }
            function onEndXChanged() {
                canvas.requestPaint();
            }
            function onEndYChanged() {
                canvas.requestPaint();
            }
            function onDashOffsetChanged() {
                canvas.requestPaint();
            }
        }

        Connections {
            target: root
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
        }
    }

    Label {
        enabled: false
        width: implicitWidth * 1.2
        height: implicitHeight * 1.3
        x: Math.max(0, Math.min(root.width - width, (privateProperty.startX + privateProperty.endX) / 2 - width / 2))
        y: Math.max(0, Math.min(root.height - height, (privateProperty.startY + privateProperty.endY) / 2 - height / 2 - 18))
        z: 2
        text: root.distance.toFixed(1) + " " + root.unit
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

    Rectangle {
        z: 1
        width: root.pointRadius * 2
        height: root.pointRadius * 2
        radius: root.pointRadius
        color: root.pointColor
        border.color: Material.background
        border.width: 2
        x: privateProperty.startX - radius
        y: privateProperty.startY - radius

        DragHandler {
            id: startDrag
            target: null
            cursorShape: Qt.PointingHandCursor

            onActiveTranslationChanged: {
                if (!active) {
                    return;
                }
                var p = startDrag.centroid.position;
                var r = parent.mapToItem(root, p.x, p.y);
                privateProperty.startX = Math.max(0, Math.min(root.width, r.x));
                privateProperty.startY = Math.max(0, Math.min(root.height, r.y));
            }
        }
    }

    Rectangle {
        z: 1
        width: root.pointRadius * 2
        height: root.pointRadius * 2
        radius: root.pointRadius
        color: root.pointColor
        border.color: Material.background
        border.width: 2
        x: privateProperty.endX - radius
        y: privateProperty.endY - radius

        DragHandler {
            id: endDrag
            target: null
            cursorShape: Qt.PointingHandCursor

            onActiveTranslationChanged: {
                if (!active) {
                    return;
                }
                var p = endDrag.centroid.position;
                var r = parent.mapToItem(root, p.x, p.y);
                privateProperty.endX = Math.max(0, Math.min(root.width, r.x));
                privateProperty.endY = Math.max(0, Math.min(root.height, r.y));
            }
        }
    }
}

pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Material

Item {
    id: root

    width: parent ? parent.width : defaultSize.width
    height: parent ? parent.height : defaultSize.height
    clip: false

    // 基础属性
    property string unit: "px"
    property real ratio: 1.0
    property real sideWidth: 2
    property point centerPoint: Qt.point(width * 0.5, height * 0.5)
    property real centerRadius: 10
    property string text: "Rx " + unit
    property real angle: 0
    property real dashOffset: 0

    readonly property size defaultSize: Qt.size(300, 300)
    readonly property color sideColor: Qt.hsla(Math.random(), 0.7, 0.55, 1)
    readonly property color color: "transparent"
    readonly property real minRadius: 10
    readonly property real handleRadius: 7

    property int activeCount: 0
    readonly property bool interacting: activeCount > 0

    // 中心拖动热区半径
    readonly property real moveHotRadius: 20

    // Canvas 绘制
    Canvas {
        id: canvas

        anchors.fill: parent
        enabled: false

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()

        // 监听根组件属性变化
        Connections {
            target: root

            function onAngleChanged() {
                canvas.requestPaint();
            }

            function onWidthChanged() {
                canvas.requestPaint();
            }

            function onHeightChanged() {
                canvas.requestPaint();
            }

            function onSideColorChanged() {
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

        // 监听控制点位置变化
        Connections {
            target: leftPoint

            function onXChanged() {
                canvas.requestPaint();
            }

            function onYChanged() {
                canvas.requestPaint();
            }
        }

        Connections {
            target: rightPoint

            function onXChanged() {
                canvas.requestPaint();
            }

            function onYChanged() {
                canvas.requestPaint();
            }
        }

        Connections {
            target: topPoint

            function onXChanged() {
                canvas.requestPaint();
            }

            function onYChanged() {
                canvas.requestPaint();
            }
        }

        Connections {
            target: bottomPoint

            function onXChanged() {
                canvas.requestPaint();
            }

            function onYChanged() {
                canvas.requestPaint();
            }
        }

        onPaint: {
            if (width <= 0 || height <= 0) {
                return;
            }
            const ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.strokeStyle = root.sideColor;
            ctx.lineWidth = root.sideWidth;
            ctx.lineCap = "butt";
            ctx.setLineDash([12, 4, 2, 4]);
            ctx.lineDashOffset = root.dashOffset;
            // 获取四个控制点的圆心
            const leftX = leftPoint.x + leftPoint.width * 0.5;
            const leftY = leftPoint.y + leftPoint.height * 0.5;
            const rightX = rightPoint.x + rightPoint.width * 0.5;
            const rightY = rightPoint.y + rightPoint.height * 0.5;
            const topX = topPoint.x + topPoint.width * 0.5;
            const topY = topPoint.y + topPoint.height * 0.5;
            const bottomX = bottomPoint.x + bottomPoint.width * 0.5;
            const bottomY = bottomPoint.y + bottomPoint.height * 0.5;
            // 椭圆中心
            const cx = (leftX + rightX) * 0.5;
            const cy = (topY + bottomY) * 0.5;
            // 椭圆半轴
            const rx = Math.hypot(rightX - leftX, rightY - leftY) * 0.5;
            const ry = Math.hypot(bottomX - topX, bottomY - topY) * 0.5;
            if (rx <= 0 || ry <= 0) {
                return;
            }
            // 贝塞尔曲线圆弧系数
            const k = 0.5522847498;
            ctx.save();
            // 移动到椭圆中心
            ctx.translate(cx, cy);
            // 旋转椭圆
            ctx.rotate(root.angle * Math.PI / 180);
            // 四段贝塞尔曲线绘制椭圆
            ctx.beginPath();
            ctx.moveTo(rx, 0);
            // 右侧 -> 下侧
            ctx.bezierCurveTo(rx, k * ry, k * rx, ry, 0, ry);
            // 下侧 -> 左侧
            ctx.bezierCurveTo(-k * rx, ry, -rx, k * ry, -rx, 0);
            // 左侧 -> 上侧
            ctx.bezierCurveTo(-rx, -k * ry, -k * rx, -ry, 0, -ry);
            // 上侧 -> 右侧
            ctx.bezierCurveTo(k * rx, -ry, rx, -k * ry, rx, 0);
            ctx.closePath();
            ctx.stroke();
            ctx.restore();
        }
    }

    // 中心拖动热区
    Item {
        id: moveArea

        x: root.centerPoint.x - root.moveHotRadius
        y: root.centerPoint.y - root.moveHotRadius

        width: root.moveHotRadius * 2
        height: root.moveHotRadius * 2

        DragHandler {
            id: moveHandler

            target: null
            cursorShape: Qt.PointingHandCursor

            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchScreen

            minimumPointCount: 1
            maximumPointCount: 1

            property point startCenter: Qt.point(0, 0)
            property point pressCenter: Qt.point(0, 0)

            onActiveChanged: {
                if (active) {
                    moveHandler.startCenter = root.centerPoint;

                    const p = moveHandler.centroid.position;
                    const r = moveArea.mapToItem(root, p.x, p.y);

                    moveHandler.pressCenter = Qt.point(r.x, r.y);

                    root.activeCount++;
                } else {
                    root.activeCount = Math.max(0, root.activeCount - 1);
                }
            }

            onActiveTranslationChanged: {
                if (!active)
                    return;
                const p = moveHandler.centroid.position;
                const r = moveArea.mapToItem(root, p.x, p.y);

                root.centerPoint = Qt.point(Math.max(0, Math.min(root.width, moveHandler.startCenter.x + (r.x - moveHandler.pressCenter.x))), Math.max(0, Math.min(root.height, moveHandler.startCenter.y + (r.y - moveHandler.pressCenter.y))));
            }
        }
    }

    Point {
        id: topPoint
        radius: root.centerRadius
        width: radius * 2
        height: radius * 2
        color: root.sideColor
        x: root.width * 0.5 - width * 0.5
        y: root.height * 0.25 - height * 0.5
    }

    Point {
        id: bottomPoint
        radius: root.centerRadius
        width: radius * 2
        height: radius * 2
        color: root.sideColor
        x: root.width * 0.5 - width * 0.5
        y: root.height * 0.75 - height * 0.5
    }

    Point {
        id: leftPoint
        radius: root.centerRadius
        width: radius * 2
        height: radius * 2
        color: root.sideColor
        x: root.width * 0.25 - width * 0.5
        y: root.height * 0.5 - height * 0.5
    }

    Point {
        id: rightPoint
        radius: root.centerRadius
        width: radius * 2
        height: radius * 2
        color: root.sideColor
        x: root.width * 0.75 - width * 0.5
        y: root.height * 0.5 - height * 0.5
    }

    NumberAnimation on dashOffset {
        from: 0
        to: -22
        duration: 600
        loops: Animation.Infinite
        running: root.interacting
    }
}

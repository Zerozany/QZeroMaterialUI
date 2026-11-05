// pragma ComponentBehavior: Bound
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
    property real pointRadius: 10
    property string text: "Rx " + unit
    property point centerPoint: Qt.point((leftPoint.x + rightPoint.x) * 0.5, (topPoint.y + bottomPoint.y) * 0.5)
    property point topPoint: Qt.point(root.width * 0.50, root.height * 0.25)
    property point bottomPoint: Qt.point(root.width * 0.50, root.height * 0.75)
    property point leftPoint: Qt.point(root.width * 0.25, root.height * 0.50)
    property point rightPoint: Qt.point(root.width * 0.75, root.height * 0.50)
    property real angle: 0
    property real dashOffset: 0

    readonly property size defaultSize: Qt.size(300, 300)
    readonly property color sideColor: Qt.hsla(Math.random(), 0.7, 0.55, 1)
    readonly property color color: "transparent"
    readonly property real moveHotRadius: 20
    readonly property real besselK: 0.5522847498

    Canvas {
        id: canvas
        anchors.fill: parent
        enabled: false

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
            const leftX = root.leftPoint.x;
            const leftY = root.leftPoint.y;
            const rightX = root.rightPoint.x;
            const rightY = root.rightPoint.y;
            const topX = root.topPoint.x;
            const topY = root.topPoint.y;
            const bottomX = root.bottomPoint.x;
            const bottomY = root.bottomPoint.y;
            // 椭圆中心
            const cx = (leftX + rightX) * 0.5;
            const cy = (topY + bottomY) * 0.5;
            // 椭圆半轴
            const rx = Math.hypot(rightX - leftX, rightY - leftY) * 0.5;
            const ry = Math.hypot(bottomX - topX, bottomY - topY) * 0.5;
            if (rx <= 0 || ry <= 0) {
                return;
            }
            ctx.save();
            // 移动到椭圆中心
            ctx.translate(cx, cy);
            // 旋转椭圆
            ctx.rotate(root.angle * Math.PI / 180);
            // 四段贝塞尔曲线绘制椭圆
            ctx.beginPath();
            ctx.moveTo(rx, 0);
            // 右侧 -> 下侧
            ctx.bezierCurveTo(rx, root.besselK * ry, root.besselK * rx, ry, 0, ry);
            // 下侧 -> 左侧
            ctx.bezierCurveTo(-root.besselK * rx, ry, -rx, root.besselK * ry, -rx, 0);
            // 左侧 -> 上侧
            ctx.bezierCurveTo(-rx, -root.besselK * ry, -root.besselK * rx, -ry, 0, -ry);
            // 上侧 -> 右侧
            ctx.bezierCurveTo(root.besselK * rx, -ry, rx, -root.besselK * ry, rx, 0);
            ctx.closePath();
            ctx.stroke();
            ctx.restore();
        }

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
            function onDashOffsetChanged() {
                canvas.requestPaint();
            }
            function onCenterPointChanged() {
                canvas.requestPaint();
            }
            function onTopPointChanged() {
                canvas.requestPaint();
            }
            function onBottomPointChanged() {
                canvas.requestPaint();
            }
            function onLeftPointChanged() {
                canvas.requestPaint();
            }
            function onRightPointChanged() {
                canvas.requestPaint();
            }
        }
    }

    Point {
        id: centerPoint
        radius: root.pointRadius
        width: radius * 2
        height: radius * 2
        color: root.sideColor
        x: root.centerPoint.x
        y: root.centerPoint.y
    }

    // Item {
    //     anchors.fill: parent

    //     DragHandler {
    //         id: moveHandler
    //         target: null
    //         cursorShape: Qt.PointingHandCursor
    //         acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchScreen

    //         property point lastTranslation: Qt.point(0, 0)

    //         onActiveChanged: {
    //             if (!active) {
    //                 return;
    //             }

    //             lastTranslation = activeTranslation;
    //         }

    //         onActiveTranslationChanged: {
    //             if (!active) {
    //                 return;
    //             }

    //             // 必须以初始按下位置判断，而不是当前位置
    //             const startPos = centroid.pressPosition;

    //             if (Math.hypot(startPos.x - root.centerPoint.x, startPos.y - root.centerPoint.y) > root.moveHotRadius) {
    //                 return;
    //             }

    //             const dx = activeTranslation.x - lastTranslation.x;
    //             const dy = activeTranslation.y - lastTranslation.y;

    //             lastTranslation = activeTranslation;

    //             root.topPoint = Qt.point(root.topPoint.x + dx, root.topPoint.y + dy);
    //             root.bottomPoint = Qt.point(root.bottomPoint.x + dx, root.bottomPoint.y + dy);
    //             root.leftPoint = Qt.point(root.leftPoint.x + dx, root.leftPoint.y + dy);
    //             root.rightPoint = Qt.point(root.rightPoint.x + dx, root.rightPoint.y + dy);
    //         }
    //     }
    // }

    NumberAnimation on dashOffset {
        from: 0
        to: -22
        duration: 600
        loops: Animation.Infinite
        running: moveHandler.active
    }
}

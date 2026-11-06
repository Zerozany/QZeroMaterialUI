pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Material
import QtQuick.Shapes

Item {
    id: root
    width: parent ? parent.width : defaultSize.width
    height: parent ? parent.height : defaultSize.height
    clip: false

    property real ratio: 1.0
    property real angle: 0
    property real horizontalRadius: Math.min(width, height) * 0.3
    property real verticalRadius: Math.min(width, height) * 0.2
    property string unit: "px"
    property string text: "RX " + (horizontalRadius * ratio).toFixed(1) + " / RY " + (verticalRadius * ratio).toFixed(1) + " " + unit
    property alias centerPoint: centerPoint

    readonly property real pointRadius: 10
    readonly property real sideWidth: 2
    readonly property size defaultSize: Qt.size(300, 300)
    readonly property color sideColor: Qt.hsla(Math.random(), 0.7, 0.55, 1)
    readonly property color color: "transparent"
    readonly property int pointSize: 12

    readonly property real radian: angle * Math.PI / 180
    readonly property real boundRadiusWidth: Math.sqrt(Math.pow(horizontalRadius * Math.cos(radian), 2) + Math.pow(verticalRadius * Math.sin(radian), 2))
    readonly property real boundRadiusHeight: Math.sqrt(Math.pow(horizontalRadius * Math.sin(radian), 2) + Math.pow(verticalRadius * Math.cos(radian), 2))

    Shape {
        anchors.fill: parent
        transform: Rotation {
            origin.x: centerPoint.x
            origin.y: centerPoint.y
            angle: root.angle
        }

        ShapePath {
            strokeColor: root.sideColor
            strokeWidth: root.sideWidth
            fillColor: root.color
            strokeStyle: ShapePath.DashLine
            dashPattern: [12, 4, 2, 4]
            dashOffset: 0
            startX: centerPoint.x + root.horizontalRadius
            startY: centerPoint.y

            PathAngleArc {
                centerX: centerPoint.x
                centerY: centerPoint.y
                radiusX: root.horizontalRadius
                radiusY: root.verticalRadius
                startAngle: 0
                sweepAngle: 360
            }

            NumberAnimation on dashOffset {
                id: dashOffsetAnimation
                from: 0
                to: -22
                duration: 600
                loops: Animation.Infinite
                running: centerPoint.active || !!((repeater.itemAt(0) as Point)?.active || (repeater.itemAt(1) as Point)?.active || (repeater.itemAt(2) as Point)?.active || (repeater.itemAt(3) as Point)?.active)
            }
        }

        ShapePath {
            strokeColor: Qt.rgba(root.sideColor.r, root.sideColor.g, root.sideColor.b, 0.35)
            strokeWidth: root.sideWidth * 0.5
            fillColor: root.color
            strokeStyle: ShapePath.DashLine
            dashPattern: [4, 4]
            startX: centerPoint.x + root.horizontalRadius
            startY: centerPoint.y

            PathLine {
                x: centerPoint.x
                y: centerPoint.y
            }
            PathMove {
                x: centerPoint.x
                y: centerPoint.y - root.verticalRadius
            }
            PathLine {
                x: centerPoint.x
                y: centerPoint.y
            }
            PathMove {
                x: centerPoint.x - root.horizontalRadius
                y: centerPoint.y
            }
            PathLine {
                x: centerPoint.x
                y: centerPoint.y
            }
            PathMove {
                x: centerPoint.x
                y: centerPoint.y + root.verticalRadius
            }
            PathLine {
                x: centerPoint.x
                y: centerPoint.y
            }
        }
    }

    Repeater {
        id: repeater

        // 四个顶点相对于椭圆角度的偏移量
        model: [0, 90, 180, 270]

        delegate: Point {
            radius: root.pointRadius
            color: root.sideColor
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchScreen
            x: centerPoint.x + (modelData / 90 % 2 === 0 ? root.horizontalRadius : root.verticalRadius) * Math.cos((root.angle + modelData) * Math.PI / 180)
            y: centerPoint.y + (modelData / 90 % 2 === 0 ? root.horizontalRadius : root.verticalRadius) * Math.sin((root.angle + modelData) * Math.PI / 180)

            required property real modelData
            property point startPoint: Qt.point(0, 0)

            onActiveChanged: {
                if (!active) {
                    return;
                }
                startPoint = Qt.point(x, y);
            }

            onActiveTranslationChanged: {
                if (!active) {
                    return;
                }
                const dx = startPoint.x + activeTranslation.x - centerPoint.x;
                const dy = startPoint.y + activeTranslation.y - centerPoint.y;
                if (dx * dx + dy * dy < 1) {
                    return;
                }
                root.angle = ((Math.atan2(dy, dx) * 180 / Math.PI - modelData) % 360 + 360) % 360;
            }
        }
    }

    Point {
        id: centerPoint
        radius: root.pointRadius
        x: root.width * 0.5
        y: root.height * 0.5
        color: root.sideColor
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchScreen

        property point startPoint: Qt.point(0, 0)

        onActiveChanged: {
            if (!active) {
                return;
            }
            startPoint = Qt.point(x, y);
        }

        onActiveTranslationChanged: {
            if (!active) {
                return;
            }
            const minX = root.boundRadiusWidth + root.pointRadius;
            const maxX = root.width - root.boundRadiusWidth - root.pointRadius;
            const minY = root.boundRadiusHeight + root.pointRadius;
            const maxY = root.height - root.boundRadiusHeight - root.pointRadius;
            x = Math.max(minX, Math.min(maxX, startPoint.x + activeTranslation.x));
            y = Math.max(minY, Math.min(maxY, startPoint.y + activeTranslation.y));
        }
    }

    MultiPointTouchArea {
        anchors.fill: parent
        minimumTouchPoints: 2
        maximumTouchPoints: 2

        touchPoints: [
            TouchPoint {
                id: touch1
            },
            TouchPoint {
                id: touch2
            }
        ]

        // 初始双指局部距离（拆成标量，避免 Qt.point 构造与 .x/.y 取值）
        property real startDeltaX: 0
        property real startDeltaY: 0
        // 初始椭圆半径
        property real startHorizontalRadius: 0
        property real startVerticalRadius: 0
        // 旋转角三角函数（仅用于触摸点的局部坐标投影）
        readonly property real cosAngle: Math.cos(root.radian)
        readonly property real sinAngle: Math.sin(root.radian)

        // 计算指定方向的最大半径：
        // 复用 root.boundRadiusWidth / boundRadiusHeight（已含旋转投影），
        // 按 “可用空间 / 当前投影半轴” 的比例放大当前半径。
        function maxAxisRadius(horizontal) {
            const availableX = Math.min(centerPoint.x - root.pointRadius, root.width - centerPoint.x - root.pointRadius);
            const availableY = Math.min(centerPoint.y - root.pointRadius, root.height - centerPoint.y - root.pointRadius);
            const currentBound = horizontal ? root.boundRadiusWidth : root.boundRadiusHeight;
            const available = horizontal ? availableX : availableY;
            const currentRadius = horizontal ? root.horizontalRadius : root.verticalRadius;
            if (currentBound <= 0 || currentRadius <= 0) {
                return 0;
            }
            return Math.max(0, available * currentRadius / currentBound);
        }

        onGestureStarted: function (gesture) {
            if (gesture.touchPoints.length !== 2) {
                return;
            }
            // 转换为椭圆局部坐标
            const x1 = (touch1.x - centerPoint.x) * cosAngle + (touch1.y - centerPoint.y) * sinAngle;
            const y1 = -(touch1.x - centerPoint.x) * sinAngle + (touch1.y - centerPoint.y) * cosAngle;
            const x2 = (touch2.x - centerPoint.x) * cosAngle + (touch2.y - centerPoint.y) * sinAngle;
            const y2 = -(touch2.x - centerPoint.x) * sinAngle + (touch2.y - centerPoint.y) * cosAngle;
            // 判断两个触摸点是否在椭圆内部
            if (root.horizontalRadius <= 0 || root.verticalRadius <= 0) {
                return;
            }
            if (x1 * x1 / (root.horizontalRadius * root.horizontalRadius) + y1 * y1 / (root.verticalRadius * root.verticalRadius) > 1 || x2 * x2 / (root.horizontalRadius * root.horizontalRadius) + y2 * y2 / (root.verticalRadius * root.verticalRadius) > 1) {
                return;
            }
            gesture.grab();
            // 保存初始双指局部距离
            startDeltaX = Math.abs((touch1.x - touch2.x) * cosAngle + (touch1.y - touch2.y) * sinAngle);
            startDeltaY = Math.abs(-(touch1.x - touch2.x) * sinAngle + (touch1.y - touch2.y) * cosAngle);
            // 保存初始半径
            startHorizontalRadius = root.horizontalRadius;
            startVerticalRadius = root.verticalRadius;
        }

        onUpdated: {
            if ((startDeltaX <= 0 && startDeltaY <= 0) || touchPoints.length !== 2) {
                return;
            }
            // 当前双指局部距离
            const currentX = Math.abs((touch1.x - touch2.x) * cosAngle + (touch1.y - touch2.y) * sinAngle);
            const currentY = Math.abs(-(touch1.x - touch2.x) * sinAngle + (touch1.y - touch2.y) * cosAngle);
            // 根据初始距离锁定缩放方向
            const horizontal = startDeltaX >= startDeltaY;
            const startDistance = horizontal ? startDeltaX : startDeltaY;
            const currentDistance = horizontal ? currentX : currentY;
            const initialRadius = horizontal ? startHorizontalRadius : startVerticalRadius;
            if (startDistance <= 1) {
                return;
            }
            // 计算缩放半径
            const targetRadius = initialRadius * currentDistance / startDistance;
            const newRadius = Math.max(root.pointRadius, Math.min(targetRadius, maxAxisRadius(horizontal)));
            if (horizontal) {
                root.horizontalRadius = newRadius;
            } else {
                root.verticalRadius = newRadius;
            }
        }

        onReleased: {
            startDeltaX = 0;
            startDeltaY = 0;
        }

        onCanceled: {
            startDeltaX = 0;
            startDeltaY = 0;
        }
    }

    Label {
        enabled: false
        visible: false
        // visible: text.length > 0
        width: implicitWidth * 1.2
        height: implicitHeight * 1.3
        x: Math.max(0, Math.min(root.width - width, centerPoint.x - width / 2))
        y: Math.max(0, Math.min(root.height - height, centerPoint.y - root.verticalRadius - height - 4))
        text: root.text
        color: Material.foreground
        font.pixelSize: root.pointSize
        font.bold: true
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
        background: Rectangle {
            color: Material.background
            border.color: root.sideColor
            border.width: root.sideColor * 0.5
            radius: ElementStyle.elementRadius
        }
    }
}

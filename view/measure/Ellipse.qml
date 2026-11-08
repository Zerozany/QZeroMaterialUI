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
        model: [0, 90, 180, 270]

        delegate: Point {
            radius: root.pointRadius
            color: root.sideColor
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchScreen
            x: centerPoint.x + (horizontalHandle ? root.horizontalRadius : root.verticalRadius) * Math.cos((root.angle + modelData) * Math.PI / 180)
            y: centerPoint.y + (horizontalHandle ? root.horizontalRadius : root.verticalRadius) * Math.sin((root.angle + modelData) * Math.PI / 180)

            required property real modelData
            readonly property bool horizontalHandle: modelData / 90 % 2 === 0

            // 按下瞬间的固定基准
            property real pressRadius: 0
            property real pressAngle: 0
            property real pressDist: 0
            property real pressDirAngle: 0
            property real pressGlobalX: 0
            property real pressGlobalY: 0

            onActiveChanged: {
                if (!active) {
                    return;
                }
                const p = mapToItem(root, width / 2, height / 2);
                const dx = p.x - centerPoint.x;
                const dy = p.y - centerPoint.y;
                pressGlobalX = p.x;
                pressGlobalY = p.y;
                pressRadius = horizontalHandle ? root.horizontalRadius : root.verticalRadius;
                pressAngle = root.angle;
                pressDist = Math.hypot(dx, dy);
                pressDirAngle = Math.atan2(dy, dx) * 180 / Math.PI;
            }

            onActiveTranslationChanged: {
                if (!active) {
                    return;
                }
                const dx = pressGlobalX + activeTranslation.x - centerPoint.x;
                const dy = pressGlobalY + activeTranslation.y - centerPoint.y;
                const curDist = Math.hypot(dx, dy);
                const curDirAngle = Math.atan2(dy, dx) * 180 / Math.PI;
                const availX = Math.min(centerPoint.x - root.pointRadius, root.width - centerPoint.x - root.pointRadius);
                const availY = Math.min(centerPoint.y - root.pointRadius, root.height - centerPoint.y - root.pointRadius);
                // ---半径：先设目标值 ---
                const prevRadius = horizontalHandle ? root.horizontalRadius : root.verticalRadius;
                const targetRadius = Math.max(root.pointRadius, pressRadius + (curDist - pressDist));
                if (horizontalHandle) {
                    root.horizontalRadius = targetRadius;
                } else {
                    root.verticalRadius = targetRadius;
                }
                // 若新半径导致溢出，回退到上一合法值
                const overflow = root.boundRadiusWidth > availX || root.boundRadiusHeight > availY;
                if (overflow && horizontalHandle) {
                    root.horizontalRadius = prevRadius;
                }
                if (overflow && !horizontalHandle) {
                    root.verticalRadius = prevRadius;
                }
                // --- 旋转：手指相对中心的角度变化量 ---
                let deltaAngle = curDirAngle - pressDirAngle;
                deltaAngle = ((deltaAngle + 540) % 360) - 180;
                if (Math.abs(deltaAngle) < 0.5) {
                    return;
                }
                const newAngle = ((pressAngle + deltaAngle) % 360 + 360) % 360;
                const rad = newAngle * Math.PI / 180;
                const c = Math.cos(rad);
                const s = Math.sin(rad);
                const rx = root.horizontalRadius;
                const ry = root.verticalRadius;
                const trialW = Math.sqrt(rx * rx * c * c + ry * ry * s * s);
                const trialH = Math.sqrt(rx * rx * s * s + ry * ry * c * c);
                if (trialW > availX || trialH > availY) {
                    return;
                }
                root.angle = newAngle;
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

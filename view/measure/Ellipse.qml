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
    property real angle: 73
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
    readonly property point rightPoint: Qt.point(centerPoint.x + horizontalRadius * Math.cos(radian), centerPoint.y + horizontalRadius * Math.sin(radian))
    readonly property point bottomPoint: Qt.point(centerPoint.x - verticalRadius * Math.sin(radian), centerPoint.y + verticalRadius * Math.cos(radian))
    readonly property point leftPoint: Qt.point(centerPoint.x - horizontalRadius * Math.cos(radian), centerPoint.y - horizontalRadius * Math.sin(radian))
    readonly property point topPoint: Qt.point(centerPoint.x + verticalRadius * Math.sin(radian), centerPoint.y - verticalRadius * Math.cos(radian))
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
        model: [root.rightPoint, root.bottomPoint, root.leftPoint, root.topPoint]
        delegate: Point {
            radius: root.pointRadius
            color: root.sideColor
            x: modelData.x
            y: modelData.y

            required property point modelData

            onActiveChanged: {
                if (!active) {
                    return;
                }
            }

            onActiveTranslationChanged: {
                if (!active) {
                    return;
                }
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

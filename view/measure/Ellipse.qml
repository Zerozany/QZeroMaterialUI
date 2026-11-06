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

    property bool vertexDragActive: false
    readonly property real pointRadius: 10
    readonly property real sideWidth: 2
    readonly property size defaultSize: Qt.size(300, 300)
    readonly property color sideColor: Qt.hsla(Math.random(), 0.7, 0.55, 1)
    readonly property color color: "transparent"
    readonly property int pointSize: 12

    // 返回四个顶点旋转后的根坐标，顺序：右、上、左、下
    readonly property var vertexPositions: {
        var cos = Math.cos(angle * Math.PI / 180);
        var sin = Math.sin(angle * Math.PI / 180);
        var offsets = [Qt.point(horizontalRadius, 0), Qt.point(0, -verticalRadius), Qt.point(-horizontalRadius, 0), Qt.point(0, verticalRadius)];
        var result = [];
        for (var i = 0; i < 4; i++) {
            var dx = offsets[i].x;
            var dy = offsets[i].y;
            result.push(Qt.point(centerPoint.x + dx * cos - dy * sin, centerPoint.y + dx * sin + dy * cos));
        }
        return result;
    }

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
                from: 0
                to: -22
                duration: 600
                loops: Animation.Infinite
                running: centerPoint.active || root.vertexDragActive
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
        model: 4
        delegate: Point {
            id: vertexHandle
            radius: root.pointRadius
            color: root.sideColor
            x: root.vertexPositions[index].x
            y: root.vertexPositions[index].y

            required property int index

            property point lastRoot: Qt.point(0, 0)

            onActiveChanged: {
                root.vertexDragActive = active;
                if (!active) {
                    return;
                }
                var p = centroid.position;
                lastRoot = vertexHandle.mapToItem(root, p.x, p.y);
            }

            onActiveTranslationChanged: {
                if (!active) {
                    return;
                }
                var p = centroid.position;
                var curRoot = vertexHandle.mapToItem(root, p.x, p.y);

                // 本帧增量（根坐标）
                var dx = curRoot.x - lastRoot.x;
                var dy = curRoot.y - lastRoot.y;
                lastRoot.x = curRoot.x;
                lastRoot.y = curRoot.y;

                if (dx === 0 && dy === 0) {
                    return;
                }
                // 用“当前旋转角”把本帧增量转到当前局部坐标
                // 这样切向始终是此刻椭圆在该顶点的真实切向
                var rad = -root.angle * Math.PI / 180;
                var cos = Math.cos(rad);
                var sin = Math.sin(rad);
                var localDx = dx * cos - dy * sin;
                var localDy = dx * sin + dy * cos;

                var idx = vertexHandle.index;

                // 在未旋转姿态下的径向 / 切向单位向量：
                //   idx 0 右端点：径向 (1, 0)，切向 (0, 1)
                //   idx 1 上端点：径向 (0,-1)，切向 (1, 0)
                //   idx 2 左端点：径向 (-1,0)，切向 (0,-1)
                //   idx 3 下端点：径向 (0, 1)，切向 (-1,0)
                var radialDelta = 0;
                var tangentialDelta = 0;

                if (idx === 0) {
                    radialDelta = localDx;
                    tangentialDelta = localDy;
                } else if (idx === 1) {
                    radialDelta = -localDy;
                    tangentialDelta = localDx;
                } else if (idx === 2) {
                    radialDelta = -localDx;
                    tangentialDelta = -localDy;
                } else { // idx === 3
                    radialDelta = localDy;
                    tangentialDelta = -localDx;
                }

                // 横向 / 纵向各自的最大半径（背景为矩形，两方向空间不同）
                // 留出手柄半径，避免手柄贴边被裁
                var maxRX = Math.max(1, root.width / 2 - root.pointRadius);
                var maxRY = Math.max(1, root.height / 2 - root.pointRadius);

                // 1) 半径：只由径向增量决定，带径向死区，增量累加
                var newRadiusX = root.horizontalRadius;
                var newRadiusY = root.verticalRadius;

                if (Math.abs(radialDelta) > 0.5) {
                    if (idx === 0 || idx === 2)
                        newRadiusX = root.horizontalRadius + radialDelta;
                    else
                        newRadiusY = root.verticalRadius + radialDelta;
                }

                newRadiusX = Math.min(Math.max(10, newRadiusX), maxRX);
                newRadiusY = Math.min(Math.max(10, newRadiusY), maxRY);

                // 2) 旋转：只由切向增量决定，带切向死区，参考当前半径，增量累加
                var newRotation = root.angle;

                if (Math.abs(tangentialDelta) > 0.5) {
                    var refRadius = (idx === 0 || idx === 2) ? Math.max(1, root.horizontalRadius) : Math.max(1, root.verticalRadius);
                    var angleDelta = (tangentialDelta / refRadius) * (180 / Math.PI);
                    newRotation = root.angle + angleDelta;
                    if (newRotation >= 180)
                        newRotation -= 360;
                    else if (newRotation < -180)
                        newRotation += 360;
                }

                // 3) 一次性提交
                root.horizontalRadius = newRadiusX;
                root.verticalRadius = newRadiusY;
                root.angle = newRotation;
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
        property point rootPoint: Qt.point(0, 0)

        onActiveChanged: {
            if (!active) {
                return;
            }
            startPoint.x = centerPoint.x;
            startPoint.y = centerPoint.y;
            var p = centroid.position;
            rootPoint = mapToItem(root, p.x, p.y);
        }

        onActiveTranslationChanged: {
            if (!active) {
                return;
            }
            var p = centroid.position;
            var cur = mapToItem(root, p.x, p.y);
            var dx = cur.x - rootPoint.x;
            var dy = cur.y - rootPoint.y;

            // 旋转后椭圆外接盒的半宽/半高
            var rad = root.angle * Math.PI / 180;
            var cos = Math.cos(rad);
            var sin = Math.sin(rad);
            var halfW = Math.sqrt(Math.pow(root.horizontalRadius * cos, 2) + Math.pow(root.verticalRadius * sin, 2));
            var halfH = Math.sqrt(Math.pow(root.horizontalRadius * sin, 2) + Math.pow(root.verticalRadius * cos, 2));

            // 合法区间：外接盒贴边 + 手柄自身半径，保证手柄整体不越出背景
            // 极端情况下（外接盒 + 手柄 > 半宽）退化到容器中心
            var r = root.pointRadius;
            var minX = Math.min(halfW + r, root.width * 0.5);
            var maxX = Math.max(root.width - halfW - r, root.width * 0.5);
            var minY = Math.min(halfH + r, root.height * 0.5);
            var maxY = Math.max(root.height - halfH - r, root.height * 0.5);

            centerPoint.x = Math.max(minX, Math.min(maxX, startPoint.x + dx));
            centerPoint.y = Math.max(minY, Math.min(maxY, startPoint.y + dy));
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

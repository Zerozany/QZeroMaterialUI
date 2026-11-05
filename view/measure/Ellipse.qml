pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Material
import QtQuick.Shapes

Item {
    id: root
    width: parent ? parent.width : defaultSize.width
    height: parent ? parent.height : defaultSize.height
    clip: false

    property string unit: "px"
    property real ratio: 1.0

    property real radiusX: Math.min(width, height) * 0.3
    property real radiusY: Math.min(width, height) * 0.2
    property real rotationAngle: 0

    property bool vertexDragActive: false

    property string text: "RX " + (radiusX * ratio).toFixed(1) + " / RY " + (radiusY * ratio).toFixed(1) + " " + unit

    readonly property real pointRadius: 10
    readonly property real sideWidth: 2
    readonly property size defaultSize: Qt.size(300, 300)
    readonly property color sideColor: Qt.hsla(Math.random(), 0.7, 0.55, 1)

    // 径向/切向死区（像素），小于该值视为手抖，不响应
    readonly property real rotateDeadZone: 0.5
    readonly property real radiusDeadZone: 0.5

    readonly property color color: "transparent"
    readonly property int pointSize: 12

    // 轴对齐椭圆上的四个端点（未旋转），顺序：右、上、左、下
    function axisAlignedVertices() {
        return [Qt.point(centerPoint.x + radiusX, centerPoint.y), Qt.point(centerPoint.x, centerPoint.y - radiusY), Qt.point(centerPoint.x - radiusX, centerPoint.y), Qt.point(centerPoint.x, centerPoint.y + radiusY)];
    }

    // 对点应用绕中心的旋转
    function rotatePoint(pt) {
        var rad = rotationAngle * Math.PI / 180;
        var cos = Math.cos(rad);
        var sin = Math.sin(rad);
        var dx = pt.x - centerPoint.x;
        var dy = pt.y - centerPoint.y;
        return Qt.point(centerPoint.x + dx * cos - dy * sin, centerPoint.y + dx * sin + dy * cos);
    }

    // 四个顶点当前根坐标
    function vertexPositions() {
        var base = axisAlignedVertices();
        var result = [];
        for (var i = 0; i < base.length; i++)
            result.push(rotatePoint(base[i]));
        return result;
    }

    Shape {
        anchors.fill: parent
        transform: Rotation {
            origin.x: centerPoint.x
            origin.y: centerPoint.y
            angle: root.rotationAngle
        }

        ShapePath {
            strokeColor: root.sideColor
            strokeWidth: root.sideWidth
            fillColor: root.color
            strokeStyle: ShapePath.DashLine
            dashPattern: [12, 4, 2, 4]
            dashOffset: 0
            startX: centerPoint.x + root.radiusX
            startY: centerPoint.y

            PathAngleArc {
                centerX: centerPoint.x
                centerY: centerPoint.y
                radiusX: root.radiusX
                radiusY: root.radiusY
                startAngle: root.rotationAngle
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
    }

    Shape {
        anchors.fill: parent

        ShapePath {
            strokeColor: Qt.rgba(root.sideColor.r, root.sideColor.g, root.sideColor.b, 0.35)
            strokeWidth: root.sideWidth * 0.5
            fillColor: root.color
            strokeStyle: ShapePath.DashLine
            dashPattern: [4, 4]
            startX: centerPoint.x
            startY: centerPoint.y

            PathLine {
                x: root.vertexPositions()[0].x
                y: root.vertexPositions()[0].y
            }
            PathMove {
                x: centerPoint.x
                y: centerPoint.y
            }
            PathLine {
                x: root.vertexPositions()[1].x
                y: root.vertexPositions()[1].y
            }
            PathMove {
                x: centerPoint.x
                y: centerPoint.y
            }
            PathLine {
                x: root.vertexPositions()[2].x
                y: root.vertexPositions()[2].y
            }
            PathMove {
                x: centerPoint.x
                y: centerPoint.y
            }
            PathLine {
                x: root.vertexPositions()[3].x
                y: root.vertexPositions()[3].y
            }
        }
    }

    Repeater {
        model: 4
        delegate: Point {
            id: vertexHandle
            radius: root.pointRadius
            color: root.sideColor

            required property int index

            function updatePosition() {
                var verts = root.vertexPositions();
                var p = verts[index];
                x = p.x;
                y = p.y;
            }

            Component.onCompleted: updatePosition()

            Connections {
                target: centerPoint
                function onXChanged() {
                    vertexHandle.updatePosition();
                }
                function onYChanged() {
                    vertexHandle.updatePosition();
                }
            }

            Connections {
                target: root

                function onRadiusXChanged() {
                    vertexHandle.updatePosition();
                }
                function onRadiusYChanged() {
                    vertexHandle.updatePosition();
                }
                function onRotationAngleChanged() {
                    vertexHandle.updatePosition();
                }
                function onWidthChanged() {
                    vertexHandle.updatePosition();
                }
                function onHeightChanged() {
                    vertexHandle.updatePosition();
                }
            }

            property real lastRootX
            property real lastRootY
            property bool hasLast

            onActiveChanged: {
                root.vertexDragActive = active;
                if (!active) {
                    hasLast = false;
                    return;
                }
                var p = centroid.position;
                var curRoot = vertexHandle.mapToItem(root, p.x, p.y);
                lastRootX = curRoot.x;
                lastRootY = curRoot.y;
                hasLast = true;
            }

            onActiveTranslationChanged: {
                if (!active || !hasLast)
                    return;

                var p = centroid.position;
                var curRoot = vertexHandle.mapToItem(root, p.x, p.y);

                // 本帧增量（根坐标）
                var dx = curRoot.x - lastRootX;
                var dy = curRoot.y - lastRootY;
                lastRootX = curRoot.x;
                lastRootY = curRoot.y;

                if (dx === 0 && dy === 0)
                    return;

                // 用“当前旋转角”把本帧增量转到当前局部坐标
                // 这样切向始终是此刻椭圆在该顶点的真实切向
                var rad = -root.rotationAngle * Math.PI / 180;
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

                var maxR = Math.min(root.width, root.height) / 2;

                // 1) 半径：只由径向增量决定，带径向死区，增量累加
                var newRadiusX = root.radiusX;
                var newRadiusY = root.radiusY;

                if (Math.abs(radialDelta) > root.radiusDeadZone) {
                    if (idx === 0 || idx === 2)
                        newRadiusX = root.radiusX + radialDelta;
                    else
                        newRadiusY = root.radiusY + radialDelta;
                }

                newRadiusX = Math.min(Math.max(10, newRadiusX), maxR);
                newRadiusY = Math.min(Math.max(10, newRadiusY), maxR);

                // 2) 旋转：只由切向增量决定，带切向死区，参考当前半径，增量累加
                var newRotation = root.rotationAngle;

                if (Math.abs(tangentialDelta) > root.rotateDeadZone) {
                    var refRadius = (idx === 0 || idx === 2) ? Math.max(1, root.radiusX) : Math.max(1, root.radiusY);
                    var angleDelta = (tangentialDelta / refRadius) * (180 / Math.PI);
                    newRotation = root.rotationAngle + angleDelta;
                    if (newRotation >= 180)
                        newRotation -= 360;
                    else if (newRotation < -180)
                        newRotation += 360;
                }

                // 3) 一次性提交
                root.radiusX = newRadiusX;
                root.radiusY = newRadiusY;
                root.rotationAngle = newRotation;
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

        property real startCenterX
        property real startCenterY
        property point pressRoot

        onActiveChanged: {
            if (!active) {
                return;
            }
            startCenterX = centerPoint.x;
            startCenterY = centerPoint.y;
            var p = centerPoint.centroid.position;
            pressRoot = mapToItem(root, p.x, p.y);
        }

        onActiveTranslationChanged: {
            if (!active) {
                return;
            }
            var p = centerPoint.centroid.position;
            var curRoot = mapToItem(root, p.x, p.y);
            var dx = curRoot.x - pressRoot.x;
            var dy = curRoot.y - pressRoot.y;

            // 计算旋转后椭圆外接盒的半宽/半高
            var rad = root.rotationAngle * Math.PI / 180;
            var cos = Math.cos(rad);
            var sin = Math.sin(rad);
            var halfW = Math.sqrt(Math.pow(root.radiusX * cos, 2) + Math.pow(root.radiusY * sin, 2));
            var halfH = Math.sqrt(Math.pow(root.radiusX * sin, 2) + Math.pow(root.radiusY * cos, 2));

            var minX = halfW;
            var maxX = root.width - halfW;
            var minY = halfH;
            var maxY = root.height - halfH;

            // 防止半径过大导致区间反转
            if (minX > maxX) {
                minX = root.width / 2;
                maxX = root.width / 2;
            }
            if (minY > maxY) {
                minY = root.height / 2;
                maxY = root.height / 2;
            }

            centerPoint.x = Math.max(minX, Math.min(maxX, startCenterX + dx));
            centerPoint.y = Math.max(minY, Math.min(maxY, startCenterY + dy));
        }
    }

    Label {
        enabled: false
        visible: text.length > 0
        width: implicitWidth * 1.2
        height: implicitHeight * 1.3
        x: Math.max(0, Math.min(root.width - width, centerPoint.x - width / 2))
        y: Math.max(0, Math.min(root.height - height, centerPoint.y - root.radiusY - height - 4))
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

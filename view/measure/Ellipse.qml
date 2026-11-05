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

    property real centerX: width * 0.5
    property real centerY: height * 0.5

    property real radiusX: Math.min(width, height) * 0.3
    property real radiusY: Math.min(width, height) * 0.2
    property real rotationAngle: 0

    property real dashOffset: 0
    property bool vertexDragActive: false

    property string text: "RX " + (radiusX * ratio).toFixed(1) + " / RY " + (radiusY * ratio).toFixed(1) + " " + unit

    readonly property real pointRadius: 10
    readonly property real sideWidth: 2
    readonly property size defaultSize: Qt.size(300, 300)
    readonly property color sideColor: Qt.hsla(Math.random(), 0.7, 0.55, 1)

    // 切向旋转死区（像素），小于该值不旋转，避免手抖
    readonly property real rotateDeadZone: 6

    // 轴对齐椭圆上的四个端点（未旋转），顺序：右、上、左、下
    function axisAlignedVertices() {
        return [Qt.point(centerX + radiusX, centerY), Qt.point(centerX, centerY - radiusY), Qt.point(centerX - radiusX, centerY), Qt.point(centerX, centerY + radiusY)];
    }

    // 对点应用绕中心的旋转
    function rotatePoint(pt) {
        var rad = rotationAngle * Math.PI / 180;
        var cos = Math.cos(rad);
        var sin = Math.sin(rad);
        var dx = pt.x - centerX;
        var dy = pt.y - centerY;
        return Qt.point(centerX + dx * cos - dy * sin, centerY + dx * sin + dy * cos);
    }

    // 四个顶点当前根坐标
    function vertexPositions() {
        var base = axisAlignedVertices();
        var result = [];
        for (var i = 0; i < base.length; i++)
            result.push(rotatePoint(base[i]));
        return result;
    }

    // 椭圆（虚线 + 流动动画），用 Rotation 变换真正旋转整个椭圆
    Shape {
        anchors.fill: parent
        transform: Rotation {
            origin.x: root.centerX
            origin.y: root.centerY
            angle: root.rotationAngle
        }
        ShapePath {
            strokeColor: root.sideColor
            strokeWidth: root.sideWidth
            fillColor: "transparent"
            strokeStyle: ShapePath.DashLine
            dashPattern: [12, 4, 2, 4]
            dashOffset: root.dashOffset
            startX: root.centerX + root.radiusX
            startY: root.centerY

            PathAngleArc {
                centerX: root.centerX
                centerY: root.centerY
                radiusX: root.radiusX
                radiusY: root.radiusY
                startAngle: 0
                sweepAngle: 360
            }
        }
    }

    // 辅助连线（中心到四顶点）
    Shape {
        anchors.fill: parent
        ShapePath {
            strokeColor: Qt.rgba(root.sideColor.r, root.sideColor.g, root.sideColor.b, 0.35)
            strokeWidth: 1
            fillColor: "transparent"
            strokeStyle: ShapePath.DashLine
            dashPattern: [4, 4]
            startX: root.centerX
            startY: root.centerY
            PathLine {
                x: root.vertexPositions()[0].x
                y: root.vertexPositions()[0].y
            }
            PathMove {
                x: root.centerX
                y: root.centerY
            }
            PathLine {
                x: root.vertexPositions()[1].x
                y: root.vertexPositions()[1].y
            }
            PathMove {
                x: root.centerX
                y: root.centerY
            }
            PathLine {
                x: root.vertexPositions()[2].x
                y: root.vertexPositions()[2].y
            }
            PathMove {
                x: root.centerX
                y: root.centerY
            }
            PathLine {
                x: root.vertexPositions()[3].x
                y: root.vertexPositions()[3].y
            }
        }
    }

    // 四个顶点手柄
    Repeater {
        id: vertexRepeater
        model: 4
        delegate: Rectangle {
            id: vertexHandle
            width: root.pointRadius * 2
            height: root.pointRadius * 2
            radius: root.pointRadius
            color: root.sideColor
            border.color: Material.background
            border.width: 1

            required property int index

            function updatePosition() {
                var verts = root.vertexPositions();
                var p = verts[index];
                x = p.x - width / 2;
                y = p.y - height / 2;
            }

            Component.onCompleted: updatePosition()

            Connections {
                target: root
                function onCenterXChanged() {
                    vertexHandle.updatePosition();
                }
                function onCenterYChanged() {
                    vertexHandle.updatePosition();
                }
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

            DragHandler {
                id: vertexDrag
                target: null
                cursorShape: Qt.SizeAllCursor
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchScreen

                property real startRadiusX
                property real startRadiusY
                property real startRotation
                property point pressRoot

                onActiveChanged: {
                    root.vertexDragActive = active;
                    if (!active)
                        return;
                    startRadiusX = root.radiusX;
                    startRadiusY = root.radiusY;
                    startRotation = root.rotationAngle;
                    var p = vertexDrag.centroid.position;
                    pressRoot = vertexHandle.mapToItem(root, p.x, p.y);
                }

                onActiveTranslationChanged: {
                    if (!active)
                        return;

                    var p = vertexDrag.centroid.position;
                    var curRoot = vertexHandle.mapToItem(root, p.x, p.y);
                    var dx = curRoot.x - pressRoot.x;
                    var dy = curRoot.y - pressRoot.y;

                    // 把位移转到“起始旋转角”的局部坐标系
                    var rad = -startRotation * Math.PI / 180;
                    var cos = Math.cos(rad);
                    var sin = Math.sin(rad);
                    var localDx = dx * cos - dy * sin;
                    var localDy = dx * sin + dy * cos;

                    var idx = vertexHandle.index;

                    // 1) 先算新的半径（基于起始半径 + 径向位移）
                    var newRadiusX = startRadiusX;
                    var newRadiusY = startRadiusY;

                    if (idx === 0) {
                        newRadiusX = startRadiusX + localDx;
                    } else if (idx === 2) {
                        newRadiusX = startRadiusX - localDx;
                    } else if (idx === 1) {
                        newRadiusY = startRadiusY - localDy;
                    } else if (idx === 3) {
                        newRadiusY = startRadiusY + localDy;
                    }

                    var maxR = Math.min(root.width, root.height) / 2;
                    newRadiusX = Math.min(Math.max(10, newRadiusX), maxR);
                    newRadiusY = Math.min(Math.max(10, newRadiusY), maxR);

                    // 2) 再算旋转角（基于起始旋转角 + 切向位移 / 新半径）
                    var tangential = 0;
                    var refRadius = 1;

                    if (idx === 0) {
                        tangential = localDy;
                        refRadius = Math.max(1, newRadiusX);
                    } else if (idx === 2) {
                        tangential = -localDy;
                        refRadius = Math.max(1, newRadiusX);
                    } else if (idx === 1) {
                        tangential = localDx;
                        refRadius = Math.max(1, newRadiusY);
                    } else { // idx === 3
                        tangential = -localDx;
                        refRadius = Math.max(1, newRadiusY);
                    }

                    var newRotation = startRotation;

                    if (Math.abs(tangential) >= root.rotateDeadZone) {
                        var angleDelta = (tangential / refRadius) * (180 / Math.PI);
                        newRotation = startRotation + angleDelta;
                        if (newRotation >= 180)
                            newRotation -= 360;
                        else if (newRotation < -180)
                            newRotation += 360;
                    }

                    // 3) 一次性提交，顶点位置完全由椭圆参数推导，不会脱离
                    root.radiusX = newRadiusX;
                    root.radiusY = newRadiusY;
                    root.rotationAngle = newRotation;
                }
            }
        }
    }

    // 圆心手柄
    Rectangle {
        id: centerHandle
        width: root.pointRadius * 2
        height: root.pointRadius * 2
        radius: root.pointRadius
        color: root.sideColor
        border.color: Material.background
        border.width: 1
        x: root.centerX - width / 2
        y: root.centerY - height / 2

        DragHandler {
            id: centerDrag
            target: null
            cursorShape: Qt.PointingHandCursor
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchScreen

            property real startCenterX
            property real startCenterY
            property point pressRoot

            onActiveChanged: {
                if (!active)
                    return;
                startCenterX = root.centerX;
                startCenterY = root.centerY;
                var p = centerDrag.centroid.position;
                pressRoot = centerHandle.mapToItem(root, p.x, p.y);
            }

            onActiveTranslationChanged: {
                if (!active)
                    return;
                var p = centerDrag.centroid.position;
                var curRoot = centerHandle.mapToItem(root, p.x, p.y);
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

                root.centerX = Math.max(minX, Math.min(maxX, startCenterX + dx));
                root.centerY = Math.max(minY, Math.min(maxY, startCenterY + dy));
            }
        }
    }

    Label {
        enabled: false
        visible: text.length > 0
        width: implicitWidth * 1.2
        height: implicitHeight * 1.3
        x: Math.max(0, Math.min(root.width - width, root.centerX - width / 2))
        y: Math.max(0, Math.min(root.height - height, root.centerY - root.radiusY - height - 4))
        text: root.text
        color: Material.foreground
        font.pixelSize: 12
        font.bold: true
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
        background: Rectangle {
            color: Material.background
            border.color: root.sideColor
            border.width: root.sideWidth * 0.5
            radius: 4
        }
    }

    NumberAnimation on dashOffset {
        from: 0
        to: -22
        duration: 600
        loops: Animation.Infinite
        running: centerDrag.active || root.vertexDragActive
    }
}

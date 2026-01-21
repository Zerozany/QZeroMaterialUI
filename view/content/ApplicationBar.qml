import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    radius: root.elementRadius
    color: root.elementColor
    parent: Overlay.overlay

    property int edge: -1
    property Component contentItem: null

    readonly property int topEdge: 0
    readonly property int bottomEdge: 1
    readonly property int leftEdge: 2
    readonly property int rightEdge: 3
    readonly property string elementColor: ThemeManager.currentTheme["ElementColor"]
    readonly property int elementRadius: ElementStyle.elementRadius
    readonly property int elementMargins: ElementStyle.elementMargins
    readonly property bool landScape: parent.width > parent.height

    Loader {
        anchors.fill: parent
        sourceComponent: root.contentItem
    }

    onEdgeChanged: {
        if (root.edge === root.topEdge || root.edge === root.bottomEdge) {
            if (landScape) {
                root.height = parent.height * 0.08;
            } else {
                root.height = parent.height * 0.05;
            }
            root.width = parent.width * 0.33;
        }
        if (root.edge === root.leftEdge || root.edge === root.rightEdge) {
            if (landScape) {
                root.width = parent.width * 0.05;
            } else {
                root.width = parent.width * 0.08;
            }
            root.height = parent.height * 0.33;
        }
        if (root.edge === root.topEdge || root.edge === root.bottomEdge) {
            root.x = (parent.width - root.width) / 2;
        }
        if (root.edge === root.leftEdge || root.edge === root.rightEdge) {
            root.y = (parent.height - root.height) / 2;
        }
    }

    SequentialAnimation {
        running: root.edge === root.leftEdge || root.edge === root.rightEdge

        NumberAnimation {
            target: root
            property: "x"
            duration: 150
            from: {
                if (root.edge === root.leftEdge) {
                    return -root.width;
                }
                if (root.edge === root.rightEdge) {
                    return root.Window.window.contentItem.width;
                } else {
                    return root.x;
                }
            }
            to: {
                if (root.edge === root.leftEdge) {
                    return root.elementMargins * 3;
                }
                if (root.edge === root.rightEdge) {
                    return root.Window.window.contentItem.width - root.width - root.elementMargins * 3;
                } else {
                    return root.x;
                }
            }
        }

        NumberAnimation {
            target: root
            property: "x"
            duration: 200
            to: {
                if (root.edge === root.leftEdge) {
                    return root.elementMargins;
                } else if (root.edge === root.rightEdge) {
                    return root.Window.window.contentItem.width - root.width - root.elementMargins;
                } else {
                    return root.x;
                }
            }
        }
    }

    SequentialAnimation {
        running: root.edge === root.topEdge || root.edge === root.bottomEdge

        NumberAnimation {
            target: root
            property: "y"
            duration: 150
            from: {
                if (root.edge === root.topEdge) {
                    return -root.height;
                }
                if (root.edge === root.bottomEdge) {
                    return root.Window.window.contentItem.height;
                } else {
                    return root.y;
                }
            }
            to: {
                if (root.edge === root.topEdge) {
                    return root.elementMargins * 3;
                }
                if (root.edge === root.bottomEdge) {
                    return root.Window.window.contentItem.height - root.height - root.elementMargins * 3;
                } else {
                    return root.y;
                }
            }
        }

        NumberAnimation {
            target: root
            property: "y"
            duration: 300
            to: {
                if (root.edge === root.topEdge) {
                    return root.elementMargins;
                } else if (root.edge === root.bottomEdge) {
                    return root.Window.window.contentItem.height - root.height - root.elementMargins;
                } else {
                    return root.y;
                }
            }
        }
    }
}

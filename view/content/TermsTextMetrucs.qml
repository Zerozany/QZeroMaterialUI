import QtQuick

Item {
    id: root
    required property string text
    required property font font
    readonly property real textWidth: textMetrics.width
    readonly property real textHeight: textMetrics.height

    TextMetrics {
        id: textMetrics
        text: root.text
        font: root.font
    }
}

pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: root
    parent: Overlay.overlay
    anchors.centerIn: parent
    width: root.selfWidth
    height: root.selfHeight
    background: Rectangle {
        color: root.elementColor
        radius: root.elementRadius
    }

    property string date: ""
    readonly property int selfWidth: ContentConf.landScape ? parent.Window.window.contentItem.width * 0.6 : parent.Window.window.contentItem.width * 0.7
    readonly property int selfHeight: ContentConf.landScape ? parent.Window.window.contentItem.height * 0.6 : parent.Window.window.contentItem.height * 0.4
    readonly property int elementRadius: ElementStyle.elementRadius * 20
    readonly property string elementColor: ThemeManager.currentTheme["ElementColor"]
    readonly property int visibleItemCount: 7
    readonly property int flickDeceleration: 1000
    readonly property int tumblerHeight: root.height * 0.7
    readonly property int initYear: 1960
    readonly property string year: yearTumbler.currentIndex + root.initYear
    readonly property string month: monthTumbler.currentIndex + 1 < 10 ? "0" + (monthTumbler.currentIndex + 1) : monthTumbler.currentIndex + 1
    readonly property string day: dayTumbler.currentIndex + 1 < 10 ? "0" + (dayTumbler.currentIndex + 1) : dayTumbler.currentIndex + 1

    onDateChanged: {
        if (!date) {
            return;
        }
        var ymdArr = date.split("-");
        Qt.callLater(function () {
            yearTumbler.currentIndex = Math.max(0, Number(ymdArr[0]) - root.initYear);
            monthTumbler.currentIndex = Math.max(0, Number(ymdArr[1]) - 1);
            dayTumbler.currentIndex = Math.max(0, Math.min(Number(ymdArr[2]), new Date(Number(ymdArr[0]), Number(ymdArr[1]), 0).getDate()) - 1);
        });
    }

    onClosed: {
        root.date = year + "-" + month + "-" + day;
    }

    RowLayout {
        anchors.fill: parent

        Tumbler {
            id: yearTumbler
            visibleItemCount: root.visibleItemCount
            flickDeceleration: root.flickDeceleration
            wrap: true
            Layout.preferredHeight: root.tumblerHeight
            Layout.alignment: Qt.AlignCenter

            model: {
                var arr = [];
                for (var _year = root.initYear; _year <= new Date().getFullYear(); _year++) {
                    arr.push(_year);
                }
                return arr;
            }

            delegate: Text {
                required property var modelData
                readonly property bool isCurrent: Number(root.year) === modelData
                text: modelData
                font.pixelSize: isCurrent ? 25 : 22
                font.bold: isCurrent
                opacity: isCurrent ? 1.0 : 0.5
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Text {
            text: qsTr("年")
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignCenter
        }

        Tumbler {
            id: monthTumbler
            visibleItemCount: root.visibleItemCount
            flickDeceleration: root.flickDeceleration
            wrap: true
            Layout.preferredHeight: root.tumblerHeight
            Layout.alignment: Qt.AlignCenter

            model: {
                var arr = [];
                for (var _month = 1; _month <= 12; _month++) {
                    arr.push(_month);
                }
                return arr;
            }

            delegate: Text {
                required property var modelData
                readonly property bool isCurrent: Number(root.month) === modelData
                text: modelData
                font.pixelSize: isCurrent ? 25 : 22
                font.bold: isCurrent
                opacity: isCurrent ? 1.0 : 0.5
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Text {
            text: qsTr("月")
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignCenter
        }

        Tumbler {
            id: dayTumbler
            visibleItemCount: root.visibleItemCount
            flickDeceleration: root.flickDeceleration
            wrap: true
            Layout.preferredHeight: root.tumblerHeight
            Layout.alignment: Qt.AlignCenter

            model: {
                var arr = [];
                for (var _day = 1; _day <= new Date(root.year, root.month, 0).getDate(); _day++) {
                    arr.push(_day);
                }
                return arr;
            }

            delegate: Text {
                required property var modelData
                readonly property bool isCurrent: Number(root.day) === modelData
                text: modelData
                font.pixelSize: isCurrent ? 25 : 22
                font.bold: isCurrent
                opacity: isCurrent ? 1.0 : 0.5
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Text {
            text: qsTr("日")
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignCenter
        }
    }
}

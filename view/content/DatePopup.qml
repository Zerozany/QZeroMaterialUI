pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: root
    x: root.selfX
    y: root.selfY
    width: root.selfWidth
    height: root.selfHeight
    background: Rectangle {
        color: root.elementColor
        radius: root.elementRadius
    }

    property string date: ""
    readonly property int selfX: (ComponentMethod.findTopLevelWindow(parent).width - root.width) * 0.5
    readonly property int selfY: (ComponentMethod.findTopLevelWindow(parent).height - root.height) * 0.5
    readonly property int selfWidth: ComponentConf.landScape ? ComponentMethod.findTopLevelWindow(parent).width * 0.6 : ComponentMethod.findTopLevelWindow(parent).width * 0.7
    readonly property int selfHeight: ComponentConf.landScape ? ComponentMethod.findTopLevelWindow(parent).height * 0.6 : ComponentMethod.findTopLevelWindow(parent).height * 0.4
    readonly property int elementRadius: ElementStyle.elementRadius * 20
    readonly property string elementColor: ThemeManager.currentTheme["elementColor"]
    readonly property int visibleItemCount: 7
    readonly property int flickDeceleration: 1000
    readonly property int tumblerHeight: root.height * 0.7
    readonly property int initYear: 1960
    readonly property int year: yearTumbler.currentIndex + root.initYear
    readonly property int month: monthTumbler.currentIndex + 1
    readonly property int day: dayTumbler.currentIndex + 1

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
        console.log(date);
    }

    onClosed: {
        if (month < 10 && day < 10) {
            root.date = year + "-0" + month + "-0" + day;
        } else if (month < 10) {
            root.date = year + "-0" + month + "-" + day;
        } else if (day < 10) {
            root.date = year + "-" + month + "-0" + day;
        } else {
            root.date = year + "-" + month + "-" + day;
        }
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
                readonly property bool isCurrent: root.year === modelData
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
                readonly property bool isCurrent: root.month === modelData
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
                readonly property bool isCurrent: root.day === modelData
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

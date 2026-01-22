pragma Singleton
import QtQuick

QtObject {

    // 全局提示气泡
    function showPromptBanner(_parentItem: var, _text: var, _interval: int): var {
        var obj = Qt.createComponent("qrc:/qt/qml/QZeroZanyUI/view/content/PromptBanner.qml");
        if (obj.status === Component.Ready) {
            obj.createObject(_parentItem, {
                text: _text || "",
                interval: _interval || 2000
            });
        } else if (obj.status === Component.Error) {
            console.error("Error loading PromptBanner.qml");
        }
    }
}

pragma Singleton
import QtQuick
import QtQuick.Controls

QtObject {
    signal stackPop
    signal stackPush(_item: Item, _qmlName: string)
    signal stackReplace(_item: Item, _qmlName: string)

    onStackPush: function (_item: Item, _qmlName: string) {
        _item.StackView.view.push(_qmlName);
    }

    onStackReplace: function (_item: Item, _qmlName: string) {
        _item.StackView.view.replace(_qmlName);
    }
}

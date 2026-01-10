import QtQuick
import QtQuick.Controls.Material

CheckBox {
    id: root
    Material.accent: root.color

    property string color: ThemeManager.currentTheme["elementColor"]
}

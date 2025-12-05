_Pragma("once");
#include <QVariantMap>

namespace Themes
{
    inline QVariantMap lightTheme{
        {"backgroundColor", "#f0efee"},
        {"textColor", "#0e0d0d"},
        {"textColorPressed", "#cdcdcd"},
        {"buttonColor", "#FFFFFF"},
        {"elementColor", "#FFFFFF"},
        {"borderColor", "#cdcdcd"},
        {"probeDeviceColor", "#66e1e1"},
        {"labelColor", "transparent"},
    };

    inline QVariantMap styleSize{
        {"elementMargins", 5},
        {"elementRadius", 5},
        {"elementSpacing", 5},
    };

}  // namespace Themes

find_package(Qt6 REQUIRED
    COMPONENTS
    Quick
    Qml
    Core
    QuickControls2
    Gui
)

qt_policy(SET QTP0005 NEW)
qt_policy(SET QTP0004 NEW)
qt_policy(SET QTP0003 NEW)
qt_policy(SET QTP0002 NEW)
qt_policy(SET QTP0001 NEW)

qt_standard_project_setup(
    REQUIRES 6.8
)

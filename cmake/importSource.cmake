file(GLOB SRCFILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    "${CMAKE_CURRENT_SOURCE_DIR}/src/**/*.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/**/*.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/**/*.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/**/**/*.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/**/**/*.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/**/**/*.cpp"
)

file(GLOB RESOURCESLIST RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    "${CMAKE_CURRENT_SOURCE_DIR}/view/resource/*.png"
    "${CMAKE_CURRENT_SOURCE_DIR}/view/resource/**/*.png"
)

file(GLOB QMLFILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    "${CMAKE_CURRENT_SOURCE_DIR}/view/**/*.qml"
    "${CMAKE_CURRENT_SOURCE_DIR}/view/**/**/*.qml"
)

file(GLOB QMLSINGLETONS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    "${CMAKE_CURRENT_SOURCE_DIR}/view/global/*.qml"
)

file(GLOB INCLUDEDIR
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*/"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/**/*/"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/**/**/*"
)

set_source_files_properties(
    ${QMLSINGLETONS}
    PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

target_sources(${PROJECT_NAME}
    PRIVATE
    ${SRCFILES}
)

qt_target_qml_sources(
    ${PROJECT_NAME}
    QML_FILES ${QMLFILES}
    RESOURCES ${RESOURCESLIST}
)

target_include_directories(${PROJECT_NAME}
    PUBLIC
    ${INCLUDEDIR}
)

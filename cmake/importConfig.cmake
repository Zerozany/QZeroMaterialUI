target_compile_features(${PROJECT_NAME}
    PRIVATE
    cxx_std_23
)

target_compile_definitions(${PROJECT_NAME}
    PRIVATE
    QZeroZanyUI
)

set(QT_QML_GENERATE_QMLLS_INI ON)

set_target_properties(${PROJECT_NAME} PROPERTIES
    QT_QML_COMPILE_SOURCES ON # 强制所有 QML 文件都被编译为 C++
    QT_QML_SOURCE_PROTECTION ON # 开启源码保护
    QT_QMLCACHEGEN_ARGUMENTS "--direct-calls" # "--direct-calls" "--verbose"
)

if(MSVC)
    target_compile_options(${PROJECT_NAME}
        PRIVATE
        "$<$<CXX_COMPILER_ID:MSVC>:/Z7>"
    )

    target_compile_options(${PROJECT_NAME}
        PRIVATE
        "/utf-8"
        "/FS"
    )
endif()

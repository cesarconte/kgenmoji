add_library(kgenmoji_core STATIC
    genmojicontroller.cpp
    genmojicontroller.h
)

target_include_directories(kgenmoji_core PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(kgenmoji_core PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    Qt6::Network
)

add_executable(kgenmoji
    main.cpp
    resources.qrc
)

target_link_libraries(kgenmoji PRIVATE
    kgenmoji_core
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    KF6::CoreAddons
    KF6::I18n
)

install(TARGETS kgenmoji DESTINATION ${KDE_INSTALL_BINDIR})
install(FILES org.cesar.kgenmoji.desktop DESTINATION ${KDE_INSTALL_APPDIR})

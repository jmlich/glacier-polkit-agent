cmake_minimum_required(VERSION 3.21.0)

project(glacier-polkit-agent
    VERSION 0.1
    DESCRIPTION "Glacier Polkit agent")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

include(FindPkgConfig)
include(FeatureSummary)
include(GNUInstallDirs)

set(QT_MIN_VERSION "5.11.0")
find_package(Qt6 ${QT_MIN_VERSION} REQUIRED COMPONENTS
    Gui
    Qml
    Quick
    DBus
    LinguistTools )

find_package(Glacier COMPONENTS App REQUIRED)
find_package(PkgConfig REQUIRED)
pkg_check_modules(POLKITQT6 polkit-qt6-1 REQUIRED IMPORTED_TARGET)

find_program(QDBUSXML2CPP NAMES qdbusxml2cpp PATHS /usr/lib/qt6/bin/)
if(NOT QDBUSXML2CPP)
    message(FATAL_ERROR "qdbusxml2cpp not found")
endif()

add_custom_command(OUTPUT polkitAuthAgentAdaptor.h polkitAuthAgentAdaptor.cpp
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/org.nemomobile.polkitAuthAgent.xml
    COMMAND ${QDBUSXML2CPP} -c PolkitAuthAgentAdaptor -a polkitAuthAgentAdaptor.h:polkitAuthAgentAdaptor.cpp ${CMAKE_CURRENT_SOURCE_DIR}/org.nemomobile.polkitAuthAgent.xml)


add_executable(glacier-polkit-agent
    main.cpp
    polkitinterface.h
    polkitinterface.cpp
    polkitAuthAgentAdaptor.cpp
    polkitAuthAgentAdaptor.h)

target_link_libraries(glacier-polkit-agent
    Qt6::Core
    Qt6::Qml
    Qt6::Quick
    Qt6::DBus
    Glacier::App
    PkgConfig::POLKITQT6)

install(TARGETS glacier-polkit-agent RUNTIME
    DESTINATION /usr/bin/)

install(FILES qml/glacier-polkit-agent.qml
    DESTINATION /usr/share/glacier-polkit-agent/qml/)

install(FILES glacier-polkit-agent.service
    DESTINATION /usr/lib/systemd/user/)

# Translations
file(GLOB TS_FILES translations/*.ts)
qt_add_translation(QM_FILES ${TS_FILES})
add_custom_target(translations DEPENDS ${QM_FILES})
add_dependencies(glacier-polkit-agent translations)
install(FILES ${QM_FILES}
        DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-polkit-agent/translations)

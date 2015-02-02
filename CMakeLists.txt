project(kdevgoplugin)

set(VERSION_MAJOR 1)
set(VERSION_MINOR 90)
set(VERSION_PATCH 90)
# KDevplatform dependency version
set(KDEVPLATFORM_VERSION "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake/)

cmake_minimum_required(VERSION 2.8.12)
find_package(ECM 0.0.9 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(ECMAddTests)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings)

find_package(Qt5 REQUIRED Core Widgets Test)
find_package(KF5 REQUIRED COMPONENTS KDELibs4Support ThreadWeaver TextEditor I18n)
find_package(KDevPlatform ${KDEVPLATFORM_VERSION} REQUIRED)
find_package(KDevelop REQUIRED)

include_directories(
    ${KDEVELOP_INCLUDE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_SOURCE_DIR}
)

enable_testing()

add_subdirectory(parser)
add_subdirectory(duchain)
add_subdirectory(codecompletion)

set(goplugin_SRC 
    kdevgoplugin.cpp
    golangparsejob.cpp
    gohighlighting.cpp
    godebug.cpp
)

kdevplatform_add_plugin(kdevgoplugin JSON kdevgoplugin.json SOURCES ${goplugin_SRC})
#add_library(kdevgoplugin MODULE ${goplugin_SRC})
target_link_libraries(kdevgoplugin
    dparse
    kdevgoparser
    kdevgoduchain
    kdevgocompletion

    KF5::ThreadWeaver
    KF5::TextEditor
    KDev::Interfaces
    KDev::Language
)

#install(TARGETS kdevgoplugin DESTINATION ${PLUGIN_INSTALL_DIR}../qt/plugins/kdevplatform/${KDEVPLATFORM_VERSION})

#configure_file(kdev-go.desktop.in ${CMAKE_BINARY_DIR}/kdev-go.desktop)
#install(FILES ${CMAKE_CURRENT_BINARY_DIR}/kdev-go.desktop DESTINATION ${SERVICES_INSTALL_DIR})

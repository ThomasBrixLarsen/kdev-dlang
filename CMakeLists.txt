cmake_minimum_required(VERSION 2.8.12)
project(kdevdlangplugin)

set(VERSION_MAJOR 1)
set(VERSION_MINOR 90)
set(VERSION_PATCH 90)
# KDevplatform dependency version
set(KDEVPLATFORM_VERSION "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}")

find_package(ECM 0.0.9 REQUIRED NO_MODULE)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(ECMAddTests)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings)
include(GenerateExportHeader)

find_package(Qt5 REQUIRED Core Widgets Test)
find_package(KF5 REQUIRED COMPONENTS ItemModels ThreadWeaver TextEditor I18n)
find_package(KDevPlatform ${KDEVPLATFORM_VERSION} REQUIRED)
find_package(KDevelop REQUIRED)

include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_SOURCE_DIR}
)

enable_testing()

add_subdirectory(parser)
add_subdirectory(duchain)
add_subdirectory(codecompletion)

kdevplatform_add_plugin(kdevdlangplugin JSON kdevdlang.json SOURCES
    kdevdlangplugin.cpp
    dlangparsejob.cpp
    dhighlighting.cpp
    ddebug.cpp
)

target_link_libraries(kdevdlangplugin
    KDev::Interfaces
    KDev::Language
    KF5::ThreadWeaver
    KF5::TextEditor
    kdevdparser
    kdevdduchain
    kdevdcompletion
    dparser
)

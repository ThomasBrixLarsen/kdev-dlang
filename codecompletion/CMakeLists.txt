include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/duchain
    ${KDEVPGQT_INCLUDE_DIR}
)

set(completion_SRCS
    model.cpp
    worker.cpp
    context.cpp
    items/completionitem.cpp
    items/functionitem.cpp
    items/importcompletionitem.cpp
    completiondebug.cpp
)

add_library(kdevdcompletion STATIC ${completion_SRCS})

target_link_libraries(kdevdcompletion LINK_PRIVATE
    KDev::Language
    KDev::Interfaces
    KDev::Project
    dparser
    kdevdparser
    kdevdduchain
)

#install(TARGETS kdevdcompletion DESTINATION ${INSTALL_TARGETS_DEFAULT_ARGS})

#add_subdirectory(tests)

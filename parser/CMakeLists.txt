include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(go_parser_lib_SRC
    parsesession.cpp
)

add_library(kdevgoparser STATIC ${go_parser_lib_SRC})

target_link_libraries(kdevgoparser LINK_PRIVATE
    KDev::Language
    dparse
)

#install(TARGETS kdevgoparser DESTINATION ${INSTALL_TARGETS_DEFAULT_ARGS})

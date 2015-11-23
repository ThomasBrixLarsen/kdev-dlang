include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_custom_command(OUTPUT libdparser.so COMMAND cmake -E ./build.sh WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_target(libdparser ALL DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/libdparser.so)

set(d_parser_lib_SRC
    parsesession.cpp
)

add_library(kdevdparser STATIC ${d_parser_lib_SRC})

target_link_libraries(kdevdparser LINK_PRIVATE
    KDev::Language
    ${CMAKE_CURRENT_SOURCE_DIR}/libdparser.so
)

install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/libdparser.so DESTINATION lib)

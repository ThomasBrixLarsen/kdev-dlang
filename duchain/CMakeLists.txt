add_library(kdevdduchain STATIC
	builders/declarationbuilder.cpp
	builders/contextbuilder.cpp
	builders/typebuilder.cpp
	builders/usebuilder.cpp
	helper.cpp
	duchaindebug.cpp
)

include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
)

generate_export_header(kdevdduchain EXPORT_FILE_NAME dduchainexport.h)
target_link_libraries(kdevdduchain
LINK_PRIVATE
    dparser
    kdevdparser
LINK_PUBLIC
    KDev::Interfaces
    KDev::Language
    KDev::Shell
    KDev::Project
 )

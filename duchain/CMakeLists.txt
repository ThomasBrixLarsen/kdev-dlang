add_library(kdevdduchain STATIC
	builders/declarationbuilder.cpp
	builders/contextbuilder.cpp
	builders/typebuilder.cpp
	builders/usebuilder.cpp
	dducontext.cpp
	helper.cpp
	duchaindebug.cpp
	
	types/gointegraltype.cpp
	types/gofunctiontype.cpp
	types/gostructuretype.cpp
	types/gomaptype.cpp
	types/gochantype.cpp
	declarations/functiondeclaration.cpp
	
	navigation/navigationwidget.cpp
	navigation/declarationnavigationcontext.cpp
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

#install(TARGETS kdevdduchain DESTINATION ${INSTALL_TARGETS_DEFAULT_ARGS})

#add_subdirectory(tests)
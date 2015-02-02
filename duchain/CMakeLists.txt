add_library(kdevgoduchain STATIC
	builders/declarationbuilder.cpp
	builders/contextbuilder.cpp
	builders/typebuilder.cpp
	builders/usebuilder.cpp
	goducontext.cpp
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

generate_export_header(kdevgoduchain EXPORT_FILE_NAME goduchainexport.h)
target_link_libraries(kdevgoduchain
LINK_PRIVATE
    dparse
    kdevgoparser
LINK_PUBLIC
    KDev::Interfaces
    KDev::Language
    KDev::Shell
    KDev::Project
 )

#install(TARGETS kdevgoduchain DESTINATION ${INSTALL_TARGETS_DEFAULT_ARGS})

#add_subdirectory(tests)
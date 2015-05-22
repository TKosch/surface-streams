include(CheckCSourceCompiles)

if(NOT TurboJPEG_INCLUDE_DIR)
	if(WIN32)
		if(${CMAKE_SIZEOF_VOID_P} EQUAL 8)
			set(DEFAULT_TurboJPEG_INCLUDE_DIR $ENV{TurboJPEG64_ROOT}/include)
		else()
			set(DEFAULT_TurboJPEG_INCLUDE_DIR $ENV{TurboJPEG_ROOT}/include)
		endif()
	else()
		set(DEFAULT_TurboJPEG_INCLUDE_DIR /opt/libjpeg-turbo/include)
	endif()
else()
	set(DEFAULT_TurboJPEG_INCLUDE_DIR ${TurboJPEG_INCLUDE_DIR})
	unset(TurboJPEG_INCLUDE_DIR)
	unset(TurboJPEG_INCLUDE_DIR CACHE)
endif()

find_path(TurboJPEG_INCLUDE_DIR turbojpeg.h DOC "TurboJPEG include directory (default: ${DEFAULT_TurboJPEG_INCLUDE_DIR})" HINTS ${DEFAULT_TurboJPEG_INCLUDE_DIR})

if(TurboJPEG_INCLUDE_DIR STREQUAL "TurboJPEG_INCLUDE_DIR-NOTFOUND")
	message(FATAL_ERROR "Could not find turbojpeg.h - Try define TurboJPEG_ROOT as a system variable.")
else()
	message(STATUS "TurboJPEG_INCLUDE_DIR = ${TurboJPEG_INCLUDE_DIR}")
endif()


if(WIN32)
	if(${CMAKE_SIZEOF_VOID_P} EQUAL 8)
		set(DEFAULT_TurboJPEG_LIBRARY $ENV{TurboJPEG64_ROOT}/lib/turbojpeg.lib)
	else()
		set(DEFAULT_TurboJPEG_LIBRARY $ENV{TurboJPEG_ROOT}/lib/turbojpeg.lib)
	endif()
else()
    find_library(DEFAULT_TurboJPEG_LIBRARY NAMES libturbojpeg.so libturbojpeg.a
        HINTS /opt/libjpeg-turbo/lib64/ /opt/libjpeg-turbo/lib/)
endif()

set(TurboJPEG_LIBRARY ${DEFAULT_TurboJPEG_LIBRARY} CACHE PATH
  "TurboJPEG library path (default: ${DEFAULT_TurboJPEG_LIBRARY})")

if(WIN32)
	set(CMAKE_REQUIRED_DEFINITIONS -MT)
endif()
set(CMAKE_REQUIRED_INCLUDES ${TurboJPEG_INCLUDE_DIR})
set(CMAKE_REQUIRED_LIBRARIES ${TurboJPEG_LIBRARY})
check_c_source_compiles("#include <turbojpeg.h>\nint main(void) { tjhandle h=tjInitCompress(); return 0; }" TURBOJPEG_WORKS)
set(CMAKE_REQUIRED_DEFINITIONS)
set(CMAKE_REQUIRED_INCLUDES)
set(CMAKE_REQUIRED_LIBRARIES)
if(NOT TURBOJPEG_WORKS)
	message(FATAL_ERROR "Could not link with TurboJPEG library ${TurboJPEG_LIBRARY}.  If it is installed in a different place, then set TurboJPEG_LIBRARY accordingly.")
endif()

message(STATUS "TurboJPEG_LIBRARY = ${TurboJPEG_LIBRARY}")

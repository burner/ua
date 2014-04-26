cmake_minimum_required(VERSION 2.8.1)

project(ua D)
SET(GLOBAL_DMD_DEFS "-w -unittest -debug" )
set(CMAKE_D_COMPILER dmd)

SET(CMAKE_D_FLAGS "${CMAKE_D_FLAGS} ${GLOBAL_DMD_DEFS}" )

#include_directories(.)
include_directories(${CMAKE_SOURCE_DIR})

enable_testing()

set(src
	ua/ctfetrie.d
	ua/options.d
	ua/uda.d
	ua/where.d
	ua/util/eightylineformat.d
	ua/util/type.d
)

set(tests
	tests/test.d
)

add_library(ua ${src})

add_executable(uatest ${tests})
target_link_libraries(uatest sqlite3 ua)

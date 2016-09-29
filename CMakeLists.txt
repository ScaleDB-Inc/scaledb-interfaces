
# Copyright (C) 2016 - ScaleDB Inc.
 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA


#
# This is suggested handling of build_type
#
IF(DEFINED CMAKE_BUILD_TYPE)
   SET(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "Choose the type of 
build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release
RelWithDebInfo MinSizeRel.")

ELSE()
   SET(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Choose the type of build,
options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release
RelWithDebInfo MinSizeRel.")
ENDIF()

#
# we still support compiling under mariadb tree
# which so far is the best way to go for Debug compilation
#
IF(NOT MYSQL_PROJECT_NAME)
    PROJECT ( SCALEDB C CXX )
    CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
    MESSAGE( STATUS "SCALEDB_SOURCE_DIR:" ${SCALEDB_SOURCE_DIR} )
    SET (_cmake_include_dir "${SCALEDB_SOURCE_DIR}/cmake")

ELSE()
    MESSAGE( STATUS "MYSQL_SOURCE_DIR:" ${MYSQL_SOURCE_DIR} )
    SET (_cmake_include_dir "${CMAKE_SOURCE_DIR}/storage/scaledb/cmake")
    #
    # replacing mysql compilation flags that dont supported by scaledb
    #
    STRING(REPLACE "-fno-exceptions" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})

ENDIF(NOT MYSQL_PROJECT_NAME)

#
# ScaleDB always needs these flags set
#
ADD_DEFINITIONS( -DSDB_DEBUG_LIGHT )
ADD_DEFINITIONS( -DSDB_DEBUG_INDEX )

#
# prints out current environment
#
MESSAGE( STATUS "CMAKE_MODULE_PATH           : " ${CMAKE_MODULE_PATH}          )
MESSAGE( STATUS "CMAKE_SYSTEM_NAME           : " ${CMAKE_SYSTEM_NAME}          )
MESSAGE( STATUS "CMAKE_BUILD_TYPE            : " ${CMAKE_BUILD_TYPE}           )
MESSAGE( STATUS "CMAKE_CXX_COMPILER          : " ${CMAKE_CXX_COMPILER}         )
MESSAGE( STATUS "CMAKE_CXX_FLAGS             : " ${CMAKE_CXX_FLAGS}            )
MESSAGE( STATUS "CMAKE_CXX_COMPILER_VERSION  : " ${CMAKE_CXX_COMPILER_VERSION} )
MESSAGE( STATUS "CMAKE_BINARY_DIR            : " ${CMAKE_BINARY_DIR}   )

#
# cmake is case sensitive
# -DCMAKE_BUILD_TYPE=DEBUG and -DCMAKE_BUILD_TYPE=Debug are different
#
STRING(TOLOWER ${CMAKE_BUILD_TYPE} _build_type)

IF(CMAKE_SYSTEM_NAME STREQUAL "Linux")

    ADD_DEFINITIONS( -DSDB_LINUX )
    FIND_PACKAGE( Threads )

    FIND_LIBRARY( LIBAIO NAMES aio )
    SET(AIO_LIBRARIES ${LIBAIO})
    MESSAGE( STATUS "Found AIO_LIBRARIES " ${AIO_LIBRARIES})

    FIND_LIBRARY( LIBICU NAMES icuuc )
    SET(ICU_LIBRARIES ${LIBICU})
    MESSAGE( STATUS "Found ICU_LIBRARIES " ${ICU_LIBRARIES})
 
    #
    # for compilers that do not have support for c++11 standard
    #
    IF(NOT CMAKE_C_COMPILER_VERSION VERSION_LESS "4.8.1")
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11" )
    ENDIF(NOT CMAKE_C_COMPILER_VERSION VERSION_LESS "4.8.1")

    IF( _build_type STREQUAL "relwithdebinfo")
        ADD_DEFINITIONS( -DMYSQL_DYNAMIC_PLUGIN)
        ADD_DEFINITIONS( -DDBUG_OFF)
        ADD_DEFINITIONS( -D_FORTIFY_SOURCE=2 )

    ELSEIF ( _build_type STREQUAL "debug")
        ADD_DEFINITIONS( -DMYSQL_DYNAMIC_PLUGIN )
        ADD_DEFINITIONS( -DSDB_DEBUG ) 
        ADD_DEFINITIONS( -DENABLED_DEBUG_SYNC )
        ADD_DEFINITIONS( -DSAFEMALLOC )
        #ADD_DEFINITIONS( -DSAFE_MUTEX )
    
    ELSEIF ( _build_type STREQUAL "release")
        ADD_DEFINITIONS( -DMYSQL_DYNAMIC_PLUGIN)
        ADD_DEFINITIONS( -DDBUG_OFF)
        ADD_DEFINITIONS( -D_FORIFY_SOURCE=2 )
        SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -s")

    ELSEIF ( _build_type STREQUAL "minsizerel")
        ADD_DEFINITIONS( -DMYSQL_DYNAMIC_PLUGIN)
        ADD_DEFINITIONS( -DDBUG_OFF)
        ADD_DEFINITIONS( -D_FORIFY_SOURCE=2 )
        SET(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} -s")

    ELSE()
        MESSAGE (FATAL_ERROR "Unknown CMAKE_BUILD_TYPE: " ${CMAKE_BUILD_TYPE})

    ENDIF( _build_type STREQUAL "relwithdebinfo")


    INCLUDE(${_cmake_include_dir}/scaledb.cmake)

ELSE()
    MESSAGE( FATAL_ERROR "UNSUPPORTED SYSTEM: " ${CMAKE_SYSTEM_NAME} )

ENDIF()

MESSAGE (STATUS "CMAKE_CXX_FLAGS_RELWITHDEBINFO = ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}") 
MESSAGE (STATUS "CMAKE_CXX_FLAGS_RELEASE        = ${CMAKE_CXX_FLAGS_RELEASE}") 
MESSAGE (STATUS "CMAKE_CXX_FLAGS_DEBUG          = ${CMAKE_CXX_FLAGS_DEBUG}") 
MESSAGE (STATUS "CMAKE_CXX_FLAGS                = ${CMAKE_CXX_FLAGS}") 
MESSAGE (STATUS "MY_PLUGIN_DIR                  = ${MY_PLUGIN_DIR}") 

INCLUDE(${_cmake_include_dir}/install.cmake)

INSTALL (TARGETS   scaledb                 LIBRARY DESTINATION ${MY_PLUGIN_DIR})


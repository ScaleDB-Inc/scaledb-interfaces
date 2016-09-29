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



SET(PLUGIN_SOURCES
    interface/mysql/incl/ha_scaledb.h
    interface/mysql/incl/mysql_foreign_key.h
    interface/mysql/incl/mysql_txn.h
    interface/mysql/incl/sdb_mysql_client.h
    interface/scaledb/incl/SdbCommon.h
    interface/scaledb/incl/SdbStorageAPI.h
    interface/mysql/impl/ha_scaledb.cpp
    interface/mysql/impl/mysql_foreign_key.cpp
    interface/mysql/impl/mysql_txn.cpp
    interface/mysql/impl/sdb_mysql_client.cpp
)
# PLUGIN_SOURCE

ADD_DEFINITIONS( -DMYSQL_SERVER    )
ADD_DEFINITIONS( -D_MARIA_DB       )
ADD_DEFINITIONS( -DSDB_MYSQL       )

IF(CMAKE_SYSTEM_NAME STREQUAL "Linux")


    IF(COMMAND MYSQL_ADD_PLUGIN)
    # when we want to be part of mariadb build
       
        MYSQL_ADD_PLUGIN(scaledb ${PLUGIN_SOURCES} STORAGE_ENGINE 
            LINK_LIBRARIES ${ZLIB_LIBRARY} ${AIO_LIBRARIES})

    ELSE()
    # for stand alone build process

        ADD_LIBRARY(scaledb MODULE ${PLUGIN_SOURCES})

        EXECUTE_PROCESS(COMMAND which mysql_config
                        OUTPUT_VARIABLE MYSQL_CONFIG
                        ERROR_VARIABLE  CMDERR
                        OUTPUT_STRIP_TRAILING_WHITESPACE)

	    IF(NOT MYSQL_CONFIG)
		    MESSAGE(FATAL_ERROR "Failed to find mysql_config: " ${CMDERR})
	    ENDIF(NOT MYSQL_CONFIG)

        EXECUTE_PROCESS(COMMAND ${MYSQL_CONFIG} --variable=pkgincludedir 
                        OUTPUT_VARIABLE MY_INCLUDE_DIR 
                        ERROR_VARIABLE  CMDERR
                        OUTPUT_STRIP_TRAILING_WHITESPACE)

        IF(NOT MY_INCLUDE_DIR)
            MESSAGE(FATAL_ERROR "Failed to get pkgincludedir: " ${CMDERR})
        ENDIF(NOT MY_INCLUDE_DIR)

        MESSAGE(STATUS "pkgincludedir: " ${MY_INCLUDE_DIR})

        EXECUTE_PROCESS(COMMAND ${MYSQL_CONFIG} --variable=pkglibdir
                        OUTPUT_VARIABLE MY_LIB_DIR 
                        ERROR_VARIABLE  CMDERR
                        OUTPUT_STRIP_TRAILING_WHITESPACE)

        IF(NOT MY_LIB_DIR)
            MESSAGE(FATAL_ERROR "Failed to get pkglibdir: " ${CMDERR})
        ENDIF(NOT MY_LIB_DIR)

        MESSAGE(STATUS "pkglibdir: " ${MY_LIB_DIR})

    
    	#
    	# user should be able to specify custom plugin directory
    	# for local environments, because it can be different from 
    	# displayed by mysql_config
    	# we want to make it different because we have to copy ha_scaledb.so
    	# into plugin directory, if there is no permissions, then `make install'
    	# will fail
    	#
    	IF(NOT MY_PLUGIN_DIR)
            EXECUTE_PROCESS(COMMAND ${MYSQL_CONFIG} --variable=plugindir
                            OUTPUT_VARIABLE MY_PLUGIN_DIR 
                            ERROR_VARIABLE  CMDERR
                            OUTPUT_STRIP_TRAILING_WHITESPACE)
        ENDIF(NOT MY_PLUGIN_DIR)

        IF(NOT MY_PLUGIN_DIR)
            MESSAGE(FATAL_ERROR "Failed to get plugindir: " ${CMDERR})
        ENDIF(NOT MY_PLUGIN_DIR)

        MESSAGE(STATUS "plugindir: " ${MY_PLUGIN_DIR})

        ADD_DEFINITIONS( -DHAVE_CONFIG_H )
        ADD_DEFINITIONS( -Dscaledb_EXPORTS )
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pie")
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,-z,relro,-z,now")
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fstack-protector")
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --param=ssp-buffer-size=4")
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")

        TARGET_LINK_LIBRARIES(scaledb ${CMAKE_THREAD_LIBS_INIT} )
        TARGET_LINK_LIBRARIES(scaledb ${AIO_LIBRARIES} )
    
        FIND_LIBRARY( LIB_MYSQL_SERVICES NAMES mysqlservices PATHS ${MY_LIB_DIR}) 
        SET(MYSQL_SERVICES_LIB ${LIB_MYSQL_SERVICES})
        MESSAGE( STATUS "Found MYSQL_SERVICES_LIB " ${MYSQL_SERVICES_LIB})
        TARGET_LINK_LIBRARIES(scaledb ${MYSQL_SERVICES_LIB} )
    
	    EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/mysql_includes  RESULT_VARIABLE RESVAR)
	    EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E copy_directory ${MY_INCLUDE_DIR} ${CMAKE_BINARY_DIR}/mysql_includes RESULT_VARIABLE RESVAR)
	    EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/mysql_includes/wsrep RESULT_VARIABLE RESVAR)
	    EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/wsrep ${CMAKE_BINARY_DIR}/mysql_includes/wsrep RESULT_VARIABLE RESVAR)

        TARGET_INCLUDE_DIRECTORIES(scaledb PRIVATE
		    ${CMAKE_BINARY_DIR}/mysql_includes
		    ${CMAKE_BINARY_DIR}/mysql_includes/private
                    ${MY_INCLUDE_DIR}/..
        )

        SET_TARGET_PROPERTIES(scaledb PROPERTIES OUTPUT_NAME ha_scaledb)
        SET_TARGET_PROPERTIES(scaledb PROPERTIES PREFIX "" COMPILE_DEFINITIONS "MYSQL_DYNAMIC_PLUGIN")

    ENDIF(COMMAND MYSQL_ADD_PLUGIN)

ENDIF(CMAKE_SYSTEM_NAME STREQUAL "Linux")

IF(CMAKE_SYSTEM_NAME STREQUAL "Windows")

    # on windows we only part of mysql build yet
    IF(COMMAND MYSQL_ADD_PLUGIN)
        MYSQL_ADD_PLUGIN(scaledb ${PLUGIN_SOURCES} STORAGE_ENGINE 
            LINK_LIBRARIES ${ZLIB_LIBRARY} ${AIO_LIBRARIES} icuuc icudt )
    ELSE()
        MESSAGE(FATAL_ERROR "No windows support for standalone compilation")
    ENDIF(COMMAND MYSQL_ADD_PLUGIN)

ENDIF(CMAKE_SYSTEM_NAME STREQUAL "Windows")



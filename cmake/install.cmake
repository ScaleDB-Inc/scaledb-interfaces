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


IF(UNIX)
    SET(DEFAULT_SCALEDB_HOME "${CMAKE_INSTALL_PREFIX}/scaledb")

    IF(DEB)
        #
        # DEB layout
        #
        SET(CPACK_DEBIAN_PACKAGE_NAME           "scaledb" )
        SET(CPACK_DEBIAN_PACKAGE_VERSION        "16.04"   )
        SET(CPACK_DEBIAN_PACKAGE_ARCHITECTURE   "amd64"   ) # we only support amd64
        #SET(CPACK_DEBIAN_PACKAGE_DEPENDENS      "libicu-dev (>=46.1-1), libaio-dev (>=0.3.110)" )
        SET(CPACK_DEBIAN_PACKAGE_DEPENDENS      "libaio1 (>= 0.3.109), netcat-openbsd (>= 1.105-7), python2.7 (>= 2.7.12)")
        SET(CPACK_DEBIAN_PACKAGE_MAINTAINER     "ScaleDB, Inc. <info@scaledb.com>")
        SET(CPACK_DEBIAN_PACKAGE_DESCRIPTION    "ScaleDB Cluster High volume, high velocity database engine Distributed, clustered, always on.") 
        SET(CPACK_DEBIAN_PACKAGE_SECTION        "database")
        SET(CPACK_DEBIAN_PACKAGE_PRIORITY       "optional")
        SET(CPACK_DEBIAN_PACKAGE_RECOMMENDS     "")
        SET(CPACK_DEBIAN_PACKAGE_SUGGESTS       "")
        SET(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA  "${SCALEDB_SOURCE_DIR}/cmake/debian/postinst;${SCALEDB_SOURCE_DIR}/cmake/debian/prerm;${SCALEDB_SOURCE_DIR}/cmake/debian/preinst")


#        SET(INSTALL_BINDIR_DEB                  "bin")
#        SET(INSTALL_SBINDIR_DEB                 "sbin")
#        SET(INSTALL_SCRIPTDIR_DEB               "bin")
#        SET(INSTALL_SYSCONF2DIR_DEB             "etc/cluster")
#        #
#        SET(INSTALL_LIBDIR_DEB                  "lib")
#	     # get if from mysql_config
#        SET(INSTALL_PLUGINDIR_DEB               "lib/mysql/plugin")
#        #
#        SET(INSTALL_INCLUDEDIR_DEB              "include/mysql")
#        #
#        SET(INSTALL_DOCDIR_DEB                  "share/doc")
#        SET(INSTALL_DOCREADMEDIR_DEB            "share/doc")
#        SET(INSTALL_MANDIR_DEB                  "share/man")
#        SET(INSTALL_INFODIR_DEB                 "share/info")
#        #
#        SET(INSTALL_SHAREDIR_DEB                "share")
#        SET(INSTALL_MYSQLSHAREDIR_DEB           "share/mysql")
#        SET(INSTALL_MYSQLTESTDIR_DEB            "mysql-test")
#        SET(INSTALL_SQLBENCHDIR_DEB             ".")
#        SET(INSTALL_SUPPORTFILESDIR_DEB         "share/mysql")
#        #
#        SET(INSTALL_MYSQLDATADIR_DEB            "/var/lib/mysql")
#        #
#        SET(INSTALL_UNIX_ADDRDIR_DEB            "/var/run/mysqld/mysqld.sock")
#        SET(INSTALL_SYSTEMD_UNITDIR_DEB         "/lib/systemd/system")


	MESSAGE( STATUS "Placeholder for Debian package")
    ELSEIF(RPM)
    	MESSAGE( STATUS "Placeholder for RedHat package")
    ELSE()
    	MESSAGE( STATUS "Generic installation")
 
	#
        SET(INSTALL_BINDIR           "${DEFAULT_SCALEDB_HOME}/lib")
        SET(INSTALL_SCRIPTDIR        "${DEFAULT_SCALEDB_HOME}/scripts")
        #
        SET(INSTALL_LIBDIR           "${DEFAULT_SCALEDB_HOME}/lib")

	#
	# need to pull information from mysql_config
	#
        #SET(INSTALL_PLUGINDIR        "lib/plugin")
        #
        
        #
        SET(INSTALL_DOCDIR           "${DEFAULT_SCALEDB_HOME}/docs")
	SET(INSTALL_ETC              "${DEFAULT_SCALEDB_HOME}/etc")
	SET(INSTALL_ETC_CLUSTER      "${DEFAULT_SCALEDB_HOME}/etc/cluster")
	SET(INSTALL_LOGDIR           "${DEFAULT_SCALEDB_HOME}/log")
	SET(INSTALL_LOCKDIR          "${DEFAULT_SCALEDB_HOME}/lock")
	SET(INSTALL_DATADIR          "${DEFAULT_SCALEDB_HOME}/data")
	SET(INSTALL_TEMPDIR          "${DEFAULT_SCALEDB_HOME}/tmp")

        #SET(INSTALL_DOCREADMEDIR     ".")
        #SET(INSTALL_MANDIR           "man")
        #SET(INSTALL_INFODIR          "docs")
        #
        #SET(INSTALL_SHAREDIR         "share")
        #SET(INSTALL_MYSQLSHAREDIR    "share")
        #SET(INSTALL_MYSQLTESTDIR     "mysql-test")
        #SET(INSTALL_SQLBENCHDIR      ".")
        #SET(INSTALL_SUPPORTFILESDIR  "support-files")
        #
        #SET(INSTALL_MYSQLDATADIR     "data")
        
        #SET(INSTALL_UNIX_ADDRDIR     "/tmp/mysql.sock")

    ENDIF(DEB)

ENDIF(UNIX)



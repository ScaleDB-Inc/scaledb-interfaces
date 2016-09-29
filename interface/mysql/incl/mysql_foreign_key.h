/* Copyright (C) 2009 - ScaleDB Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; version 2 of the License.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
*/
/* Copyright (C) 2007  ScaleDB Inc.

Note that ScaleDB's header files must come before MySQL header file.
This is because we have STL header files which must be declared before C header files.
 */
#ifdef SDB_MYSQL

#ifndef _MYSQL_FOREIGN_KEY_H
#define _MYSQL_FOREIGN_KEY_H

#include "string.h"


#ifdef _MARIA_DB
#include <mysql_version.h>
#if MYSQL_VERSION_ID>=50515
#include "sql_class.h"
#include "sql_array.h"
#elif MYSQL_VERSION_ID>50100
#include "mysql_priv.h"
#include <mysql/plugin.h>
#else
#include "../mysql_priv.h"
#endif
#else // _MARIA_DB
#include "mysql_priv.h"           // this must come second
#endif // _MARIA_DB
#include <mysql/plugin.h>         // this must come third
#include "../../scaledb/incl/SdbStorageAPI.h"

#define ID_INTERFACE_FOREIGN_KEY		30000
#define METAINFO_TOKEN_SEPARATORS_NO_SPACE ",.;()[]+-*/`"
class MysqlForeignKey {

public:

    // constructor and destructor 
	MysqlForeignKey();   
	~MysqlForeignKey();

	// This utility function can get next MySQL token.
	// Make it static so that it can be called without instantiating the object.
	static char* getNextToken(char* token, char* cstr, bool ignore_seperator);
	// save foreign key name and return the length of foreign key index name
	unsigned short setForeignKeyName(char* pForeignKeyName, bool ignore_seperator=false, char* pUserTableName=NULL, int fkNum=0);
	char* getForeignKeyName() { return pForeignKeyName_; }
    unsigned short getForeignKeyNameLength() { return ((unsigned short) strlen( pForeignKeyName_ )); }

    unsigned short setKeyNumber(KEY* keyInfo, unsigned short numOfKeys, char* pColumnNames);
	char** getIndexColumnNames() { return indexColumnNames; }
    void setParentTableName( char* pTableName ,bool ignore_sepeator =false);

	char* getParentTableName() { return pParentTableName_; }
    unsigned short getParentTableNameLength() { return ((unsigned short) strlen( pParentTableName_ )); }  
    void setParentColumnNames( char* pOffset , bool ignore_seperator=false);
	char** getParentColumnNames() { return parentColumnNames_; }
    //bool findParentDesignatorName(MetaInfo* pMetaInfo);

private:
    char* pForeignKeyName_;
    unsigned short keyNumber;
    unsigned short numOfKeyFields;
    char* indexColumnNames[METAINFO_MAX_KEY_FIELDS];
    char* pParentTableName_;
    char* parentColumnNames_[METAINFO_MAX_KEY_FIELDS];
//  char* pParentDesignatorName_;    // no longer use this field

};

#endif   // _MYSQL_FOREIGN_KEY_H

#endif //  SDB_MYSQL


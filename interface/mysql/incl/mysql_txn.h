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

//
//  File Name: mysql_txn.h
//
//  Description: This class contains information pertaining to a user thread such as
//    MySQL thread_id, ScaleDB user id, and lock count information.  It is a place holder for information
//    to be used between multiple MySQL interface method calls.
//    A MysqlTxn object is instantiated when a user executes the very first query in his connection.
//    A MysqlTxn object is freed when a user logs off (or close connection).
//
//  Version: 1.0
//
//  Copyright: ScaleDB, Inc. 2007
//
//  History: 10/18/2007  RCH   converted from Java.
//

#ifdef SDB_MYSQL

#ifndef _MYSQL_TXN_H
#define _MYSQL_TXN_H

/*
 Note that ScaleDB's header files must come before MySQL header file.
 This is because we have STL header files which must be declared before C header files.
 */
#include "../../scaledb/incl/SdbStorageAPI.h"

class MysqlTxn {

public:

	// constructor and destructor
	MysqlTxn();
	~MysqlTxn();

	unsigned long getMysqlThreadId() {return mysqlThreadId_;}
	void setMysqlThreadId(unsigned long aThreadId) {mysqlThreadId_ = aThreadId;}
	unsigned int getScaleDbUserId() {return scaleDbUserId_;}
	void setScaleDbUserId(unsigned int aUserId) {scaleDbUserId_ = aUserId;}
	unsigned int getScaledbDbId() {return scaledbDbId_;}
	void setScaledbDbId(unsigned int aScaledbDbId) {scaledbDbId_ = aScaledbDbId;}
	unsigned int getScaleDbTxnId() {return scaleDbTxnId_;}
	void setScaleDbTxnId(unsigned int aTxnId) {scaleDbTxnId_ = aTxnId;}
	bool getActiveTxn() {return (activeTxn_>0 ? true : false);} // go around compiler bug
	void setActiveTrn(bool aBool) {activeTxn_ = (aBool) ? 1 : 0;}

	unsigned short getDdlFlag() {return ddlFlag_;}
	void setDdlFlag(unsigned short ddlFlag) {ddlFlag_ = ddlFlag;}
	void setOrOpDdlFlag(unsigned short value) {ddlFlag_ = ddlFlag_ | value;} //apply logical OR operation

	void addAlterTableName(char* pAlterTableName);
	void removeAlterTableName();
	char* getAlterTableName() {return pAlterTableName_;}

	uint32 incGlobalInsertsCount() {return globalInsertsCount_++;} 
	uint32 getGlobalInsertsCount() {return globalInsertsCount_;} 
	void   initGlobalInsertsCount() {globalInsertsCount_ = 0;}


	int lockCount_; // number of table locks used in a statement
	int numberOfLockTables_; // number of tables specified in LOCK TABLES statement
	unsigned long txnIsolationLevel_; // transaciton isolation level
	int QueryManagerIdCount_;

private:
	unsigned long mysqlThreadId_;
	unsigned int scaleDbUserId_; // The UserId is actually a session id.
	unsigned int scaleDbTxnId_;
	unsigned short scaledbDbId_; // current DbId used by ScaleDB

	unsigned int activeTxn_; // whether or not it is within a transaction at the moment
	// need to use integer rather than bool due to a compiler bug??
	//SdbDynamicArray* pLockTablesArray_; // pointer to vector holding all lock table names
	uint64 lastStmtSavePointId_; // last stmt save point id

	// flag to indicate if it is a non-primary node in cluster.
	// We cannot put this flag in a table handler because ALTER TABLE and CREATE TABLE ... SELECT
	// both use multiple handlers.
	unsigned short ddlFlag_; // This flag has multiple bit values.  Need to deal bits individually.

	char* pAlterTableName_; // table name used in ALTER TABLE, CREATE/DROP INDEX statement

	uint32 globalInsertsCount_; // global insert count per thread 
};

#endif   // _MYSQL_TXN_H
#endif	// SDB_MYSQL

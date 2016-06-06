--get all tables from a tablespace
SELECT DT.OWNER,
       DT.TABLE_NAME,
       DT.TABLESPACE_NAME,
       DS.SEGMENT_NAME,
       DS.SEGMENT_TYPE,
       BYTES / 1024 / 1024 MB
  FROM DBA_TABLES DT, DBA_SEGMENTS DS
 WHERE DT.TABLESPACE_NAME = 'WAREHOUSE' AND SEGMENT_TYPE = 'TABLE' AND
       DT.TABLE_NAME = DS.SEGMENT_NAME;

--get table space
select segment_name,segment_type,bytes/1024/1024 MB , DS.* 
 from dba_segments DS
 where segment_type='TABLE' and segment_name='SALESMONITOR';


SELECT NAME,
    FILE#,
    STATUS,
    CHECKPOINT_CHANGE# "CHECKPOINT"   
  FROM   V$DATAFILE;


--get all tables from a tablespace
select owner, table_name,tablespace_name
   from dba_tables
where tablespace_name='YES_DWH_TS'

--get all tables from a tablespace
select DT.owner, DT.table_name,DT.tablespace_name , bytes/1024/1024 MB 
   from dba_tables DT , dba_segments DS 
where DT.tablespace_name='YES_DWH_TS' 
AND segment_type='TABLE' 
--AND DT.OWNER ='REPORT' 
AND DT.table_name  =  DS.segment_name
order by 4 desc;

DROP TABLESPACE tbs_perm_01
  INCLUDING CONTENTS
    CASCADE CONSTRAINTS;

DROP TABLESPACE tbs_perm_02
  INCLUDING CONTENTS AND DATAFILES
    CASCADE CONSTRAINTS;


/*
Question:  I need to understand how to remove a database instance from my server.  I have moved it to a new server and I now need to remove the instance.  I can find no documentation for this.  What are the procedures for deleting a database instance from the server?

Answer:  An Oracle instance consists of these components:

    The database files (*.dbf and *.ctl)
    The database file system ($ORACLE_HOME/admin/$ORACLE_SID) directories.  These contain the bdump, cdump, arch and pfile.
    The OS control structures.  In Windows these exist in the registry, while in UNIX/Linux they exist in directories such as /etc and /var/opt/oracle
    The OS user ID's.  These include the "oracle" user who owns the OS files.
    The Oracle software.  This exists in the $ORACLE_HOME/bin location.

To remove an instance in Windows:

    Shutdown and archive and/or backup the database
    Remove all Oracle .dbf and .ctl files
    Remove all Oracle directories
    Remove all Oracle registry entries
    Remove the oracle user

To remove a database instance in UNIX/Linux:

    Shutdown and archive and/or backup the database
    Remove all Oracle .dbf and .ctl files
    Remove all Oracle directories
    Remove all Oracle external files (/etc/oratab, /var/opt/oracle/oratab)
    Remove the oracle user (/etc/passwd and /etc/group)

Up to Oracle 10g, the file structure should look like the following:

/oracle0/product/oracle/8.1.3/            Top level $ORACLE_HOME
                                              bin/                  Standard distribution
structure under version
                                              doc/  
                                               rdbms/
                                               …
/oracle0/data/                      Place instance names under type directories
                     ortest1/
                     ortest2/
/oracle0/control/
                     ortest1/
                     ortest2/
/oracle0/redo/
                     ortest1/
                     ortest1/
/oracle0/admin/
                     ortest1/
                                  bdump/        backup_dump_dest
                                  udump/        user_dump_dest
                                  cdump/        core_dump_dest
                                  pfile/        initialization file location (linked
back to dbs directory)
                                  create/             Database creation script storage area
                     ortest2/
                                …
/oracle1/data/
            /control/
            /redo/
/oracle2/data/ 
            /control/
            /redo/
…
/oracle7/data/
            /control/
            /redo/

In Oracle 11g, the file directories have changed.

    The new $ADR_HOME directory is located by default at $ORACLE_BASE/diag, with the directories for each instance at $ORACLE_HOME/diag/$ORACLE_SID, at the same level as the traditional bdump, udump and cdump directories and the initialization parameters background_dump_dest and user_dump_dest are deprecated in 11g.

    In 11g, each $ORACLE_HOME/diag/$ORACLE_SID directory may contain these new directories:

        alert - A new alert directory for the plain text and XML versions of the alert log.
         

        incident - A new directory for the incident packaging software.
         

        incpkg - A directory for packaging an incident into a bundle.
         

        trace - A replacement for the ancient background dump (bdump) and user dump (udump) destinations.
         

        cdump - The old core dump directory retains it's 10g name.

In Windows, these are the registry entries.  See MOSC notes 124353.1 and 208256.1 to clean the registry.

HKEY_LOCAL_MACHINE\SOFTWARE\ORACLE\ALL_HOMES\IDx

HKEY_LOCAL_MACHINE\SOFTWARE\ORACLE\KEY_ora10g_Home1
HKEY_LOCAL_MACHINE\SOFTWARE\ORACLE\KEY_ora10g_Home2

In UNIX/Linux, these are the external Oracle files:

PATH AND FILE
	

DESCRIPTION

/etc/oratab 

/var/opt/oracle/oratab (Solaris)

    
	

The oratab file is used to identify each SID with its associated ORACLE_HOME.

/var/opt/oracle/srvConfig.loc

/etc/oracle/ocr.loc
	

This is a text file that identifies the location of the file used for cluster configuration and srvctl repository.

/etc/oraInst.loc

 
	

Identifies the location on disk of the Oracle inventory files and identifies the OS user group that owns the Oracle install. For a 10g install, this file is located in the $ORACLE_HOME directory.

/usr/local/bin/oraenv

/usr/local/bin/racenv

/usr/local/bin/coraenv

/usr/local/bin/dbhome
	

These scripts are used to set environmental variables. The oraenv and racenv scripts are Bash shell scripts used extensively in this book. The coraenv script is used in the C shell. The dbhome script is used by the other three scripts to identify the home directory associated with given database. 

*/
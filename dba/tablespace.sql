--Check the datafiles sizes..
SELECT * FROM DBA_DATA_FILES;

     FILE_NAME                 FILE_ID  TABLESPACE_NAME     BYTES    BLOCKS    STATUS
1 D:\ORACLEXE\ORADATA\XE\USERS.DBF    4       USERS          104857600    12800   AVAILABLE
2 D:\ORACLEXE\ORADATA\XE\SYSAUX.DBF   3       SYSAUX         450887680    55040   AVAILABLE
3 D:\ORACLEXE\ORADATA\XE\UNDO.DBF     2       UNDO            94371840    11520   AVAILABLE
4 D:\ORACLEXE\ORADATA\XE\SYSTEM.DBF   1       SYSTEM         629145600    76800   AVAILABLE

/*Then resize your datafile or add a new datafile to current tablespace
Resizing Datafile :*/

ALTER DATABASE DATAFILE ‘D:\ORACLEXE\ORADATA\XE\USERS.DBF‘ RESIZE 200M;
Addind Datafile to existing Tablespace:
ALTER TABLESPACE USERS ADD DATAFILE ‘D:\ORACLEXE\ORADATA\XE\USERS_2.DBF‘ SIZE 50M;

 
--Change the user’s default tablespace to a bigger one :)
SELECT * FROM Dba_Users;

  USERNAME USER_ID ACCOUNT_STATUS  DEFAULT_TABLESPACE
1 ASD         36     OPEN              SYSTEM
2 SYS          0     OPEN              SYSTEM
3 SYSTEM       5     OPEN              SYSTEM
4 ANONYMOUS   28     OPEN              SYSAUX   

ALTER USER asd DEFAULT TABLESPACE users;

--It changes “asd” schema’s default tablespace to USERS tablespace.
SELECT * FROM Dba_Users;

USERNAME USER_ID  ACCOUNT_STATUS  DEFAULT_TABLESPACE
1 ASD       36        OPEN             USERS
2 SYS        0        OPEN             SYSTEM
3 SYSTEM     5        OPEN             SYSTEM
4 ANONYMOUS 28        OPEN             SYSAUX  
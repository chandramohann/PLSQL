set heading off;
set echo off;
Set pages 999;
set long 90000;
spool skelet.sql
 connect skelet/skelet@skeluat;
 select DBMS_METADATA.GET_DDL('SEQUENCE', u.object_name)   from user_objects u  where object_type = 'SEQUENCE'; 
 select DBMS_METADATA.GET_DDL('LOB', u.object_name)   from user_objects u  where object_type = 'LOB'; 
 select DBMS_METADATA.GET_DDL('PACKAGE', u.object_name)   from user_objects u  where object_type = 'PACKAGE'; 
 select DBMS_METADATA.GET_DDL('PACKAGE BODY', u.object_name)   from user_objects u  where object_type = 'PACKAGE BODY'; 
 select DBMS_METADATA.GET_DDL('TRIGGER', u.object_name)   from user_objects u  where object_type = 'TRIGGER'; 
 select DBMS_METADATA.GET_DDL('MATERIALIZED VIEW', u.object_name)   from user_objects u  where object_type = 'MATERIALIZED VIEW'; 
 select DBMS_METADATA.GET_DDL('VIEW', u.object_name)   from user_objects u  where object_type = 'VIEW'; 
 select DBMS_METADATA.GET_DDL('FUNCTION', u.object_name)   from user_objects u  where object_type = 'FUNCTION'; 
 select DBMS_METADATA.GET_DDL('SYNONYM', u.object_name)   from user_objects u  where object_type = 'SYNONYM'; 
 select DBMS_METADATA.GET_DDL('JOB', u.object_name)   from user_objects u  where object_type = 'JOB'; 
 select DBMS_METADATA.GET_DDL('TYPE', u.object_name)   from user_objects u  where object_type = 'TYPE'; 
spool off;


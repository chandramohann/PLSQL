create or replace PROCEDURE SP_TESTDEV_DMP AS
/*
SP_TESTDEV_DMP.SQL
used for generating TESTet db dump from TESTUAT , TESTTEST , TESTDEV , SKLMAINT env
 
1.Run the below code to create and give access to TESTet user in 101 machine

          CREATE DIRECTORY devdump AS '/backup/devdump';
          grant read,write on directory devdump to TESTet;
          
2.Run the below block for creating TESTet schema dump

          begin
            sp_TESTdev_dmp;
          end;
          
3.use the below query to track the status of the schema dump job
        
        select * from dba_datapump_jobs;
        
4.TESTdev.log   
  TESTdev.dmp
  would be created in the   devdump directory (/backup/devdump)  on 101 machine
  
5.This should be only started from TESTUAT , TESTTEST , TESTDEV , SKLMAINT only 
***** do not try this at home nor run this on  production *********   
 
*/

  l_dp_handle       NUMBER;
  l_last_job_state  VARCHAR2(30) := 'UNDEFINED';
  l_job_state       VARCHAR2(30) := 'UNDEFINED';
  l_sts             KU$_STATUS;
BEGIN
  l_dp_handle := DBMS_DATAPUMP.open(
    operation   => 'EXPORT',
    job_mode    => 'SCHEMA', --'FULL', 
    remote_link => NULL,
    job_name    => 'TESTDEV_EXPJOB',
    version     => 'LATEST');

  DBMS_DATAPUMP.add_file(
    handle    => l_dp_handle,
    filename  => 'TESTdev.dmp',
    directory => 'DEVDUMP',
    filetype => 1);

  DBMS_DATAPUMP.add_file(
    handle    => l_dp_handle,
    filename  => 'TESTdev.log',
    directory => 'DEVDUMP',
    filetype => 3);

 --COMMENT THE BELOW FILTER FOR FULL DUMP
  DBMS_DATAPUMP.metadata_filter(
    handle => l_dp_handle,
    name   => 'SCHEMA_EXPR',
    value  => '= ''TESTET''');
 -- 
  DBMS_DATAPUMP.start_job(l_dp_handle);

  DBMS_DATAPUMP.detach(l_dp_handle);
  
END SP_TESTDEV_DMP;
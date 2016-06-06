--total inactive sessions
SELECT count(1)
  FROM v$session b
 WHERE b.status = 'INACTIVE' AND b.username = 'SKELET';     

--for all sessions
SELECT b.SID, b.serial#, b.status, b.osuser, b.machine, sql_text
  from v$sql sqlt, v$session b
 where b.sql_hash_value = sqlt.hash_value;
 
--for inactive session s
SELECT b.SID, b.serial#, b.status, b.osuser, b.machine, sql_text
  from v$sql sqlt, v$session b
 where b.sql_hash_value = sqlt.hash_value and b.status = 'INACTIVE' AND
       b.username = 'SKELET';


select b.SID, b.serial#, b.status, b.osuser, b.machine, sql_text
  from v$session b, v$sqltext sqlt
 where b.sql_address = sqlt.address and b.sql_hash_value = sqlt.hash_value
 order by piece;

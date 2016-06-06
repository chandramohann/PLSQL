SET HEAD OFF
SET TRIMSPOOL ON

SPOOL d:\tableobj.sql

SELECT 'prompt ' || object_type || ' ' || object_name || chr(10) ||
       'CREATE ' || CASE
         WHEN OBJECT_TYPE = 'VIEW' THEN
          'OR REPLACE ' || OBJECT_TYPE
         ELSE
          OBJECT_TYPE
       END || '  ' || OBJECT_NAME || ' AS (SELECT  *  FROM ' || OBJECT_NAME ||
       '@CDRPROD);'
  FROM USER_OBJECTS
 WHERE OBJECT_NAME NOT IN
       ('GSM_CALL_ORIGINATED', 'GPRS_CALL_ORIGINATED', 'GSM_CALL_TERMINATED') AND
       OBJECT_TYPE IN ('TABLE', 'VIEW')
 ORDER BY decode(object_type, 'TABLE', 1, 'VIEW', 2);
 
SPOOL OFF

SET HEAD ON

--PROMPT *****************************************************
--PROMPT INVALID COUNT
--PROMPT ***************************************************** 
--@d:\tableobj.sql 
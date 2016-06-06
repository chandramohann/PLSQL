CREATE OR REPLACE PROCEDURE SP_KILL_SQLDEVELOPER_SESSIONS AS
    L_SQL VARCHAR2(2000);
--kill all inactive SQL Developer sessions
BEGIN
    FOR C_ROW IN (SELECT B.SID, B.SERIAL#, B.STATUS, B.OSUSER, B.MACHINE
                    FROM V$SESSION B
                   WHERE B.STATUS = 'INACTIVE' AND PROGRAM = 'SQL Developer' AND
                         USERNAME = 'SKELET') LOOP
        L_SQL := 'alter system kill session ''' || C_ROW.SID || ',' ||
                 C_ROW.SERIAL# || '''';
        EXECUTE IMMEDIATE L_SQL;
        --DBMS_OUTPUT.PUT_LINE(L_SQL);
    END LOOP;
END;

SELECT sysdate, TRUNC(sysdate+1) + 1 / 24  FROM DUAL;

BEGIN
DBMS_SCHEDULER.DROP_JOB(job_name => 'SKELET_OSLOGGING');
END;


BEGIN
  DBMS_SCHEDULER.CREATE_JOB(JOB_NAME            => 'KILL_SQLDEVELOPER_JOB',
                            JOB_TYPE            => 'STORED_PROCEDURE',
                            JOB_ACTION          => 'SP_KILL_SQLDEVELOPER_SESSIONS',
                            number_of_arguments => 0,
                            START_DATE          => TRUNC(sysdate+1) + 1 / 24,                            
                            enabled             => TRUE,
                            auto_drop           => TRUE,
                            REPEAT_INTERVAL     => 'FREQ=DAILY;INTERVAL=1');
END;


SELECT B.SID, B.SERIAL#, B.STATUS, B.OSUSER, B.MACHINE
                    FROM V$SESSION B
                   WHERE B.STATUS = 'INACTIVE' AND PROGRAM = 'SQL Developer' AND
                         USERNAME = 'SKELET'


SELECT s.sid, p.spid, s.osuser, s.program
  FROM v$process p, v$session s
 WHERE p.addr = s.paddr and sid = 6411
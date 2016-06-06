DECLARE
    STMT_STR VARCHAR2(2000);
BEGIN
    FOR CUR_REC IN (SELECT OWNER,
                           SEGMENT_NAME,
                           SEGMENT_TYPE,
                           TABLESPACE_NAME,
                           BYTES / 1024 / 1024 MB,
                           INITIAL_EXTENT,
                           NEXT_EXTENT,
                           EXTENTS,
                           PCT_INCREASE
                      FROM DBA_SEGMENTS DBA
                     WHERE OWNER = 'SKELET' AND
                           SEGMENT_NAME LIKE '%BACK%' AND                           
                           SEGMENT_TYPE = 'TABLE') LOOP
    
        STMT_STR := 'drop table SKELET.' || CUR_REC.SEGMENT_NAME;
    
        EXECUTE IMMEDIATE STMT_STR;
        DBMS_OUTPUT.PUT_LINE(STMT_STR);
    
    END LOOP;

end;
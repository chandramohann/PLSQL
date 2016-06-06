CREATE DIRECTORY TB_COPY AS '/home/oracle/extract/tb_copy';

declare
begin
for cur_rec in 
(select dbms_metadata.get_ddl('TRIGGER',object_name) ||chr(10) ||'/' code , object_name from USER_OBJECTS where object_type  in ('PROCEDURE','VIEW','FUNCTION','TRIGGER') order by object_type) loop
 dbms_xslprocessor.clob2file( cur_rec.code,'EXTRACT',cur_rec.object_name ); 
 end loop;
end;


SELECT DBMS_METADATA.GET_DDL('TRIGGER', OBJECT_NAME) || CHR(10) || '/' CODE,
       OBJECT_NAME
  FROM USER_OBJECTS
 WHERE OBJECT_TYPE IN ('PROCEDURE', 'VIEW', 'FUNCTION')
 
 
SELECT *
  FROM USER_OBJECTS
 WHERE OBJECT_TYPE IN ('PACKAGE BODY')
 

 select object_name , object_type  , decode(object_type,'TYPE','typ',
                            'VIEW','vw',
                            'PACKAGE','pkb',
                            'FUNCTION','fnc',
                            'PROCEDURE','prc',
                            'PACKAGE BODY','pkg',
                            'TRIGGER','trg',
                            'sql')
 from user_objects where 
 object_type  in ('TYPE','PROCEDURE','VIEW','FUNCTION','PACKAGE','PACKAGE BODY','TRIGGER')
 order by decode(object_type,'TYPE',1,
                            'VIEW',2,
                            'PACKAGE',3,
                            'FUNCTION',4,
                            'PROCEDURE',5,
                            'PACKAGE BODY',6,
                            'TRIGGER',7,
                            8)
                            
select decode(cur_rec.object_type,'TYPE','typ',
                            'VIEW','vw',
                            'PACKAGE','pkb',
                            'FUNCTION','fnc',
                            'PROCEDURE','prc',
                            'PACKAGE BODY','pkg',
                            'TRIGGER','trg',
                            'sql')from dual

declare
begin
for cur_rec in 
(select dbms_metadata.get_ddl(object_type,object_name) ||chr(10) ||'/' code , object_name, decode(object_type,'TYPE','typ',
                            'VIEW','vw',
                            'PACKAGE','pkg',
                            'FUNCTION','fnc',
                            'PROCEDURE','prc',
                            'PACKAGE BODY','pkb',
                            'TRIGGER','trg',
                            'sql') type from USER_OBJECTS where object_type  in ('TYPE','PROCEDURE','VIEW','FUNCTION','PACKAGE','TRIGGER') order by object_type) loop
 dbms_xslprocessor.clob2file( cur_rec.code,'EXTRACT',cur_rec.object_name||'.'||cur_rec.type ); 
 end loop;
end;                            
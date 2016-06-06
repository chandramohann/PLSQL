create or replace PROCEDURE           "SP_CREATEBACKUP" as
   l_instance varchar2(50);
   l_schema   varchar2(50);
   l_count    number;
begin
   select sys_context('userenv', 'db_name'),
          sys_context('userenv', 'session_user')
     into l_instance, l_schema
     from dual;
   Dbms_Output.put_line(l_schema);
   SELECT count(1)
     into l_count
     FROM all_directories
    where directory_name = l_schema;

   --Dbms_Output.put_line('count :' || l_count);

   if l_count > 0 then
      for cur_rec in (select dbms_metadata.get_ddl(replace(object_type,
                                                           ' ',
                                                           '_'),
                                                   object_name,
                                                   owner) || chr(10) || '/' code,
                             object_name,
                             decode(object_type,
                                    'TABLE',
                                    'tbl',
                                    'TYPE',
                                    'typ',
                                    'VIEW',
                                    'vw',
                                    'PACKAGE',
                                    'pkg',
                                    'FUNCTION',
                                    'fnc',
                                    'PROCEDURE',
                                    'prc',
                                    'PACKAGE BODY',
                                    'pkb',
                                    'TRIGGER',
                                    'trg',
                                    'SEQUENCE',
                                    'seq',
                                    'sql') type
                        from all_objects
                       where OWNER = l_schema and
                             object_type not like '%LOB' and
                             object_type not like '%JOB'
                       order by decode(object_type,
                                       'TABLE',
                                       '1',
                                       'TYPE',
                                       '2',
                                       'TRIGGER',
                                       '3',
                                       'SEQUENCE',
                                       '4',
                                       'VIEW',
                                       '5',
                                       'PACKAGE',
                                       '6',
                                       'FUNCTION',
                                       '7',
                                       'PROCEDURE',
                                       '8',
                                       'PACKAGE BODY',
                                       '9',
                                       'sql'),
                                created) loop

         dbms_xslprocessor.clob2file(cur_rec.code,
                                     l_schema,
                                     cur_rec.object_name || '.' ||
                                     cur_rec.type);
      end loop;
   end if;
end;
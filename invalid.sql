set head off
set feedback off
SPOOL c:\alt.sql
SELECT 	'ALTER '||
	DECODE( object_type,
		'TRIGGER','TRIGGER ','VIEW','VIEW ')||
	object_name||' COMPILE '||
	DECODE( object_type, 'TRIGGER',';','VIEW',';') command
FROM	user_objects
WHERE	status='INVALID'
AND 	OBJECT_TYPE in('VIEW','TRIGGER')
--AND	object_name NOT LIKE 'LC%'
--AND	object_name NOT LIKE 'FX%'
--AND	object_name NOT LIKE 'FT%'
--AND	object_name  LIKE 'IC%'
order by object_type
/
set head on
set feedback on
spool off
@c:\alt.sql

select (select max(substr(sql_text, 1, 400)) from v$sql sq where sq.sql_id = t_src.sql_id) as sql_text,
       (select object_name from dba_procedures where object_id = t_src.plsql_entry_object_id and subprogram_id = 0) as plsql_entry_object,
       (select procedure_name from dba_procedures where object_id = t_src.plsql_entry_object_id and subprogram_id = t_src.plsql_entry_subprogram_id) as plsql_entry_subprogram,
       (select object_name from dba_procedures where object_id = t_src.plsql_object_id and subprogram_id = 0) as plsql_entry_object,
       (select procedure_name from dba_procedures where object_id = t_src.plsql_object_id and subprogram_id = t_src.PLSQL_SUBPROGRAM_ID) as plsql_entry_subprogram
  from BASH$HIST_ACTIVE_SESS_HISTORY t_src
 where t_src.session_id in (7594,15825)
   and t_src.sample_time > to_date('30.11.2020 22:29:00', 'DD.MM.YYYY HH24:MI:SS');

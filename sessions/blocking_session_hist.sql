select blocked.session_id
      ,blocked.session_serial#
      ,blocked.username
      ,(select max(substr(sql_text, 1, 400)) from v$sql sq where sq.sql_id = blocked.sql_id) as sql_text
      ,(select object_name
          from dba_procedures
         where object_id = blocked.plsql_entry_object_id
           and subprogram_id = 0) as plsql_entry_object
      ,(select procedure_name
          from dba_procedures
         where object_id = blocked.plsql_entry_object_id
           and subprogram_id = blocked.plsql_entry_subprogram_id) as plsql_entry_subprogram
      ,(select object_name
          from dba_procedures
         where object_id = blocked.plsql_object_id
           and subprogram_id = 0) as plsql_entry_object
      ,(select procedure_name
          from dba_procedures
         where object_id = blocked.plsql_object_id
           and subprogram_id = blocked.PLSQL_SUBPROGRAM_ID) as plsql_entry_subprogram
  from BASH$HIST_ACTIVE_SESS_HISTORY t_src
  join BASH$HIST_ACTIVE_SESS_HISTORY blocked
    on blocked.blocking_session = t_src.session_id
   and blocked.sample_id = t_src.sample_id
where t_src.session_id = 1501 --  сессия, которая блокирует другие сессии
   and t_src.sample_time > to_date('23.05.2019 08:00:00', 'DD.MM.YYYY HH24:MI:SS')
   and rownum < 10;
 
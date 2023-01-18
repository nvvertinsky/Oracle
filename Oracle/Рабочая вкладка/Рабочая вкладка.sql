dbms_lob



select * from dba_source c where lower(c.text) like lower('%test%')
select * from install_s where object_name = upper('test') order by 1

select * from deb order by 1;
truncate table deb;


select dd.name, 
       dd.type, 
       dd.referenced_name, 
       dd.referenced_type
  from dba_dependencies dd
 where dd.referenced_name = 'EDO_1C_ASROLF';

select jb.owner,
       jb.job_name,
       jb.job_creator,
       jb.enabled,
       jb.job_type,
       jb.comments,
       jb.job_action,
       sp.program_action,
       listagg(spa.argument_name || '=>' || spa.default_value, ', ') within group (order by spa.argument_name) program_args,
       listagg(jba.argument_name || '=>' || jba.value, ', ') within group (order by jba.argument_name) job_args
  from dba_scheduler_jobs jb,
       dba_scheduler_programs sp,
       dba_scheduler_program_args spa,
       dba_scheduler_job_args jba
 where sp.program_name(+) = jb.program_name
   and sp.owner(+) = jb.owner
   --
   and spa.owner(+) = sp.owner
   and spa.program_name(+) = sp.program_name
   --
   and jba.OWNER(+) = jb.owner
   and jba.JOB_NAME(+) = jb.job_name
   --and jb.job_name = ''
 group by jb.owner,
          jb.job_name,
          jb.job_creator,
          jb.enabled,
          jb.job_type,
          jb.comments,
          jb.job_action,
          sp.program_action;

select t.sid, 
       t.serial#, 
       t.osuser, 
       t.machine, 
       t.program
  from v$session t
 order by t.machine asc;


call sys.utl_recomp.recomp_parallel(threads => 48);
select a.owner,
       a.object_type,
       a.object_name,
       a.status
  from dba_objects a
 where a.status = 'INVALID'
   and a.object_type not in ('UNDEFINED', 'JAVA CLASS', 'MATERIALIZED VIEW')
   and a.object_name not like 'BIN$%'
 order by owner, 
          object_type, 
          object_name;
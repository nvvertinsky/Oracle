-- создадим таблицу
create table t2 as select object_id id, object_name text, 0 session_id from big_table where 1=0;

-- создадим таблицу которая будет поддержвать очереди заданий
create table job_parms(job number primary key, lo_rid, hi_rid);

--пишем процедуру
create or replace procedure serial(p_job in number) is
  l_rec job_parms%rowtype;
begin
  select *
    into l_rec
    from job_parms
   where job = p_job;

  for x in (select object_id id,
		           object_name text
              from big_table
             where rowid between l_rec.lo_rid and l_rec.hi_rid)
  loop
    -- сложная обработка данных
    insert into t2(id, text, session_id)
         values (x.id, x.text, sys_context('userenv', 'sessionid')); 
  end loop;
  
  delete from job_parms where job = p_job;
  commit;
end;
/
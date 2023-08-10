-- ОЧЕНЬ ВАЖНО. Параметр БД job_queue_processes должен быть больше 0. Он определяет максимальное количество одновременно выполняемых заданий 
-- alter system set job_queue_processes = 4;

create or replace procedure serial(p_lo_rid in rowid, p_hi_rid in rowid) is
begin
  for cur in (select object_id id
                from big_table
               where rowid between p_lo_rid and p_hi_rid)
  loop
    null; /*Здесь логика*/
  end loop;
end;

begin
  dbms_parallel_execute.create_task('PLPRC');
end;

begin
  dbms_parallel_execute.create_chunks_by_rowid(task_name => 'PLPRC',
                                               table_owner => 'A', 
                                               table_name => 'BIG_TABLE',
                                               by_row => false, /*Если не строки, значит блоки. Целесообразнее делать именно поблочное разбиение, чтобы конкурентные сессии не конфликтовали между собой при обращении к одним и тем же блокам*/
                                               chunk_size => 10000); /*Строки или блоки*/
end;


begin
  /*Внутри себя dbms_parallel_execute использует dbms_scheduler*/
  dbms_parallel_execute.run_task(task_name => 'PLPRC',
                                 sql_stmt => 'begin serial(:start_id, :end_id); end;',
                                 language_flag => dbms_sql.native, 
                                 parallel_level => 4); /*Сколько будет создано джобов. Должно быть не больше job_queue_processes*/
end;

-- Посмотреть результаты выполнения.
select t.chunk_id,
       t.status,
       t.start_rowid,
       t.end_rowid
  from dba_parallel_execute_chunks t
 where t.task_name = 'PLPRC'
 order by chunk_id;
 

begin
  dbms_parallel_execute.drop_task('PLPRC');
end;
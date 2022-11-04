--Допустим есть последовательная процедура

create or replace procedure serial(p_lo_rid in rowid, p_hi_rid in rowid) is
begin
  for x in (select object_id id,
		   object_name text
              from big_table
             where rowid between p_lo_rid and p_hi_rid)
  loop
    -- сложная обработка данных
    insert into t2(id, text, session_id)
         values (x.id, x.text, sys_context('userenv', 'sessionid')); 
  end loop;
end;
/

-- Подготавливаем все для параллельного выполнения
begin
  dbms_parallel_execute.create_task('process big table');

  -- create_chunks_by_rowid разбивает таблицы на диапазоны
  dbms_parallel_execute.create_chunks_by_rowid(task_name => 'PROCESS BIG TABLE', -- именование задачи
					       table_onwer => user, 
					       table_name => 'BIG_TABLE',
					       by_row => false, -- 10000 указывает что это не кол-во строк, а кол-во блоков.
           				       chunk_size => 10000); -- 10000 блоков
end;
/

-- Запускаем
begin
  -- внутри себя dbms_parallel_execute использует dbms_scheduler
  dbms_parallel_execute.run_task(task_name => 'PROCESS BIG TABLE',
				 sql_stmt => 'begin serial(:start_id, :end_id); end;',
			         language_flag => dbms_sql.native, 
				 parallel_level => 4); -- будут задействованы четыре параллельных потока/процесса
end;
/

-- Посмотреть результаты выполнения.
select * 
  from (select chunk_id,
	       status,
	       start_rowid,
	       end_rowid
          from dba_parallel_execute_chunks
         where task_name = 'PROCESS BIG TABLE'
         order by chunk_id))
 where rownum <= 5;
 

begin
  dbms_parallel_execute.drop_task('PROCESS BIG TABLE'); -- удалить задачу
end;
/















/*
Дана интерфейсная таблица XX_INTERFACE, в которую попадают данные из внешней системы.
Необходимо написать обработчик на plsql, который для каждой строки интерфейсной таблицы запускает некоторое API XX_API_PKG.EXECUTE(id)
сделать так, чтобы программу можно было запускать параллельно самой себе, при этом API выше не нужно запускать 2 раза для одной строки интерфейсной таблицы.
*/

create table xx_interface(id number, trx_number varchar2(255));


Получается есть некая таблица XX_INTERFACE с данными. 
На каждой строке нужно запустить процедуру XX_API_PKG.EXECUTE(id). Запускать процедуру можно только один раз.
Нам нужно написать процедуру на plsql, которая будет параллельно читать данные чанками и выполнять. 

create or replace procedure proc(p_lo_rid in rowid, p_hi_rid in rowid) is
begin
  for cur in (select t.id
                from xx_interface t
               where rowid between p_lo_rid and p_hi_rid)
  loop
    xx_api_pkg.execute(cur.id);
  end loop;
end;

begin
  dbms_parallel_execute.create_task('XX');
end;

begin
  dbms_parallel_execute.create_chunks_by_rowid(task_name => 'XX',
                                               table_owner => 'PUBLIC', 
                                               table_name => 'XX_INTERFACE',
                                               by_row => false, /*Если не строки, значит блоки. Целесообразнее делать именно поблочное разбиение, чтобы конкурентные сессии не конфликтовали между собой при обращении к одним и тем же блокам*/
                                               chunk_size => 10000); /*Строки или блоки*/
end;


begin
  /*Внутри себя dbms_parallel_execute использует dbms_scheduler*/
  dbms_parallel_execute.run_task(task_name => 'XX',
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
 where t.task_name = 'XX'
 order by chunk_id;
 

begin
  dbms_parallel_execute.drop_task('XX');
end;
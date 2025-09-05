# Профилирование PL/SQL кода

## DBMS_PROFILER
  - Обычный профайлер. Сохраняет время выполнения каждой подпрограммы.

### Само профилирование
````
begin
   dbms_profiler.start_profiler ('vprofile');
   null; /*Код для профилирования*/
   dbms_profiler.stop_profiler;
end;
````


### Узнать runid профилирования
````
select runid,
       run_date,
       run_comment,
       run_total_time
  from plsql_profiler_runs
 order by runid;
````

### Выгружаем отчет
````
select u.runid,
       u.unit_number,
       u.unit_type,
       u.unit_owner,
       u.unit_name,
       d.line#,
       d.total_occur,
       ltrim(to_char(d.total_time /*Наносекунды*/ / 1000000000)) /*перевел в секунды*/, 
       d.min_time,
       d.max_time
  from plsql_profiler_units u,
       plsql_profiler_data d
 where u.runid = 10
   and u.runid = d.runid
   and u.unit_number = d.unit_number
 order by d.total_time desc;
````



## DBMS_HPROF.
Иерархический профайлер. 
Так же замеряет время работы каждой подпрограммы, то на этот раз показывает callstack каждой подпрограммы.
Короче говоря можно увидеть кто кого вызывает.
  

### Создаем директорию
````
create or replace directory N1_TEST as '/mnt/test';
````

### Начинаем профилирование
````
begin
  dbms_hprof.start_profiling(location => 'TEST', filename => 'vprofile.trc');
end;

begin
  proc();
end;

begin
  dbms_hprof.stop_profiling();
end;
````

### Способы получения данных
1. Сформировать с помощью утилиты  plshprof
````
plshprof vprofile.trc
````

2. Вызвать analyze и затем проверить таблицы
````
begin
  dbms_output.put_line(dbms_hprof.analyze('HPROF_DIR', 'vprofile.trc'));
end;

select runid, run_timestamp, total_elapsed_time, run_comment from dbmshp_runs;              # Возвращает все текущие запуски
select symbolid, owner, module, type, function, line#, namespace from dbmshp_function_info; # получения имен всех профилированных подпрограмм по всем запускам

-- Информации о выполнении подпрограмм для конкретного запуска
select function, 
	 line#, 
	 namespace, 
	 subtree_elapsed_time, 
	 function_elapsed_time, 
	 calls 
from dbmshp_function_info 
where runid = 177

-- 
select rpad (' ', level * 2, ' ') || fi.owner || '.' || fi.module as name, 
	 fi.function, pci.subtree_elapsed_time, pci.function_elapsed_time,
	 pci.calls
from dbmshp_parent_child_info pci,
	 dbmshp_function_info fi
where pci.runid = 177 
 and pci.runid = fi.runid
 and pci.childsymid = fi.symbolid 
connect by prior childsymid = parentsymid 
start with pci.parentsymid = 1
````
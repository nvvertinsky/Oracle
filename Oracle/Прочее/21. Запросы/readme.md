### Получить значение переменной привязки
````
select r.name,
       r.last_captured,
       r.value_string
  from v$sql_bind_capture r
 where r.SQL_ID = '1ngw1nr5s400s';
````


### Отследить в каком месте в коде происходит commit
````
ALTER SESSION DISABLE COMMIT IN PROCEDURE; -- Если в pl/sql коде будет commit, то будет исключение. Захватывает даже автономные процедуры.
````


### Посмотреть долго выполняющийся запрос (если остался в кеше еще)
````
select s.sql_id,
       s.first_load_time,
	   s.last_load_time,
	   s.elapsed_time, -- микросекунды
	   s.cpu_time
  from v$sql s
 where s.sql_text like '%%';
 
-- Если куплен пакет диагностики и оптимизации (Diagnostics and Tuning packs), то можно сделать предыдущий запрос проще 

select to_char(r.sql_exec_start, 'dd.mm.yyyy hh24:mi') sql_exec_start,
       r.elapsed_time,
	   r.cpu_time
  from v$sql_monitor r
 where r.sql_id = '';

````

### Посмотреть долго выполняющийся запрос (исторический). Только если доплатили за AWR.
````
-- Посмотреть установлены ли компоненты. Если две записи со статусом VALID или OPTION OFF, то AWR установлен.
show parameter CONTROL_MANAGEMENT_PACK_ACCESS

-- или
select s.name,
       s.version,
       s.description,
       s.detected_usages,
       s.last_usage_date
  from dba_feature_usage_statistics s
 where upper(s.name) like '%AWR%'
	
	
select sql_id,
       elapsed_time_delta/executions_delta avg_elapsed
  from sys.dba_hist_sqlstat t
 where t.snap_id = :snap;
````
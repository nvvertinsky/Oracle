-- Посмотреть долго выполняющийся запрос (если остался в кеше еще)

select s.sql_id,
       s.first_load_time,
	   s.last_load_time,
	   s.elapsed_time, -- микросекунды
	   s.cpu_time
  from v$sql s
 where s.sql_text like '%%';
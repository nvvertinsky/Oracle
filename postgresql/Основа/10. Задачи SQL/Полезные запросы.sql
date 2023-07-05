--Database size:
SELECT pg_database_size(current_database());
						
--And using pretty look
SELECT pg_size_pretty(pg_database_size(current_database()));	
									   
--Tables of this db:
SELECT table_name 
  FROM information_schema.tables
 WHERE table_schema NOT IN ('information_schema','pg_catalog');
									   

SELECT table_name 
  FROM information_schema.tables
 WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
   AND table_schema IN('public', 'myschema');
									   

--Table size
SELECT pg_relation_size('accounts');
SELECT pg_size_pretty(pg_relation_size('accounts'));
									   
									   
--Top of object size:
SELECT relname, relpages 
  FROM pg_class 
 ORDER BY relpages DESC; --or + LIMIT 1	
									   
-- Удаление одинаковых строк
DELETE FROM customers 
 WHERE ctid NOT IN (SELECT max(ctid) 
                      FROM customers 
					 GROUP BY customers.*);
									   

--Change type of column
ALTER TABLE customers ALTER COLUMN customer_id TYPE integer;
--But it doesn't work because the column had a varchar type of data. So we should use 'Using' statement:
ALTER TABLE customers ALTER COLUMN customer_id TYPE integer USING (customer_id::integer); --We also can use function in cast of type of column:
--: For example - Например, преобразуем поле customer_id обратно в varchar, но с преобразованием формата данных:
ALTER TABLE customers ALTER COLUMN customer_id TYPE varchar USING (customer_id || '-' || first_name);	
									   

--: View and end executable queries	
SELECT pid, 
       age(query_start, clock_timestamp()), 
       usename, 
	   query
  FROM pg_stat_activity
 WHERE query != '<IDLE>' 
   AND query NOT ILIKE '%pg_stat_activity%'
 ORDER BY query_start desc;	
SELECT * FROM pg_stat_activity;
				
				
--To end actualy query (You have to point id of proccess)
SELECT pg_cancel_backend(procpid);
SELECT pg_terminate_backend(procpid);	
				

--Поиск и изменение расположения экземпляра кластера
SHOW data_directory;
SET data_directory to new_directory_path;
SELECT typname, typlen from pg_type where typtype='b';
					
				
--Изменение настроек СУБД без перезагрузки --Changing RDMS settings without rebooting:
SELECT pg_reload_conf();
				
--Задержка времени выполнения серверных процессов:
SELECT pg_sleep(1);
				
SELECT oid from pg_class;
SELECT oid::regclass from pg_class, pg_sleep(10);
	
SELECT oid::regclass, pg_sleep(0.1) from pg_class;/*В этом же случае функция выполнится по одному разу для каждой строки набора данных. А именно столько раз, сколько таблиц имеется в вашей базе. */
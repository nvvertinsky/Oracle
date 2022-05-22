select t.value from v$parameter t where t.name = 'optimizer_mode'; -- режим работы оптимизатора
select * from user_segments t where t.segment_name = 'TABLE_NAME'; -- информация по сегменту (объекту БД)
select * from user_extents t where t.segment_name = 'TABLE_NAME'; -- информация по extent

-- ddl
alter system set optimizer_mode = all_rows; -- переключить режим работы оптимизатора в rule на уровне БД.
alter session set optimizer_mode = all_rows; -- переключить режим работы оптимизатора в rule на уровне сессии.


-- keep cache
select * from v$parameter where name like '%keep%';
alter system set db_keep_cache_size=50m; -- выделить 50 мб в SGA для keep_cache
alter table base storage (buffer_pool keep); -- блоки таблицы поместить в keep_cache
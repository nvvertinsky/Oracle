### Параллельная прямая загрузка
create table new_table parallel as select a.*,
					                      b.user_id,
					                      b.created user_created
									 from big_table a,
								          user_info b
									where a.owner = b.username;

### DML
````
alter session enable parallel dml; -- нужно сначала обязательно включать параллельный DML. 
select pdml_enabled from v$session where sid = sys_context('userenv','sid'); -- узнать включен ли параллельный DML
update big_table set status = 'done'; -- пишем просто DML который нужно выполнить параллельно
````

Ограничения:
  - Во время операции PDML триггеры не поддерживаются
  - Не поддерживается рефлексивная ссылочная целостность.
  - Нельзя получать доступ к таблице, модифицируемой PDML. Пока не будет сделан commit или rollback
  - Не поддерживаются отложенные ограничения
  - Если есть битовый индекс или столбец LOB, то выполнение PDML возможно только если таблица секционирована.
  - Не поддерживаются распределенные траназации.
  - Не поддерживаются кластеризованные таблицы
  
### Включить параллельное выполнение
alter table big_table parallel; -- позволяем ораклу самому динамически определять степерь параллелизма
alter table big_table parallel 4; -- при создании плана нас интересует степень параллелизма 4.

### Сессии
-- посмотреть сеансы (сессии) для параллельного выполнения
-- Если в системе параллельного выполнения не происходит, то сеансов параллельного выполнения в v$session вы не увидите
````
select sid,
       username,
       program
  from v$session
 where sid in (select sid
	         from v$px_session
	        where qcsid = 258);
````
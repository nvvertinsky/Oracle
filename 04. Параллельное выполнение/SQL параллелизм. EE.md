### Как включить: 

1. Через подсказки
````
select /*+ parallel*/
update /*+ parallel*/ 
````

2. Или указать опцию таблицы
````
alter table t parallel;   # Oracle сам определит в момент запроса, сколько параллельных процесов запускать
alter table t parallel 4; # При выполнении запросов, будет запущено 4 параллельных процесса
select count(*) from t;   # Выполняем запрос без подсказки
````

3. Если выполняем DML, то опции или хинта не достаточно. Нужно включить параллельный DML явно прямо в сессии. Это связанно с ограничениями ниже. 
````
alter session enable parallel dml;         # Сначала включить параллельный DML. 
select pdml_enabled 
  from v$session 
 where sid = sys_context('userenv','sid'); # Узнать включен ли параллельный DML
update t set status = 'done';              # Пишем просто DML

insert /*+ APPEND*/ into                   # Тоже будет выполнятся параллельно. 
````


### Параллельное выполнение DDL
````                
create table t2 parallel as select * from t; 
````

### Посмотреть сколько параллельных сессий породила сессия 258
````
select sid,
       username,
       program
  from v$session
 where sid in (select sid
	         from v$px_session
	        where qcsid = 258);
````


### Ограничения:
  - Не работают триггеры.
  - Нельзя получать доступ к таблице, модифицируемой PDML. Пока не будет сделан commit или rollback. Будет ошибка. 
  - Не поддерживаются отложенные ограничения
  - Не поддерживаются распределенные траназации.
  - Не поддерживаются кластеризованные таблицы
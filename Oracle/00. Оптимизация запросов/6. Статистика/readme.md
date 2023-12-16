### Когда собиралась статистика
````
select s.last_analyzed from dba_tables s where s.table_name = 'EMPLOYES';            -- По таблице
select ind.last_analyzed from dba_indexes ind where ind.index_name = 'EMPLOYEE_INX'; -- По индексу
````

### Сбор статистики: 
````
begin
  dbms_stats.gather_table_stats('HR','EMPLOYES');      -- По таблице
  dbms_stats.gather_index_stats('HR', 'EMPLOYEE_INX'); -- По индексу
end;
````


### Как понять что статистика устарела:
````
select s.STALE_STATS /*YES - Статистика устарела, NO - не устарела, null - Не собирается*/
  from dba_tab_statistics s 
 where s.TABLE_NAME = 'EMP'
````

### Включить параллельный сбор статистики
````
begin
  dbms_output.put_line(dbms_stats.get_prefs(pname => 'CONCURRENT'));
  dbms_stats.set_global_prefs(pname => 'CONCURRENT', pvalue => 'TRUE');
  dbms_stats.gather_table_stats(ownname => , tabname => );
end; 
````


### Динамический сбор статистики
Описание: Динамически собирает статистику по таблицам при выполнении запроса, по который не собрана статистика.

Как работает: Во время запроса сканирует определенное кол-во блоков таблицы (зависит от уровня). И собирает статистику по этим блокам.
              По умолчанию кол-во блоков для выборки 32. 

Как включить: 
  - Хинт: /*+DYNAMIC_SAMPLING*/
  - Параметр базы данных: OPTIMIZER_DYNAMIC_SAMPLING
  
Пример: 
````
select /*+DYNAMIC_SAMPLING(t 2)*/ from t;
````


Уровни: 
Level 0: Do not use dynamic sampling.
Level 1: Sample all tables that have not been analyzed if the following criteria are met: (1) there is at least 1 unanalyzed table in the query; (2) this unanalyzed table is joined to another table or appears in a subquery or non-mergeable view; (3) this unanalyzed table has no indexes; (4) this unanalyzed table has more blocks than the number of blocks that would be used for dynamic sampling of this table. The number of blocks sampled is the default number of dynamic sampling blocks (32).
Level 2: Apply dynamic sampling to all unanalyzed tables. The number of blocks sampled is two times the default number of dynamic sampling blocks.
Level 3: Apply dynamic sampling to all tables that meet Level 2 criteria, plus all tables for which standard selectivity estimation used a guess for some predicate that is a potential dynamic sampling predicate. The number of blocks sampled is the default number of dynamic sampling blocks. For unanalyzed tables, the number of blocks sampled is two times the default number of dynamic sampling blocks.
Level 4: Apply dynamic sampling to all tables that meet Level 3 criteria, plus all tables that have single-table predicates that reference 2 or more columns. The number of blocks sampled is the default number of dynamic sampling blocks. For unanalyzed tables, the number of blocks sampled is two times the default number of dynamic sampling blocks.
Levels 5, 6, 7, 8, and 9: Apply dynamic sampling to all tables that meet the previous level criteria using 2, 4, 8, 32, or 128 times the default number of dynamic sampling blocks respectively.
Level 10: Apply dynamic sampling to all tables that meet the Level 9 criteria using all blocks in the table.
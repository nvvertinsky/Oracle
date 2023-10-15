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
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
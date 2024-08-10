/*
Есть таблица t c колонкой id.
В id хранятся целые положительные числа. Например: 1,2,3,4,5,6,10,11,12
Необходимо найти все ID которые пропущены

*/

with t as (select 1 id from dual
           union all 
           select 2 from dual
           union all 
           select 3 from dual
           union all 
           select 4 from dual
           union all 
           select 5 from dual
           union all 
           select 6 from dual
           union all 
           select 10 from dual
           union all 
           select 11 from dual
           union all 
           select 12 from dual),
    t2 as (select level from dual connect by level <= 12)
select *
  from t2
 minus  
select *
  from t
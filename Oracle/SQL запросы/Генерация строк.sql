 select level as id_row /*,round(dbms_random.value(1,100)) as gen_num*/
   from dual
connect by level <= 5;

with r (n) as (select 1 n from dual 
               union all
               select n + 1 from r where n < 10
              )
select *
  from r;
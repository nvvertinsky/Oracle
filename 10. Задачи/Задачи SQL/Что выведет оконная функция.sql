with tst as (select 1 lvl from dual 
             union all
             select level lvl from dual connect by level <= 5)

select lvl
       ,sum(lvl) over (order by lvl)
       ,sum(lvl) over (partition by lvl order by lvl)
  from tst;
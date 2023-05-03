with tst as (select 1 lvl from dual 
             union all
             select level lvl from dual connect by level <= 5)

select lvl
       ,sum(lvl) over (order by lvl) -- Сначала возьмет первую строку и посчитает по ней сумму. Если есть одинаковые строки, то посчитает сумму по всем этим строкам.
                                     -- Затем берем следующую строку и прибавляем ее значение к общей сумме.
       ,sum(lvl) over (partition by lvl order by lvl) -- Тоже самое, только бьем еще на партиции
  from tst;
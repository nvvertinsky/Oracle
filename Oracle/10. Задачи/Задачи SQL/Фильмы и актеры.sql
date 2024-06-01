-- Вывести название фильма где играли актеры 1 и 2.

with fm as (select 'Мистер и миссис Смит' film, '1' actor from dual
            union all
            select 'Мистер и миссис Смит' film, '2' actor from dual
            union all
            select 'Бесславные ублюдки' film, '1' actor from dual
            union all
            select 'Игра на понижение' film, '2' actor from dual )
select fm.film
  from fm
 group by fm.film
having sum(case fm.actor when '1' then 1 else 0 end) > 0 and sum(case fm.actor when '2' then 1 else 0 end) > 0
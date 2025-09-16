-- Вывести название фильма где играли актеры 1 и 2.

with fm as (select 'Мистер и миссис Смит' film, '1' actor from dual
            union all
            select 'Мистер и миссис Смит' film, '2' actor from dual
            union all
            select 'Бесславные ублюдки' film, '1' actor from dual
            union all
            select 'Игра на понижение' film, '2' actor from dual )
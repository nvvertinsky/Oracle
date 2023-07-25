/*Рассказать про Flashback. Какие нужны права. Написать запрос с просмотром данных на 1 час назад.*/

grant flashback any table to nvvertinskiy;

select *
  from ua_ag as of scn timestamp_to_scn(sysdate - interval '1' hour)
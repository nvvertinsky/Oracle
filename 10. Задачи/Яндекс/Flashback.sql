/*Рассказать про Flashback. Какие нужны права. Написать запрос с просмотром данных на 1 час назад.*/

grant flashback any table to nvvertinskiy;

select * from t as of scn timestamp_to_scn(sysdate - (1/24))
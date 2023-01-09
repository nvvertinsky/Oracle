/*Проблема потерянного обновления. 
Эта проблема проявляется в том, что результаты успешно завершенной операции обновления одной транзакции 
перекрываются результатами выполнения другой транзакции.*/

create table lostupdate (val number(12));
insert into lostupdate (val) values (0);

-- Сессия 1
select val from lostupdate where val = 0;
/* 0 */

update lostupdate set val = val + 1 where val = 0;

-- Сессия 2 
select val from lostupdate where val = 0;
/* 0 */

update lostupdate set val = val + 2 where val = 0; -- update будет ожидать, когда завершиться транзакция в сессии 1

-- Сессия 1
commit;

-- Сессия 2
commit;

/*Если бы транзакции выполнялись последовательно, то значение поля было бы равно 3 
То есть явное влияние транзакций друг на друга.*/


-- Сессия 1
select val from lostupdate where val = 0;

/* 2 */

-- Сессия 1 не прнимает почему значение стало 2. Ведь она увеличивала значение тольна на 1.
-- Получается обновление Сессии 1 затерли.
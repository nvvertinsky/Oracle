/*Проблема потерянного обновления. 
Эта проблема проявляется в том, что результаты успешно завершенной операции обновления одной транзакции 
перекрываются результатами выполнения другой транзакции.*/

create table lostupdate (val number(12));
insert into lostupdate (val) values (0);

-- Сессия 1
update lostupdate set val = val + 1 where val = 0;

-- Сессия 2 
update lostupdate set val = val + 2 where val = 0; -- update будет ожидать, когда завершиться транзакция в сессии 1

-- Сессия 1
commit;

-- Сессия 2
commit;




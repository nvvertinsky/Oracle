-- Сессия 1 -- Проверить. скорее всего нужно проверять в транзакции
select val from tst where id = 1;
/* null */

-- Сессия 2 
update table tst set val = 'tstval' where id = 0;
commit;

-- Сессия 1
select val from tst where id = 1;
/* null */
-- В read commited мы бы увидели tstval потому что перечитали данные
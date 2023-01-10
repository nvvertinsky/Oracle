select val from tst;
/*
1  null
2  tstval
*/

-- Все транзакции уровня repeatable read

-- Транзакция 1 
update tst set val = tstval where val is null;

-- Транзакция 2
update tst set val = null where val = 'tstval';
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

-- Транзакция 1 
commit;

-- Транзакцция 2
commit;

-- Что будет?
select val from tst;
/*
1  tstval
2  null
*/

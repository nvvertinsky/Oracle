-- Сессия 1
update tst set val = 1 where val = 0;

-- Сессия 2
select val from tst where val = 0;
/* 1 */

-- Если уровень изоляции read uncomitted, то
-- сессия 2 увидит незафиксированные денные сессии 1
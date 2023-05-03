-- Описание: Разрешает читать незафиксированные данные.

-- Сессия 1
update tst set val = 1 where val = 0;

-- Сессия 2
select val from tst where val = 0;
/* 1 */

-- Сессия 1
rollback;
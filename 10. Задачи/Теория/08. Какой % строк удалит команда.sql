-- Какой процент строк удалит следующая команда если в таблице TBL значения в столбце id возрастают последовательно от 1 до 100?
delete from tbl where mod(id, 10) != 0


drop table tbl;
create table tbl (id number(12));
insert into tbl select level from dual connect by level <= 100; 
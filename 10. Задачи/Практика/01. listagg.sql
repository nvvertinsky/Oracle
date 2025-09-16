/*
Дана таблица TBL
DEPT    EMP
------------
Подр1	Сотр1
Подр2	Сотр2
Подр2	Сотр3

Нужно сгруппировать по полю DEPT и перечислить значения из EMP через запятую с сортировкой по убыванию:
DEPT    EMPS
------------------
Подр1  Сотр1
Подр2  Сотр3, Сотр2
*/

create table tbl(dept varchar2(240), emp varchar2(240));
insert into tbl values ('Подр1', 'Сотр1');
insert into tbl values ('Подр2', 'Сотр2');
insert into tbl values ('Подр2', 'Сотр3');

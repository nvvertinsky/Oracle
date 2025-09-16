drop table tbl;
create table tbl(id number(12), status varchar2(240));

insert into tbl values (1, 'ERROR');
insert into tbl values (2, 'ERROR');
insert into tbl values (3, 'ERROR');
insert into tbl values (4, 'OK');
insert into tbl values (5, 'ERROR');
insert into tbl values (6, 'OK');
insert into tbl values (7, 'OK');
insert into tbl values (8, 'ERROR');
insert into tbl values (9, 'OK');
insert into tbl values (10, 'OK');

/*
Выбрать две случайные записи из таблицы TBL со статусом ERROR
Таблица TBL
ID STATUS
--------------
1  ERROR
2  ERROR
3  ERROR
4  OK
5  ERROR
6  OK
7  OK
8  ERROR
9  OK
10 OK
*/

/*
Дана таблица TBL
 ID   PARENT_ID  NAME
 ----------------------
 10   [NULL]     Подр_4
 2    10         Подр_3
 3    10         Подр_2
Написать запрос для вывода дерева подразделений с сортировкой дочерних узлов по полю NAME
Подр_4
  Подр_2
  Подр_3
*/

drop table tbl;
create table tbl (id number(12), parent_id number(12), name varchar2(240));
insert into tbl values (10, null, 'Подр_4');
insert into tbl values (2, 10, 'Подр_3');
insert into tbl values (3, 10, 'Подр_2');

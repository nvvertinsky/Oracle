/*
Дана таблица T
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

drop table t;
create table t (id number(12), parent_id number(12), name varchar2(240));
insert into t values (10, null, 'Подр_4');
insert into t values (2, 10, 'Подр_3');
insert into t values (3, 10, 'Подр_2');


select lpad(' ', (level - 1) * 5) || name 
  from t
connect by prior id = parent_id
  start with parent_id is null
order sibling by name

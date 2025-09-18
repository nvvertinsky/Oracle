/*
Дана таблица T
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

create table t(dept varchar2(240), emp varchar2(240));
insert into t values ('Подр1', 'Сотр1');
insert into t values ('Подр2', 'Сотр2');
insert into t values ('Подр2', 'Сотр3');

select dept, 
       listagg(emps, ',') within group (order by emps desc)
  from t
 group by dept
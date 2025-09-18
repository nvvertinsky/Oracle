drop table t;
create table t(id number(12), status varchar2(240));

insert into t values (1, 'ERROR');
insert into t values (2, 'ERROR');
insert into t values (3, 'ERROR');
insert into t values (4, 'OK');
insert into t values (5, 'ERROR');
insert into t values (6, 'OK');
insert into t values (7, 'OK');
insert into t values (8, 'ERROR');
insert into t values (9, 'OK');
insert into t values (10, 'OK');

/*
Выбрать две случайные записи из таблицы T со статусом ERROR

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

select * 
  from t
 where t.status = 'ERROR'
 order by dbms_random.random

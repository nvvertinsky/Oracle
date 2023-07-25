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
8	 ERROR
9	 OK
10 OK
*/

select v1.id,
       v1.status
  from (select v.id,
               v.status,
               min(v.id) over () min_id, 
               max(v.id) over () max_id
          from (select rownum id,
                       tbl.status
                  from tbl 
                 where tbl.status = 'ERROR') v) v1
 where v1.id = round(dbms_random.value(v1.min_id, v1.max_id));

select round(dbms_random.value(1, 5)) from dual; 
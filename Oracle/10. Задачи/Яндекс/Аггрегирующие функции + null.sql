Дана таблица TBL
A
------
10
[NULL]

Что выведет запрос?


drop table tbl;
create table tbl (A number(12));
insert into tbl values (10);
insert into tbl values (null);

select count(a), -- 1
       count(*), -- 2
       sum(a)    -- 10
  from tbl;
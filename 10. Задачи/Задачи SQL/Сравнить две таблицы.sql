Задача: Необходимо написать запрос, который позволит понять, идентичны ли данные в двух таблицах. Порядок хранения данных в таблицах значения не имеет.

create table t10(a number, b number);
create table t20(a number, b number);

insert into t10 values (1, 1);
insert into t10 values (2, 2);
insert into t10 values (2, 2);
insert into t10 values (3, 3);
insert into t10 values (4, 4);

insert into t20 values (1, 1);
insert into t20 values (2, 2);
insert into t20 values (3, 3);
insert into t20 values (3, 3);
insert into t20 values (4, 4);
       
T1:
a   b
1   1
2   2
2   2
3   3
4   4

T2:
a   b
1   1
2   2
3   3
3   3
4   4



/*
Дата таблица TBL
A
-----
2
2
4
4
6
Что выведет запрос*/

select a, 
       rank() over(order by a) b, 
       dense_rank() over(order by a) c
  from tbl
order by a


2	1	1
2	1	1
4	3	2
4	3	2
6	5	3



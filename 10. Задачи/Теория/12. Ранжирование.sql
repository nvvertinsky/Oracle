/*

Дата таблица TBL

A
-----
2
2
4
4
6

Что выведет запрос ниже?

*/


select a, 
       rank() over(order by a) b, 
       dense_rank() over(order by a) c
  from tbl
 order by a
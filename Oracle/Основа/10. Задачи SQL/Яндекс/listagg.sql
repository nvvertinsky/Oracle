/*
Дана таблица TBL
DEPT    EMP
------------
Подр1	Сотр1
Подр2	Сотр2
Подр2	Сотр3

Нужно сгруппировать по полю DEPT и перечислить значения из EMP через запятую с сортировкой по убыванию:
DEPT    EMPS
------------------
Подр1	Сотр1
Подр2	Сотр3, Сотр2
*/

select listagg(emp, ', ') within group (order by emp desc) 
  from tbl
 group by dept;
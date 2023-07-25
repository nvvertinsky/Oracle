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

select lpad('  ', level*2) || name
  from tbl
 start with parent_id is null 
connect by prior parent_id = id
 order siblings by name;  
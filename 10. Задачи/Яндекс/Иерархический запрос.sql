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

drop table tbl;
create table tbl (id number(12), parent_id number(12), name varchar2(240));
insert into tbl values (10, null, 'Подр_4');
insert into tbl values (2, 10, 'Подр_3');
insert into tbl values (3, 10, 'Подр_2');


select lpad(' ', level * 2) || tbl.name
  from tbl
 start with tbl.parent_id is null
connect by prior tbl.id = tbl.parent_id
  order siblings by name; 



Объяснение: 
  1. В конструкции start with мы задаем с какой строки мы будем начинать.
  2. Взяли первую строку, увидели что ID = 10 и с помощью connect by prior tbl.id = tbl.parent_id присоеденяем всех у кого parent_id = 10. 
  3. lpad. В первом параметре мы указываем чем будет делать отступ (пробел например). Во втором параметре сколько этих символов (пробелов) мы укажем. Умножаем на 2, потому что в первой строке 1. А 1 пробел не красиво.
  4. siblings мы говорим Ораклу что нужно сортировать в рамках level (уровня). А не весь получившийся результат.
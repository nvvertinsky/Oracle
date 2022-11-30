 select s.employee_id,
        lpad(' ', (level - 1/*Для корня будет не нужны отступы*/) * 5, ' ') || s.first_name || chr(32) || s.last_name nm,
        sys_connect_by_path(s.first_name || chr(32) || s.last_name, '/') path,
        CONNECT_BY_ISLEAF,
        prior s.last_name parent,
        CONNECT_BY_ROOT s.last_name root,
        level
   from employees s
connect by prior employee_id = manager_id
  start with s.manager_id is null
  order siblings by s.first_name;
  
/*
start with s.manager_id is null - начинаем цикл с Директора

prior - Оракл находит первую запись, удовлетворяющую условию в START WITH. Затем нужно искать следующую запись. prior employee_id говорит о том, что нужно двигаться в сторону подчиненного. То есть в сторону потомков.

level - уровень вложенности. Для директора 1, для его подчиненного 2, для его подчиненного 3 итд

SIBLINGS - сортировка в рамках в пределах одного уровня (level) 

CONNECT_BY_ISLEAF - Если есть потомки – проставится 0. Иначе 1.

CONNECT_BY_ROOT - ссылается на корневую запись, т.е. на самую первую в выборке.
*/
  
/*
1	100	Steven King	/Steven King	1
2	121	     Adam Fripp	/Steven King/Adam Fripp	2
3	185	          Alexis Bull	/Steven King/Adam Fripp/Alexis Bull	3
4	187	          Anthony Cabrio	/Steven King/Adam Fripp/Anthony Cabrio	3
5	131	          James Marlow	/Steven King/Adam Fripp/James Marlow	3
6	186	          Julia Dellinger	/Steven King/Adam Fripp/Julia Dellinger	3
7	129	          Laura Bissot	/Steven King/Adam Fripp/Laura Bissot	3
8	130	          Mozhe Atkinson	/Steven King/Adam Fripp/Mozhe Atkinson	3
9	184	          Nandita Sarchand	/Steven King/Adam Fripp/Nandita Sarchand	3
10	132	          TJ Olson	/Steven King/Adam Fripp/TJ Olson	3


*/

-- Те же самые самые запросы, только с рекурсивным WITH
with emp_data(employee_id, nm, manager_idm, lvl) as (select emp.employee_id,
                                                            emp.first_name || chr(32) || emp.last_name nm,
                                                            emp.manager_id,
                                                            1 lvl
                                                       from employees emp
                                                      where emp.manager_id is null
                                                     union all
                                                     select emp.employee_id,
                                                            emp.first_name || chr(32) || emp.last_name nm,
                                                            emp.manager_id,
                                                            ed.lvl + 1 lvl
                                                       from employees emp,
                                                            emp_data ed
                                                      where emp.manager_id = ed.employee_id)
search depth first by nm set order_by /*Аналог siblings при connect by */
select employee_id, 
       lpad(' ', (lvl - 1/*Для корня будет не нужны отступы*/) * 5, ' ') || nm, 
       manager_idm, 
       lvl
  from emp_data
 order by order_by;



-- 01. Стартуем с записи 113.
-- 02. prior говорит о том, что нужно двигаться в сторону директора. Поэтому ищем руководителя, потом его руководителя, потом директора.
 select lpad(' ', (level - 1 )* 5, ' ') || s.first_name || chr(32) || s.last_name nm, 
        level
   from employees s
connect by employee_id = prior manager_id
  start with s.employee_id = 113;
 
/*
1	    Luis Popp	1
2	         Nancy Greenberg	2
3	              Neena Kochhar	3
4	                   Steven King	4
*/


-- Выявляем петли: 
 with ccle as (select 1 c_id, 2 next_id from dual
               union all
               select 2 c_id, 3 next_id from dual
               union all
               select 3 c_id, 1 next_id from dual)
 select ccle.c_id,
        ccle.next_id,
        connect_by_iscycle as cycl -- 0 - норм строка, 1 - строка которая приводит к зацикливанию
   from ccle
connect by nocycle prior ccle.next_id = ccle.c_id
  start with ccle.c_id = 1
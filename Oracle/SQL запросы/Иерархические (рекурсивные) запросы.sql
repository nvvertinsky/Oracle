 select s.employee_id,
        lpad(' ', (level - 1/*Для корня будет не нужны отступы*/) * 5, ' ') || s.first_name || chr(32) || s.last_name nm,
        sys_connect_by_path(s.first_name || chr(32) || s.last_name, '/') path,
        level
   from employees s
connect by prior employee_id = manager_id
  start with s.manager_id is null;
  
/*
start with s.manager_id is null - начинаем цикл с Директора

prior - Оракл находит первую запись, удовлетворяющую условию в START WITH. Затем нужно искать следующую запись. prior employee_id говорит о том, что нужно двигаться в сторону подчиненного. То есть в сторону потомков.

level - уровень вложенности. Для директора 1, для его подчиненного 2, для его подчиненного 3 итд
*/
  
/*
1	100	Steven King	/Steven King	1
2	101	     Neena Kochhar	/Steven King/Neena Kochhar	2
3	108	          Nancy Greenberg	/Steven King/Neena Kochhar/Nancy Greenberg	3
4	109	               Daniel Faviet	/Steven King/Neena Kochhar/Nancy Greenberg/Daniel Faviet	4
5	110	               John Chen	/Steven King/Neena Kochhar/Nancy Greenberg/John Chen	4
6	111	               Ismael Sciarra	/Steven King/Neena Kochhar/Nancy Greenberg/Ismael Sciarra	4
7	112	               Jose Manuel Urman	/Steven King/Neena Kochhar/Nancy Greenberg/Jose Manuel Urman	4
8	113	               Luis Popp	/Steven King/Neena Kochhar/Nancy Greenberg/Luis Popp	4

*/


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



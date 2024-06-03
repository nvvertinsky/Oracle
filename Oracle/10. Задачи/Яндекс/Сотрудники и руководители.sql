1. Какая средняя ЗП у руководителей?
2. Сколько в среднем сотрудников в подчинении у руководителя?
3. У кого из сотрудников ЗП больше чем у руководителя?




select avg(boss.salary)
  from employees boss
 where boss.employee_id in (select emp.manager_id
                              from employees emp
                             where emp.manager_id is not null
                             group by emp.manager_id) 

select avg(count(emp.employee_id))
  from employees emp
 group by emp.manager_id


select *
  from employees emp,
       employees boss
 where boss.employee_id = emp.manager_id
   and emp.salary > boss.salary

1. Какая средняя ЗП у руководителей?
2. Сколько в среднем сотрудников в подчинении у руководителя?
3. У кого из сотрудников ЗП больше чем у руководителя?

select avg(v.salary)
  from emp t
 where t.emp_id in (
select distinct mng.mng_id
  from emp mng)


select count(*)
  from emp t
 group by t.mng_id

select *
  from emp e,
       emp m
 where e.mng_id = m.emp_id
   and e.salary > m.salary
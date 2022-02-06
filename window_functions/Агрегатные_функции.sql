select employees.*,
       min(salary) over (partition by department_id) as min_dep_sal
  from employees
  
select employees.*,
       max(salary) over (partition by department_id) as max_dep_sal
  from employees

select employees.*,
       avg(salary) over (partition by department_id) as avg_dep_sal
  from employees

select employees.*,
       count(employee_id) over (partition by department_id) as cnt_dep_employee
  from employees

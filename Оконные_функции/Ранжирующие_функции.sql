select row_number() over (order by employees.employee_id) as row_number,
       employees.*
  from employees;

select rank() over (partition by employees.job_id order by employees.salary) as rank,
       employees.*
  from employees;

select dense_rank() over (partition by employees.job_id order by employees.salary) as dense_rank,
       employees.*
  from employees;

select ntile(10) over (partition by employees.job_id order by employees.salary) as ntile,
       employees.*
  from employees;

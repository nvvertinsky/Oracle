-- Предполагаемый план
-- 01. IDE.
-- 02. Команды
explain plan set statement_id = 'MY_QUERY' for select * from employees; 
select * from dbms_xplan.display(format =>'ADVANCED + partition');

-- Реальный план
-- 01. Autotrace
set autotrace traceonly;
select * from employees;
  
-- 02. v$sql_plan
select /*MY*/ * from employees;
select * from v$sql t where lower(t.sql_fulltext) like lower('%/*MY*/%');
select * from v$sql_plan t where t.sql_id = '';
select * from table(dbms_xplan.display_cursor(sql_id => '', format => 'ALLSTATS ADVANCED'));

-- 03. display_workload_repository
select * from dbms_xplan.display_workload_repository(sql_id => '', format => 'ALLSTATS ADVANCED +cost +bytes');

-- 04. В HTML
select dbms_sqltune.report_sql_monitor(sql_id => '', type => 'HTML', report_level => 'ALL') report from dual;


-- 05. Скрипт
begin
  execute immediate 'alter session set statistics_level = ALL';
    
  for test in (select * from hr.employees t where t.employee_id = 103) 
  loop
    null;
  end loop;
    
  for x in (select p.plan_table_output
              from table(dbms_xplan.display_cursor(null, 
                                                   null, 
                                                   'ALLSTATS ADVANCED')) p) 
  loop
    dbms_output.put_line(x.plan_table_output);
  end loop;
rollback;
end;

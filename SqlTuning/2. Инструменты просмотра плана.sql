- Средства, позволяющие получить предполагаемый план:
    - Toad, SQL Navigator, PL/SQL Developer.
    - explain plan set statement_id = 'MY_QUERY' for select * from dual; select * from dbms_xplan.display();
- Средства, позволяющие получить реальный план:
    - Утилита Autotrace. В SQLPLUS вводим: set autotrace traceonly; select * from dual; (если запрос еще не выполнялся)
    - Получаем SQL_ID: Select sql_id from v$sql where sql_fulltext like '%уникальный фрагмент текста запроса%';. И затем этот SQL_ID в представлении Select * from v$sql_plan where sql_id='SQL_ID';. Затем select * from table(dbms_xplan.display_cursor(sql_id => SQL_ID))
    - Утилита dbms_sqltune.report_sql_monitor(SQL_ID);
    
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
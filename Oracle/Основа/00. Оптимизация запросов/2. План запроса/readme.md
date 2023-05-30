### Показатели:
  - Operation - Имя операции, выполняемой на этом шаге
  - name - Имя объекта над которым выполняется операция
  - Cost – Стоимость операции по оценке оптимизатора. Значение этого столбца не имеет какой-либо конкретной единицы измерения. Это взвешенное значение, используемое для сравнения затрат на выполнение планов
  
  - Cardinality – Это ожидаемое кол-во строк, получаемых при выполнении шага (операции)
  - CPU Cost — Затраты процессора на операцию по оценке оптимизатора. Значение этого столбца пропорционально количеству машинных циклов
  - IO Cost — Стоимость операций ввода-вывода по оценке оптимизатора. Значение этого столбца пропорционально количеству блоков данных, прочитанных операцией
  
  - Temp Space – показатель использования дискового пространства. Если дисковое пространство используется (при нехватке оперативной памяти для выполнения запроса, как правило, для проведения сортировок, группировок и т.д.), то с большой вероятностью можно говорить о неэффективности запроса


### Предполагаемый план
  1. IDE. Например F5 в PL/SQL Developer
  
  2. EXPLAIN PLAN. Вывод только плана.
  ````
  explain plan set statement_id = 'MY_QUERY' for select * from employees; 
  select * from table(dbms_xplan.display(statement_id => 'MY_QUERY', format => 'ADVANCED'));
  ````

### Реальный план
  1. Autotrace (только в SQL plus). План + статистика.
  ````
  set autotrace traceonly;
  select * from employees;
  set autotrace off;
  ````
  
  2. v$sql_plan + dbms_xplan
  ````
  select /*MY*/ * from employees;
  select * from v$sql t where lower(t.sql_fulltext) like lower('%/*MY*/%');
  select * from v$sql_plan t where t.sql_id = '';
  
  -- Получать статистику реального выполнения, а не только предполагаемого.
  alter session set statistics_level = ALL
  select * from table(dbms_xplan.display_cursor(sql_id => '', format => 'ALLSTATS ADVANCED'));
  
  -- Или вместо statistics_level указать хинт
  select /*gather_plan_statistics hi*/ * from table(dbms_xplan.display_cursor(sql_id => '', format => 'ALLSTATS ADVANCED'));
  ````

  3. display_workload_repository (доступен только в Enterprise + подключена опция Diagnostics and Tuning option)
  ````
  -- Проверяем что пакет куплен и установлен
  show parameter control_management_pack_access
  select * from dbms_xplan.display_workload_repository(sql_id => '', format => 'ALLSTATS ADVANCED +cost +bytes');
  ````
  
  4. В HTML (доступен только в Enterprise + подключена опция Diagnostics and Tuning option)
  ````
  -- Проверяем что пакет куплен и установлен
  show parameter control_management_pack_access
  
  select dbms_sqltune.report_sql_monitor(sql_id => '', type => 'HTML', report_level => 'ALL') report from dual;
  ````
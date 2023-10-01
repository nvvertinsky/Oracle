### Показатели:
  - Operation - Имя операции, выполняемой на этом шаге
    - TEMP TABLE TRANSFORMATION - Создание временной таблицы
    - LOAD AS SELECT - загрузка данных во временную таблицу
    - CURSOR DURATION MEMORY - Для хранения результатов во временной таблице используется память, а не диск
  - name - Имя объекта над которым выполняется операция
  - Cost – Стоимость операции по оценке оптимизатора. Значение этого столбца не имеет какой-либо конкретной единицы измерения. Это взвешенное значение, используемое для сравнения затрат на выполнение планов
  
  - Cardinality (Rows) – Это кол-во строк, возвращаемых операцией
  - CPU Cost — Затраты процессора на операцию по оценке оптимизатора. Значение этого столбца пропорционально количеству машинных циклов
  - IO Cost — Стоимость операций ввода-вывода по оценке оптимизатора. Значение этого столбца пропорционально количеству блоков данных, прочитанных операцией
  
  - Temp Space – показатель использования дискового пространства. Если дисковое пространство используется (при нехватке оперативной памяти для выполнения запроса, как правило, для проведения сортировок, группировок и т.д.), то с большой вероятностью можно говорить о неэффективности запроса


### Предполагаемый план
  1. IDE. Например F5 в PL/SQL Developer
  
  2. EXPLAIN PLAN. Вывод только плана.
  ````
  explain plan set statement_id = 'MY_QUERY' for select * from employees; 
  select * from table(dbms_xplan.display(null, 'MY_QUERY', 'ALLSTATS'));
  ````

### Реальный план
  1. Autotrace (только в SQL plus). План + статистика.
  ````
  set autotrace traceonly;
  select * from employees;
  set autotrace off;
  ````
  
  2. dbms_xplan.display_cursor
  ````
  alter session set statistics_level = ALL;                                    # Сбор статистики по реальному плану запроса. Или указать хинт /*gather_plan_statistics*/
  select /*MY*/ * from employees;                                              # Выполняем запрос
  select * from v$sql t where lower(t.sql_text) like lower('%MY%');            # Находим его sql_id
  select * from table(dbms_xplan.display_cursor('sql_id', null, 'ALLSTATS'));  # Получаем план запроса. Для получения A колонок, нужно дождаться полного выполнения запроса, без доп. фетча строк.
  ````
  
  3. v$sql_plan
  ````
  select * from v$sql_plan t where t.sql_id = '2chv128hyhurq';
  ````
  
  4. display_workload_repository. Для Oracle11g используйте dbms_xplan.display_awr. Обязательно нужна лицензия на Oracle Diagnostic Pack
  ````
  -- Проверяем что пакет куплен и установлен
  show parameter control_management_pack_access
  select * from dbms_xplan.display_workload_repository(sql_id => '', format => 'ALLSTATS ADVANCED +cost +bytes');
  ````
  
  5. В HTML. Обязательно нужна лицензия на Oracle Diagnostic Pack.
  ````
  -- Проверяем что пакет куплен и установлен
  show parameter control_management_pack_access
  
  select dbms_sqltune.report_sql_monitor(sql_id => '', type => 'HTML', report_level => 'ALL') report from dual;
  ````
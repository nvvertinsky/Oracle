-- 1. Собрать статистику. 
  -- ALL_TABLES (DBA_TABLES) и ALL_INDEXES (DBA_INDEXES) столбец Last_Analyzed время последнего сбора статистики.
  -- Собрать статистику для таблицы: 
  begin
    DBMS_STATS.GATHER_TABLE_STATS ('HR','EMPLOYES');
  end;
  begin
    DBMS_STATS.GATHER_INDEX_STATS('HR', 'EMPLOYEE_INX');
  end;
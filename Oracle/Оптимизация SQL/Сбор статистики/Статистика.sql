select s.last_analyzed from dba_tables s where s.table_name = 'EMPLOYES';
select ind.last_analyzed from dba_indexes ind where ind.index_name = 'EMPLOYEE_INX';

begin
  dbms_stats.gather_table_stats('HR','EMPLOYES');
end;

begin
  dbms_stats.gather_index_stats('HR', 'EMPLOYEE_INX');
end;
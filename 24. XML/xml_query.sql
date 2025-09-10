-- ��������� XML ��� ������ ������ DBMS_XMLGEN

-- ��������� XML ��������� ��� ������ �������� SQL �������.
select dbms_xmlgen.getXML('select object_name, object_type
                             from all_objects
                            where rownum < 4') xml
  from dual;

-- ��������� XML ��� ������ PLSQL � ���������� � ���� clob ������� ��.
create table temp_clob_tab(result clob);

declare
  qryCtx dbms_xmlgen.ctxHandle;
  l_result clob;
begin
  qryCtx := dbms_xmlgen.newContext('select * from employees where employee_id = 101');
  dbms_xmlgen.setRowTag(qryCtx, 'EMPLOYEE');
  dbms_xmlgen.setRowSetTag(qryCtx, 'EMPLOYEES');
  l_result := dbms_xmlgen.getXML(qryCtx);
  insert into temp_clob_tab values (l_result);
  dbms_xmlgen.closeContext(qryCtx);
end;


-- ������������� ������������ XML ��� ������ ����� � ������ fetch
declare
  qryCtx dbms_xmlgen.ctxHandle;
  l_result clob;
begin
  qryCtx := dbms_xmlgen.newContext('select * from employees where rownum < 16');
  dbms_xmlgen.setMaxRows(qryCtx, 3);
  
  loop
    l_result := dbms_xmlgen.getXML(qryCtx);
    exit when dbms_xmlgen.getNumRowsProcessed(qryCtx) = 0;
    insert into temp_clob_tab values (l_result);
  end loop;
  
  dbms_xmlgen.closeContext(qryCtx);
end;


-- ��������� XML �� �� � ������� �������. (��������� ����� ������������������ ��� ����� dbms_xmlgen, �.� �����)

-- XMLElement - ������� XML �������� �� ����������� ������
-- XMLAttributes - ������ �������� ��� XML ���������
-- XMLForest - ��������� ������ XML ��������� �� ������ ���������.

select XMLElement("Emp", XMLAttributes(emp.first_name || ' ' || emp.last_name as "name"), xmlforest(emp.hire_date, 
                                                                                                    emp.department_id as "department",
                                                                                                    emp.job_id,
                                                                                                    emp.salary)) as "RESULT"
  from employees emp
 where emp.department_id = 20;

--1:45:59
-- XMLConcat - ������� XML-�������� �� ������ ������� ��������� XMLType
select XMLConcat(XMLElement("first", emp.first_name),
                 XMLElement("last", emp.last_name),
                 XMLElement("job", emp.job_id))
  from employees emp
 where emp.employee_id = 20;


-- XMLAgg - ���������� ��������� XML ��������� � ��������� �� ����������� 
select XMLElement("Department", XMLAttributes(dept.department_name as "name"), 
                 (select XMLAgg(XMLElement("emp", XMLAttributes(emp.last_name as "name"),
                   (select XMLAgg(XMLElement("PastJobs", XMLAttributes(hist.job_id as "job")))
                     from job_history hist 
                    where hist.employee_id = emp.employee_id)))
                   from employee emp
                  where emp.department_id = dept.department_id)) as "dept_list"
 from departments dept
where department_id = 90;
 
  


-- XMLSerialize - ����������� XMLType � ������, CLOB ��� BLOB � ������������ �������������� � �������� ���������
-- XMLComment - ������� XML- �����������
-- XMLCDATA - ������� ������ CDATA

select XMLSerialize(DOCUMENT XMLElement("PurchaseOrder", XMLElement("Address", 
                                                                    XMLComment('Some Comment'),
                                                                    XMLCDATA('Address'),
                                                                    XMLElement("City", 'Moscow'),
                                                                    XMLElement("Country", 'Russia'))) as clob indent) as result
  from dual;


-- SYS_XMLGEN - SQL ������� ��� ��������� XML ���������� (������ ������ dbms_xmlgen) 
select sys_xmlgen() as deptxml
  from depertments dept
 where dept.department_id = 20;

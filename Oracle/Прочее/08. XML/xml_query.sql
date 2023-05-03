-- Генерация XML при помощи пакета DBMS_XMLGEN

-- Получение XML документа при помощи простого SQL запроса.
select dbms_xmlgen.getXML('select object_name, object_type
                             from all_objects
                            where rownum < 4') xml
  from dual;

-- Генерация XML при помощи PLSQL и сохранение в поле clob таблицы БД.
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


-- Постраниченое формирование XML при помощи цикла в режиме fetch
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


-- Генерация XML из БД с помощью функций. (Считаются более предподчтительными чем пакет dbms_xmlgen, т.к новее)

-- XMLElement - создает XML элементы из реляционных данных
-- XMLAttributes - задает атрибуты для XML элементов
-- XMLForest - формирует группу XML элементов из списка выражений.

select XMLElement("Emp", XMLAttributes(emp.first_name || ' ' || emp.last_name as "name"), xmlforest(emp.hire_date, 
                                                                                                    emp.department_id as "department",
                                                                                                    emp.job_id,
                                                                                                    emp.salary)) as "RESULT"
  from employees emp
 where emp.department_id = 20;

--1:45:59
-- XMLConcat - создает XML-фрагмент на основе массива элементов XMLType
select XMLConcat(XMLElement("first", emp.first_name),
                 XMLElement("last", emp.last_name),
                 XMLElement("job", emp.job_id))
  from employees emp
 where emp.employee_id = 20;


-- XMLAgg - группирует коллекцию XML элементов с возможной их сотрировкой 
select XMLElement("Department", XMLAttributes(dept.department_name as "name"), 
                 (select XMLAgg(XMLElement("emp", XMLAttributes(emp.last_name as "name"),
                   (select XMLAgg(XMLElement("PastJobs", XMLAttributes(hist.job_id as "job")))
                     from job_history hist 
                    where hist.employee_id = emp.employee_id)))
                   from employee emp
                  where emp.department_id = dept.department_id)) as "dept_list"
 from departments dept
where department_id = 90;
 
  


-- XMLSerialize - Преобразует XMLType в строку, CLOB или BLOB с возможностью форматирования и указания кодировки
-- XMLComment - создает XML- комментарий
-- XMLCDATA - создает секцию CDATA

select XMLSerialize(DOCUMENT XMLElement("PurchaseOrder", XMLElement("Address", 
                                                                    XMLComment('Some Comment'),
                                                                    XMLCDATA('Address'),
                                                                    XMLElement("City", 'Moscow'),
                                                                    XMLElement("Country", 'Russia'))) as clob indent) as result
  from dual;


-- SYS_XMLGEN - SQL функция для генерации XML документов (аналог пакета dbms_xmlgen) 
select sys_xmlgen() as deptxml
  from depertments dept
 where dept.department_id = 20;

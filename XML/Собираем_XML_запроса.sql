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
-- XMLAgg - группирует коллекцию XML элементов с возможной их сотрировкой 
-- XMLSerialize -
-- XMLComment - создает XML- комментарий
-- XMLCDATA - 


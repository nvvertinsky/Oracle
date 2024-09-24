/*Назвать примеры json-функций. Написать пример выбора значения поля b из JSON-объекта {"a":{"b": 123}}*/

declare
  l_json_clob clob := '{"a":{"b": 123}}';
  l_json json_object_t;
begin 
  l_json := json_object_t.parse(l_json_clob);
  
  dbms_output.put_line(l_json.get_object('a').get_string('b'));

end; 
/
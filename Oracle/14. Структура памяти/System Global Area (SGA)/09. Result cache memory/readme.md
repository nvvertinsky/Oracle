# Result Cache Memory (Память кэша результатов)

### Описание 
  - При первом выполнеии SQL запроса или PL/SQL функции сохраняет результаты SQL запроса или результаты работы PL/SQL функции в кеш
  - При повторном выполнении берем данные из кеша.

### Состоит: 
  - Кэш результатов SQL-запросов
  - Кэш результатов PL/SQL-функций

### Параметры: 
  - Распределяется автоматически в зависимости от MEMORY_TARGET или SGA_TARGET. 
  - Если параметры выше не заданы, то ручное изменение параметра RESULT_CACHE_MAX_SIZE. 
  - 0 = значит выключен.
  

### Режим работы (параметр RESULT_CACHE_MODE): 
  - MANUAL - помещаем в кеш только при наличии опции RESULT_CACHE
  - FORCE - БД будет пытаться использовать кэш для всех результатов везде, где может. Даже RESULT_CACHE не нужно указывать
  

### Как пользоваться: 
````
select /*+ result_cache +*/
       department_id, 
	   avg(salary)
  from hr.employees
 group by department_id;
````



### А если стоит FORCE, то как обойти
````
select /*+ no_result_cache +*/
       department_id, 
	   avg(salary)
  from hr.employees
 group by department_id;
````

### Объекты для аналитики: 
  - Пакет DBMS_RESULT_CACHE - Проверка состояния, сбрасывание содержимого
  - V$RESULT_CACHE_STATISTICS - Настройки кеша и статистика о используемой памяти
  - V$RESULT_CACHE_OBJECTS - Список всех находящихся в кеше объетов
  - V$RESULT_CACHE_DEPENDENCY - 
  - V$RESULT_CACHE_MEMORY - 
  
### Пример использования статистики: 
````
select type, status, name from v$result_cache_objects; -- какие результаты находятся в кэше
````
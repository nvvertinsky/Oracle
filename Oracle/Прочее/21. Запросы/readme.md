### Получить значение переменной привязки
````
select r.name,
       r.last_captured,
       r.value_string
  from v$sql_bind_capture r
 where r.SQL_ID = '1ngw1nr5s400s';
````


### Отследить в каком месте в коде происходит commit
````
ALTER SESSION DISABLE COMMIT IN PROCEDURE; -- Если в pl/sql коде будет commit, то будет исключение. Захватывает даже автономные процедуры.
````
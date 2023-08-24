### Какой функционал есть в БД
````
select * from v$option;
````


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

### Апостроф в каждой строке Excel
```
Sub apostrof()
  Dim cell As Range
  Application.ScreenUpdating = False
  
  For Each cell In Selection.SpecialCells(xlCellTypeConstants)
    cell.Value = " '" & cell.Value & "'"
  Next
  
  Application.ScreenUpdating = True
End Sub
```


### Прогресс выполнения
````
select round((t.sofar /*Единиц выполненно на данны момент */ / t.totalwork /*Общее кол-во единиц работы*/) * 100, 2) || '%' progress,
       t.sofar,
       t.totalwork,
       t.opname,
       t.start_time,
       t.time_remaining,
       t.last_update_time,
       t.message,
       t.OPNAME
  from v$session_longops t
 order by t.last_update_time desc;
````
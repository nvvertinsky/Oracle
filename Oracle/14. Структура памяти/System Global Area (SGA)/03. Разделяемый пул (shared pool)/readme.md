### Состоит:
  - Библиотечного кеша
  - 

### Управляется: 
  - Параметр SHARED_POOL_SIZE

### Здесь находятся: 
````
select * from v$sql;
select * from v$sql_plan;
````


### Очистить разделяемый пул
````
alter system flush shared_pool;
````
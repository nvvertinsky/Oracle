# Postresql

# Установка и запуск в docker

### Запускаем контейнер с 14-й версией
```
docker run -p 5432:5432 --name mypgdb14 -e POSTGRES_PASSWORD=mypass -d postgres:14
# mypgdb14 - название pg-кластера
# mypass - пароль
# 5432:5432 - проброс стандартного порта с 5432 на 5432
# postgres:14 - версия Pg


docker exec -it mypgdb14 /bin/bash             # Подключится к консоли
docker exec -it mypgdb14 psql -U postgres      # Подключаемся к консоли и запустить psql
psql -d databaseName -U userName -h ip -p port # psql подключится к удаленной БД.
\q                                             # Отключится от psql
```

### Администрируем контейнер
```
docker ps              # Проверяем, что контейнер запущен
docker top oracle21xe  # Запущенные процессы внутри контейнера
```

### Начало работы в postgresql
```
create user mydb_owner password 'mypass'; # Создаем пользователя
create database mydb owner mydb_owner;    # Создаем отдельную БД
create schema my_schema;                  # Создаем схему
```

### Системные справочники
```
select datname, datistemplate, datallowconn, datconnlimit from pg_database;                                     # Список всех баз данных
select current_database();                                                                                      # Текущая база данных
select schema_name from information_schema.schemata;                                                            # Все схемы 
select table_name from information_schema.tables where table_schema not in ('information_schema','pg_catalog'); # Список таблиц в схемах
select usename, usesuper, usecreatedb from pg_catalog.pg_user;                                                  # Список пользователей
```
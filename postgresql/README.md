# Postresql

# Установка и запуск в docker

### Запускаем контейнер с 14-й версией
```
docker run -p 5434:5432 --name mypgdb14 -e POSTGRES_PASSWORD=mypass -d postgres:14
# mypgdb14 - название pg-кластера
# mypass - пароль
# 5434:5432 - проброс стандартного порта на 5434
# postgres:14 - версия Pg
```

```
docker ps 				 				  	   # Проверяем, что контейнер запущен
docker exec -it mypgdb14 				       # Подключится к консоли
docker exec -it mypgdb14 psql -U postgres      # Подключаемся к консоли и запустить psql
psql -d databaseName -U userName -h ip -p port # psql -d databaseName -U userName -h ip -p port
\q									           # Отключится от psql
```

```

```

/*
Какие основные бывают:

1. B-дерево
2. Уникальный
3. Битовый. Хорош, когда столбец малоселективен. Не стоит создавать, если индексируемые данные часто изменяются. Потому что транзакции будут выполняться дольше. Часто используются для Y N
4. Основанный на функций
5. Индекс кластера

Когда стоит создавать:
 - Когда поля часто используются в where вместе с =. Например where id = 1 или [tbl1.id](http://tbl1.id) = tbl2.id

Когда не стоит создавать:
 - Когда таблица маленькая. То есть помещается в оперативную память за одну операцию чтения

Где стоит создавать:
 - В tablespace который находится на другом физическом диске от tablespace таблицы.
*/
# Оптимизатор


## Переписывание запроса


### Факторизация соединения UNION ALL
Пример. Где оптимизатор по идее должен сканировать таблицу t1 два раза.
````
SELECT t1.c1, t2.c2
  FROM t1, t2, t3
 WHERE t1.c1 = t2.c1 
   AND t1.c1 > 1
   AND t2.c2 = 2
   AND t2.c2 = t3.c2 
 UNION ALL
SELECT t1.c1, t2.c2
  FROM t1, t2, t4
 WHERE t1.c1 = t2.c1 
   AND t1.c1 > 1
   AND t2.c3 = t4.c3;
````

Но оптимизатор может переписать запрос, чтобы запросить таблицы всего один раз.
````
SELECT t1.c1, VW_JF_1.item_2
  FROM t1, (SELECT t2.c1 item_1, t2.c2 item_2
            FROM   t2, t3
            WHERE  t2.c2 = t3.c2 
            AND    t2.c2 = 2                 
            UNION ALL
            SELECT t2.c1 item_1, t2.c2 item_2
            FROM   t2, t4 
            WHERE  t2.c3 = t4.c3) VW_JF_1
 WHERE t1.c1 = VW_JF_1.item_1 
   AND t1.c1 > 1
````






## Влияние на оптимизатор
  - С помощью параметров
    - optimizer_mode
    - optimizer_mode
    - db_multiblock_read_count 
    - и многое другое. См. документацию.
  - С помощью подсказок

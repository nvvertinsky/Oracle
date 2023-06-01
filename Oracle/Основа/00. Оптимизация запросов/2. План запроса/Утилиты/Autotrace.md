# Autotrace

### Параметры запуска: 
````
set autotrace off;                   # Отключить вывод любых отчетов
set autotrace on explain;            # Строки + план
set autotrace on statistics;         # Строки + статистика
set autotrace on;                    # Строки + план + статистика
set autotrace traceonly;             # План + статистика
set autotrace traceonly statistics;  # Статистика
set autotrace traceonly explain;     # План
````

### Статистика
  - recursive calls                        # Рекурсивные запросы SQL. Если при выполнении SQL запрос запускается еще один SQL запрос, то он рекурсивный.
  - db block gets                          # Чтение блоков (I/O) из буферного кеша как они есть на текущий момент. Используется в DML.
  - consistent gets                        # Чтение блоков (I/O) из буферного кеша по состоянию на момент начала SQL оператора. Используется в SELECT, Т.к. нужно согласованое чтение.
  - physical reads                         # Чтение блоков (I/O) с диска в буферный кеш.
  - redo size                              # На сколько байтов создано редо логов (например 18 000 000 это 18 мб)
  - bytes sent via SQLNet to client        # Общее число байтов, отправленных клиенту с сервера
  - bytes received via SQLNet from client  # Общее число байтов, полученных от клиента
  - SQLNet roundtrips to/from client       # Общее кол-во отправленных и полученных сообщений SQL net от клиента
  - sorts (memory)                         # Кол-во сортировок, выполненых в памяти сессии пользователя.
  - sorts (disk)                           # Кол-во сортировок, которые использует диск (TEMP) из-за превышения размера области сортировки пользователя.
  - rows processed                         # Кол-во строк, изменяемых или возвращаемых в результате работы оператора SELECT 


## Подробнее о каждой статистике: 

### redo size 
  - Это полезный показатель при оценке эффективности массовых операций, таких как прямые вставки или create table as select 

Чем генерятся:
  - MERGE
  - UPDATE
  - DELETE
  - INSERT 


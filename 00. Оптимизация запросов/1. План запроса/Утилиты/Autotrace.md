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
  - recursive calls. Если при выполнении SQL запрос запускается еще один SQL запрос, то увеличиваем на 1
  - db block gets. Чтение блоков из буферного кеша. Используется в DML
  - consistent gets. Чтение блоков из буферного кеша. Используется в SELECT
  - physical reads. Чтение блоков с диска в буферный кеш.
  - redo size. На сколько байтов создано редо логов
  - bytes sent via SQLNet to client. Общее число байтов, отправленных клиенту с сервера
  - bytes received via SQLNet from client. Общее число байтов, полученных от клиента
  - SQLNet roundtrips to/from client. Общее кол-во отправленных и полученных сообщений клиента
  - sorts (memory). Кол-во сортировок, выполненых в памяти сессии пользователя.
  - sorts (disk). Кол-во сортировок, которые использует диск (TEMP) из-за превышения размера области сортировки пользователя.
  - rows processed. Кол-во строк, изменяемых или возвращаемых в результате работы оператора SELECT 


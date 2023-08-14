# Active Session History

### Описание
  - Обязательно нужна лицензия на Oracle Diagnostic Pack
  - Oracle собирает статистику для всех активных сеансов каждую 1 секунду.
  - Сохраняет в SGA. Если буфер заполнился, то процесс MMNL сбрасывает на диск.
  - Записывает самую свежую активность сеанса.
  


### Представления
````
v$active_session_history        # Анализ текущих активных сеансов (SGA)
dba_hist_active_session_history # Анализ хронологии старых сеансов (HDD)
````


### Генерация отчета ASH. Утилита ashrpt.sql. HTML или текстовый.
````
$ $ORACLE_HOME/rdbms/admin/ashrpt.sql
````

1. Устаревшая статистика. 
    - ALL_TABLES (DBA_TABLES) и ALL_INDEXES (DBA_INDEXES).Last_Analyzed - время последнего сбора статистики.
    - Собрать статистику для таблицы: execute DBMS_STATS.GATHER_TABLE_STATS ('HIST','AGREEMENT',NULL,10,NULL,'FOR ALL INDEXED COLUMNS SIZE AUTO',4);
    - Собрать статистику для индекса: `execute DBMS_STATS.GATHER_INDEX_STATS('HIST', 'X_AGREEMENT', null, 10, null, null, 4);`
2. Плохая статистика таблиц и индексов. 
    - Это когда процент сбора статистики по таблице или индексу менее 0.1 %. Для таблиц процент сбора статистики вычисляется запросом:
    - `SELECT owner, table_name,`
    - `round(d.sample_size/decode(d.num_rows,0,100000000000,d.num_rows)*100,2) proch,`
    - `d.last_analyzed`
    - `FROM ALL_TABLES d`
    - `WHERE owner='HIST'`
    - `and table_name ='AGREEMENT';`

- Процент сбора статистики по индексу находиться по запросу:
`SELECT owner,`
- `table_name, index_name,`
- `round(sample_size*100/nvl(decode(num_rows,0,100000,num_rows),1000000),2) proch,`
- `last_analyzed`
- `FROM ALL_IND_STATISTICS D`
- `Where owner='HIST'`
- `and  table_name = 'AGREEMENT';`
- Необходимо пересобрать статистику по таблице или индексу с плохой статистикой.
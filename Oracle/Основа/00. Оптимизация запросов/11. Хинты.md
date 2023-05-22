### Основные 
  1. MATERIALIZE

  2. APPEND
    Описание: 
      - Позволяет записывать данные в таблицу минуя буферный кеш
  
    Когда использовать: 
      - При вставке больших объемов данных в таблицу

    Как работает: 
      - Данные будут писаться после выше точки HWM. То есть данные будут вставляться начиная с блока, следующего за последним использованным блоком.
  
  3. NOLOGGING

### общие цели оптимизатора
````
	/*+ RULE */
	/*+ ALL_ROWS */
	/*+ FIRST_ROWS */
	/*+ FIRST_ROWS(n) */
````

### порядок доступа
````
	/*+ LEADING */
	/*+ ORDERED */
````

### методы соединения
````
	/*+ USE_HASH */
	/*+ USE_NL */
	/*+ USE_MERGE */
	/*+ USE_HASH_AGGREGATION */
	/*+ NATIVE_FULL_OUTER_JOIN */
	/*+ INDEX_JOIN */
	/*+ INDEX_COMBINE */
	/*+ NUM_INDEX_KEYS */
````

### способы выполнения [под]запроса
````
	/*+ DRIVING_SITE */
	/*+ MATERIALIZE */
	/*+ INLINE */
	/*+ PRECOMPUTE_SUBQUERY */
````

### статистика объектов
````
	/*+ DYNAMIC_SAMPLING */
	/*+ DYNAMIC_SAMPLING_EST_CDN */
	/*+ CARDINALITY */
	/*+ OPT_ESTIMATE */
	/*+ TABLE_STATS | INDEX_STATS | COLUMN_STATS */
````

### трансформации [под]запросов
````
	/*+ NO_QUERY_TRANSFORMATION */
	/*+ PUSH_SUBQ */
	/*+ NO_UNNEST */
	/*+ UNNEST */
	/*+ NO_ELIMINATE_OBY */
	/*+ MERGE */ /*+ NO_MERGE */
	/*+ USE_CONCAT */
	/*+ NO_EXPAND */
	/*+ PUSH_PRED */ /*+ NO_PUSH_PRED */
	/*+ FACTORIZE_JOIN */ /*+ NO_FACTORIZE_JOIN */
	/*+ OR_EXPAND */
````

### использование курсоров
````
	/*+ CURSOR_SHARING_EXACT */
	/*+ BIND_AWARE */ /*+ NO_BIND_AWARE */
````

### параллельное выполнение
````
	/*+ PARALLEL */
	/*+ SHARED */
	/*+ STATEMENT_QUEUING */ /*+ NO_STATEMENT_QUEUING */
````

### прочие
````
	/*+ QB_NAME */
	/*+ GATHER_PLAN_STATISTICS */
	/*+ OPT_PARAM */
	/*+ OPTIMIZER_FEATURES_ENABLE */
	/*+ APPEND */ /*+ NOAPPEND */
	/*+ APPEND_VALUES */
	/*+ RESULT_CACHE */ /*+ NO_RESULT_CACHE */
	/*+ IGNORE_ROW_ON_DUPKEY_INDEX */
````
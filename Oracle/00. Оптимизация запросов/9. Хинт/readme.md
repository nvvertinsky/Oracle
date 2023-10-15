### Основные 

### Как посмотреть отчет какие подсказки используются (Доступно с Oracle 19c)
````
dbms_xplan.display_cursor(format => 'ALL');
dbms_xplan.display_cursor(format => 'HINT_REPORT');
dbms_xplan.display_cursor(format => 'TYPICAL');
dbms_xplan.display();
````
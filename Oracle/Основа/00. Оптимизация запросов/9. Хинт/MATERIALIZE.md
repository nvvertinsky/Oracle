### MATERIALIZE


### Описание 
  - Материализует подзапрос. То есть создает временную таблицу на основе данных подзапроса. 
  - Эту временную таблицу можно использовать в нескольких запросах. 


### Оператор with 
  - Ключевое слово with обычно само материализует подзапрос. 
  - Но если по какой то причине with это не делает и это не исправить, то можно попробовать использовать MATERIALIZE
  

### Пример
````
with emp_sq as (select  * 
                  from emp 
				 where comm > 0)
select e.ename, 
       d.loc 
  from emp_sq e, 
       dept d 
 where d.deptno = e.deptno;
 
-----------------------------------------------------------------------------
| Id  | Operation                    | Name    | Rows  | Bytes | Cost (%CPU)|
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |         |     3 |    66 |     6  (17)|
|   1 |  MERGE JOIN                  |         |     3 |    66 |     6  (17)|
|   2 |   TABLE ACCESS BY INDEX ROWID| DEPT    |     4 |    44 |     2   (0)|
|   3 |    INDEX FULL SCAN           | PK_DEPT |     4 |       |     1   (0)|
|*  4 |   SORT JOIN                  |         |     3 |    33 |     4  (25)|
|*  5 |    TABLE ACCESS FULL         | EMP     |     3 |    33 |     3   (0)|
-----------------------------------------------------------------------------
 

 
with emp_sq as (select /*+ MATERIALIZE */ * 
                  from emp 
				 where comm > 0)
select e.ename, 
       d.loc 
  from emp_sq e, 
       dept d 
 where d.deptno = e.deptno;
 
------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name                      | Rows  | Bytes | Cost (%CPU)|
------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                           |     3 |    93 |     8  (13)|
|   1 |  TEMP TABLE TRANSFORMATION    |                           |       |       |            |
|   2 |   LOAD AS SELECT              | SYS_TEMP_0FD9D665D_A5677E |       |       |            |
|*  3 |    TABLE ACCESS FULL          | EMP                       |     3 |   114 |     3   (0)|
|   4 |   MERGE JOIN                  |                           |     3 |    93 |     5  (20)|
|   5 |    TABLE ACCESS BY INDEX ROWID| DEPT                      |     4 |    44 |     2   (0)|
|   6 |     INDEX FULL SCAN           | PK_DEPT                   |     4 |       |     1   (0)|
|*  7 |    SORT JOIN                  |                           |     3 |    60 |     3  (34)|
|   8 |     VIEW                      |                           |     3 |    60 |     2   (0)|
|   9 |      TABLE ACCESS FULL        | SYS_TEMP_0FD9D665D_A5677E |     3 |   114 |     2   (0)|
------------------------------------------------------------------------------------------------

````
### Правило:
  - Индексы со структурой B-дерева не хранят строки, столбцы которых проиндексированы и все содержат null 
  
### Исключения:
  - Кластерный индекс
  - Битовые


### Пример:
````
create table t (x int, y int);
create unique index t_idx on t(x,y);
insert into t values (1, 1);
insert into t values (1, null);
insert into t values (null, 1);
insert into t values (null, null);

analyze index t_idx validate structure;

select name,
	   lf_rows
  from index_stats;

-- Запрос покажет, что в индексе хранится всегда 3 строки, вместо 4. 
-- Строка null null не сохранится в индексе.
-- А если в строке есть поле не null, то такие строки хранятся в индексе.


insert into t values (null, null); -- ошибки не будет. Потому что null значения не равны другим null значениям.
-- Но при агрегировании null строка будет считаться за одну
-- Поэтому чтобы уникальный ключ точно был уникальным, нужно хотя одна колонка not null в таблице
select *
  from t
 group by t.x, 
          t.y;
		  
insert into t values (1, null); -- будет ошибка уникального значения 
insert into t values (null, 1); -- будет ошибка уникального значения 

select * from t where x is null; -- не будет использовать индекс, так как в индексе отсутствует строка null null. 
-- Чтобы индекс использовался, нужнен хотя бы 1 столбец not null.
````
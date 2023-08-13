### Одноуровневое партиционирование. HASH

### Как работает: 
  - Указываем столбец для секционирования и кол-во секций.
  - По значениям секционированного столбца будет выполнятся хеш-функция.
  - Кол-во секций желательно равно степени числа 2. (например 4, 8, 16).

### Зачем нужно:
  - Когда данные не имеют естественных диапазонов значений.
  - Для эффективного распеределения данных по разным дискам.
  - Решает проблему горячего блока. То есть блока за который идет большая конкуренция.
  - Для параллельной записи.

### Пример
````
create table hash_tab(
  order_id number,
  sernum varchar2(100),
  state_code varchar2(10)
)
partition by hash (order_id) -- Должен быть столбец который дает уникальное значение, ну или максимальное возможное кол-во уникальных значений.
(partition p1, partition p2, partition p3, partition p4);

-- вставляем записи
insert into hash_tab(order_id, sernum, state_code) values (1, '111', 'MA');
insert into hash_tab(order_id, sernum, state_code) values (2, '222', 'TX');
insert into hash_tab(order_id, sernum, state_code) values (3, '333', null);
insert into hash_tab(order_id, sernum, state_code) values (4, '444', 'ZZZ');
commit;


select * from hash_tab partition (p1);
select * from hash_tab partition (p2);
select * from hash_tab partition (p3);
select * from hash_tab partition (p4);


-- проверим распределение. вставим 128 записей
insert into hash_tab
select level, level, level from dual connect by level <= 128;

select 'p1', count(*) from hash_tab partition (p1)
union all
select 'p2', count(*) from hash_tab partition (p2)
union all
select 'p3', count(*) from hash_tab partition (p3)
union all
select 'p4', count(*) from hash_tab partition (p4);
````
# List партиционирование

### Как работает:
  - Распределение данных будет по списку значений
  - Можно задать секцию DEFAULT. Данные попадут туда если значение не подошло по списку.

### Когда применяется:
  - Когда есть столбец, который представляет из себя какой-то список. Например список кодов региона.

### Особенности:
  - Можно добавлять секции к существующей таблице, если не была указана секция DEFAULT
````
alter table t1 add partition part3;
````

### Пример c ручный секционированием:
````
create table list_tab(
  order_id number,
  sernum varchar2(100 char),
  state_code varchar2(10 char)
)
partition by list (state_code) -- диапазон
(
 partition region_east   values ('MA','NY'),
 partition region_west values ('CA','AZ'),
 partition region_south values ('TX','KY'),
 partition region_null  values (null),
 partition region_unknown values (default)
);

-- вставляем записи
insert into list_tab(order_id, sernum, state_code) values (1, '111', 'MA');
insert into list_tab(order_id, sernum, state_code) values (2, '222', 'TX');
insert into list_tab(order_id, sernum, state_code) values (3, '333', null);
insert into list_tab(order_id, sernum, state_code) values (4, '444', 'ZZZ');
commit;

-- смотрим партиции, в какие куда вошли записи
select * from list_tab partition (region_east);
select * from list_tab partition (region_west);
select * from list_tab partition (region_south);
select * from list_tab partition (region_null);
select * from list_tab partition (region_unknown);
````

### Пример c автоматическим секционированием:
````
create table auto_list_tab(
  order_id number,
  sernum varchar2(100 char),
  state_code varchar2(10)
)
partition by list (state_code) automatic -- автоматическое нарезание
(
partition p_ca values ('CA')
);

-- вставляем записи
insert into auto_list_tab(order_id, sernum, state_code) values (1, '111', 'MA');
insert into auto_list_tab(order_id, sernum, state_code) values (2, '222', 'TX');
insert into auto_list_tab(order_id, sernum, state_code) values (2, '222', 'CA');
insert into auto_list_tab(order_id, sernum, state_code) values (3, '333', null);
insert into auto_list_tab(order_id, sernum, state_code) values (4, '444', 'ZZZ');
commit;

-- смотрим, какие секции созданы
select * from user_tab_partitions t where t.table_name = 'AUTO_LIST_TAB';
````
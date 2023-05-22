### Link

### Пример как делалил до Oracle 11g Release 1
````
create table orders (order# number primary key,
					 order_date date,
					 data VARCHAR2)
enable row movement
PARTITION BY RANGE (order_date)
(
PARTITION part_2014 values less than (to_date('01.01.2015','dd.mm.yyyy')),
PARTITION part_2015 values less than (to_date('01.01.2016','dd.mm.yyyy'))
);

insert into orders values (1, to_date('01.01.2014','dd.mm.yyyy'));
insert into orders values (1, to_date('01.01.2015','dd.mm.yyyy'));


create table order_line_items(order# number,
							  line# number,
							  order_date date, /*Столбец взят из таблицы orders. По сути денормализация*/,
							  data varchar2(30),
							  constraint c1_pk primary key (order#, line#),
							  constraint c1_fk_p foreign key(order#) references orders)
enable row movement
partition by range (order_data)
(
PARTITION part_2014 values less than (to_date('01.01.2015','dd.mm.yyyy')),
PARTITION part_2015 values less than (to_date('01.01.2016','dd.mm.yyyy'))
);

insert into order_line_items values (1, 1, to_date('01.01.2014','dd.mm.yyyy'));
insert into order_line_items values (1, 1, to_date('01.01.2015','dd.mm.yyyy'));
````

Если нам нужно удалить секцию таблицы order_line_items, то мы знаем что нужно удалить соответствующую секцию 
таблицы orders. Но БД не знает
````
alter table order_line_items drop partition part_2014; -- успешно удалится
alter table orders drop partition part_2014; -- ошибка unique/primary keys in table referenced by enabled foreign keys
````

### После Oracle 11g Release 1 делаем так:
````
create table orders (order# number primary key,
					 order_date date,
					 data VARCHAR2)
enable row movement
PARTITION BY RANGE (order_date)
(
PARTITION part_2014 values less than (to_date('01.01.2015','dd.mm.yyyy')),
PARTITION part_2015 values less than (to_date('01.01.2016','dd.mm.yyyy'))
);

insert into orders values (1, to_date('01.01.2014','dd.mm.yyyy'), 'xxx');
insert into orders values (1, to_date('01.01.2015','dd.mm.yyyy'), 'xxx');

create table order_line_items(order# number,
							  line# number,
							  data varchar2(30),
							  constraint c1_pk primary key (order#, line#),
							  constraint c1_fk_p foreign key(order#) references orders)
enable row movement
partition by reference(c1_fk_p);

insert into order_line_items values (1, 1, 'zzz');
insert into order_line_items values (2, 1, 'zzz');
````
Теперь при удалении секции, БД автоматически удаляет связанные секции 
````
alter table orders drop partition part_2014;
alter table orders add partition part_2016; -- можно так же добавлять новые секции и они будут добавлены в связанные таблицы
````

Оператор enable row movement - Позволяет оператору update модифицировать значение ключа секции так, что это вызовет перемещение строки из текущей секции в какую-то другую
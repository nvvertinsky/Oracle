create table partitioned (timestamp date, id int)
partition by range (timestamp)
(
partition fy_2014 values less than (to_date('01.01.2015', 'dd.mm.yyyy')),
partition fy_2015 values less than (to_date('01.01.2016', 'dd.mm.yyyy'))
);


create table fy_2014(timestamp date, id int);
create index fy_2014_idx on fy_2014(id);
create table fy_2016(timestamp date, id int);


-- Делаем перенос секции основной таблицы в архив
alter table partitioned exchange partition fy_2014 with table fy_2014 including indexes without validation;

-- Удаляем секцию из основной таблицы
alter table partitioned drop partition fy_2014;


-- Добавляем новую секцию в основную таблицу
alter table partitioned add partition fy_2016 values less than (to_date('01.01.2017', 'dd.mm.yyyy'));

-- Переносим данные из таблицы в новую секцию основной таблицы
alter table partitioned exchange partition fy_2016 with table fy_2016 including indexes without validation;


-- Если на основном таблице были глобальные индексы, то их нужно перестроить.
alter table partitioned exchange partition fy_2014 with table fy_2014 including indexes without validation 
update global indexes;

alter table partitioned drop partition fy_2014 update global indexes;
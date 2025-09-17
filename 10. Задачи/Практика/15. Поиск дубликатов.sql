create table persn (persn_id number(12), first_name varchar2(240), last_name varchar2(240));

insert into persn values (1, 'Nikolay', 'Vertinsky');
insert into persn values (2, 'Nikolay', 'Vertinsky');
insert into persn values (3, 'Vasya', 'Vertinsky');
insert into persn values (4, 'Vladimir', 'Makarov');
insert into persn values (5, 'Max', 'Slepchenkov');

-- 01. Сколько всего дублей first_name и last_name
-- 02. Выбрать все дублирующиеся last_name и first_name
-- 03. Выбрать все дубликаты first_name и last_name кроме первого
-- 04. Удалить дубликаты, кроме первого
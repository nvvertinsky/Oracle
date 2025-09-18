-- Задача: при вставке в таблицу необходимо проверять, что новая строка не пересекается по датам с уже имеющимися в разрезе id. 
-- Необходимо написать запрос проверяющий пересечения.

create table t(
  id number(38) not null,
  date_from date not null,
  date_till date not null);

insert into t values
(1, '01.01.2022', '10.01.2022');
insert into t values
(1, '01.02.2022', '13.02.2022');
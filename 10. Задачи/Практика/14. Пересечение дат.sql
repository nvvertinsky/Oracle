-- Задача: при вставке в таблицу необходимо проверять, что новая строка не пересекается по датам с уже имеющимися в разрезе клиента. 
-- Необходимо написать запрос проверяющий пересечения.

create table client_tariff(
  client_id number(38) not null,
  date_from date not null,
  date_till date not null);

insert into client_tariff values
(1, date'2022-01-01', date'2022-01-10');
insert into client_tariff values
(1, date'2022-02-01', date'2022-02-13');
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


-- Итоговый запрос: 
-- Достаточно проверить, что b2 > a and a2 < b;

-- Условие для пересечения: 
--  Нужно проверять находится ли дата новая дата начала внутри промежутка существующих дат или дата окончания

select count(1)
  from (select  1 client_id,
                date'2022-01-10' d_from,
                date'2022-01-12' d_till
          from dual) e
  join client_tariff t
    on t.client_id = e.client_id
   and e.d_till > t.date_from
   and e.d_from < t.date_till;
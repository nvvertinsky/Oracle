-- Задача: при вставке в таблицу необходимо проверять, что новая строка не пересекается по датам с уже имеющимися в разрезе id. 
-- Необходимо написать запрос проверяющий пересечения.

create table t(
  id number(38) not null,
  bg date not null,
  fn date not null);

insert into t values
(1, '01.01.2022', '10.01.2022');


select *
  from t
 where t.id = p_id
   and p_bg < fn
   and p_fn > bg
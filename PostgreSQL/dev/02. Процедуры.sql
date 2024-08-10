-- Создание
create or replace procedure fill() as $$
  insert into t values (1);
$$ language sql;


-- Вызов
call fill();


-- create or replace - Изменит только тело процедуры или функции.
-- А если появился новый параметр, то будет создана новая процедура или функция 
-- Старая при этом не удалятеся.



-- Полиморфизм: anyelemnt
create or replace function max(a anyelemnt, b anyelement) returns anyelement as $$
  select case when a > b then a else b end;
$$ immutable language sql;
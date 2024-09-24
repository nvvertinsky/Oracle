/*
Что вернёт запрос и сколько времени будет выполняться?
*/

create or replace function f1 return number is
begin
  dbms_lock.sleep(3);
  return 1;
end;


create or replace function f2 return number is
begin
    dbms_lock.sleep(5);
    return 1;
end;

select nvl(2, f1) a, coalesce(2, f2) b from dual


/*
Вернет: 2, 2. 
Выполняться: 3 сек
*/
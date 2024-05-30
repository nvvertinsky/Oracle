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

begin
  for cur in (select nvl(2, f1) a, coalesce(2, f2) b from dual) 
  loop 
    dbms_output.put_line(cur.a); 
    dbms_output.put_line(cur.b); 
  end loop;
end; 

2, 2
3 sec;
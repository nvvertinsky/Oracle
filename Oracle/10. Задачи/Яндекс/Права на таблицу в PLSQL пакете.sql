nvvertinskiy

/*
Права на таблицу в PL/SQL пакете
Создаём пакет PL/SQL, выдаём право на выполнение другому пользователю.
Будет ли у другого пользователя ошибка при вызове пакета если у него нет доступа к таблице, которая используется в пакете?
*/

drop table tbl;
create table tbl (val number(12));

create or replace package tbl_pkg is 
  procedure proc; 
end; 

create or replace package body tbl_pkg is 
  procedure proc is 
  begin
    insert into tbl values (1);
  end; 
end; 

select * from tbl;


Ответ: Ошибки не будет.



-- Есть несколько реализаций оптимистического управления параллельной обработкой:
  -- Использование специального столбца, который сообщает "версию" записи
    -- Кайт выбирает этот способ. Потому что метод требует меньшего объема вычислений, чем использование хеша.
  -- Применение контрольной суммы или хеш-значения, вычисленного с использованием исходных данных.

-- Использование специального столбца, который сообщает "версию" записи:

-- Создаем таблицу со столбцом
create table dept(deptno number(2), dname varchar2(14), loc varchar2(13), last_mod timestamp with time zone default systimestamp not null);

-- Вставляем в нее записи 
insert into dept (deptno, dname, loc) select deptno, dname, loc from skott.dept;
commit;

declare 
  l_last_mod timestamp with time;
begin
  -- Сначала смотрим какое время последнего обновления строки
  select last_mod
    into l_last_mod
    from dept 
   where deptno = 10;
  
  -- Проверяем что строка не обновилась и обновялем 
  update dept
     set dname = lower(dname)
   where deptno = 10
     and last_mod = l_last_mod;
  
  -- Была обновлена строка, которая нам была интересна
  -- А если кто-то до нас успел обновить эту строку, то будет обновлено 0 строк. И мы будем теперь знать, что строка была кем то обновлена.
end;
/



-- Применение контрольной суммы или хеш-значения, вычисленного с использованием исходных данных.
alter table dept drop column last_mod; -- Избавляемся от столбца прошлого способа.

declare 
  l_hash number;
begin 
  select ora_hash(dname || '/' || loc) hash
    into l_hash
    from dept
   where deptno = 10;
   
  
  update dept
     set dname = lower(dname)
   where deptno = 10
     and ora_hash(dname || '/' || loc) = l_hash;
end;

-- Но лучше делать через виртуальный столбец. Чтобы в каждом приложении применялся один и тот же способ хеширования. Это более универсально.
alter table dept add hash as (ora_hash(dname || '/' || loc)); 




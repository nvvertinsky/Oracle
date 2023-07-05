--  одномерный массив
do $$
declare 
  a integer[];
begin
  a := array[10,20,30];
  a[4] := 40; -- одномерный можно расширять
  raise notice '%', a;
end;
$$ language plpgsql;

--Двухмерный массив
do $$
declare 
  a integer[][] := {{10,20,30},{100,200,300}};
begin
  raise notice '%', a;
  a[4][4] := 1; -- многомерный нельзя расширять
end;
$$ language plpgsql;



-- Циклы по одномерным

do $$
declare
  a integer[] := array[10, 20, 30];
  x integer;
begin
  for i in array_lower(a, 1)..array_upper(a, 1)
  loop
	raise notice 'a[%] = %', i, a[i];
  end loop;
  
  
  foreach x in array a
  loop
    raise notice '%', x;
  end loop;
end;
$$ language plpgsql;


-- Циклы по двумерным
10  20  30
100 200 300

do $$
declare
  a integer[][] := array[array[10, 20, 30], array[100, 200, 300]];
  x integer;
begin
  for i in array_lower(a, 1)..array_upper(a, 1) -- по строкам
  loop
    for j in array_lower(a, 2)..array_upper(a, 2) -- по столбцам
	loop
	  raise notice 'a[%][%] = %', i, j, a[i][j];
	end loop;
  end loop;
  
  foreach x in array a
  loop
    raise notice '%', x;
  end loop;
  
end;
$$ language plpgsql;


-- функции с переменным числом параметров
create function maximum(variadic a integer[]) returns integer as $$
declare
  x integer;
begin
  foreach x in array a 
  loop
    null; -- какая то логика с каждым параметром
  end loop;
end;
$$ immutable language plpgsql;


-- Полиморфные типы anyarray
create function maximum(variadic a anyarray, maxsofar out anyelement) as $$
declare
  x maxsofar%type;
begin
  foreach x in array a
  loop
    maxsofar := x;
  end loop; 
end;
$$ immutable language plpgsql;

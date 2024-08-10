-- Самый просто вариант
do $$
begin
  execute 'select emp_id from emp where emp_id = $1' into strict l_emp_id using l_emp_id;
end;
$$;

-- использование с циклом 
for cur in execute 'select emp_id from emp where emp_id = :l_emp_id' using l_emp_id
loop
  null;
end loop;

-- Чтобы подставлять имена объектов, то лучше использовать функцию format
do $$
begin
  execute format('select emp_id from %l where emp_id = $1', 'emp') into strict l_emp_id using l_emp_id;
end;
$$;
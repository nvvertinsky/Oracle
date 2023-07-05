-- не отличается практически от Oracle

-- В read commitble не использовать select count и потом какую то логику. 
create or replace function change(code text, description text) returns void as $$
declare 
  cnt integer;
begin 
  select count(*)
    into strict cnt
    from categories c
   where c.code = change.code;
   
  if cnt = 0 then 
    insert into categories values (code, description);
  else
    update categories c
	   set description = change.description
	 where c.code = change.code; 
  end if;
end; 
$$ volatile language plpgsql;


-- Есть вариант с merge.



-- Есть вариант с on conflict
create or replace function change(code text, description text) returns void as $$
  insert into categories values (code, description)
  on conflict do update set description = change.description;
$$ volatile language sql;
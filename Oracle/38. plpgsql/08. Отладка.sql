DO $$
begin 
  -- какая то логика
  raise notice '1';
  -- какая то логика
end; 
$$ language plpgsql;



-- Запись в таблицу (вместо автономной транзации)
create extension dblink;
create table log (id serial, username varchar, ts timestamp, mess varchar);

create function write_log (mess varchar) returns void as $$
declare 
  cmd varchar;
begin 
  perform dblink_connect('dbname = ' || current_database());
  
  cmd := 'insert into log (username, ts, mess) values (' || quote_literal(user) || 
											         ',' || quote_literal(clock_timestamp()::text) || '::timestamp' || 
													 ',' || quote_literal(mess) || ')';
  perform dblink_disconnect();
end;
$$ language plpgsql;
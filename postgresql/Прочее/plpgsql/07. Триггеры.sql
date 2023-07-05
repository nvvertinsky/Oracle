-- Триггер - это обработчик событий

-- Возможное использование:

before statement -- Проверка применимости операции 
before row -- Проверка корректности, модификация строки.
instead of row -- Изменение базовых таблиц представления.
after row -- Проверка согласованности, аудит, изменения таблиц (денормализация, асинхронная обработка)
after statement -- Проверка согласованности на уровне таблицы, аудит.


create or replace function describe() returns trigger as $$
declare
  rec record;
  str text := '';
begin 	
  if TG_LEVEL = 'ROW' then 
    case TG_OP
	  when 'DELETE' then rec := OLD; str := OLD::text;
	  when 'UPDATE' then rec := NEW; str := OLD || ' => ' || NEW;
	  when 'INSERT' then rec := NEW; str := NEW::text;
	end case;
  end if;
  
  raise notice '% % % %: %', TG_TABLE_NAME, TG_WHEN, TG_OP, TG_LEVEL, str;
  return rec;  
end;

$$ language plpgsql;


-- триггера на уровне оператора
create trigger t_before_stmt before insert or update or delete on t for each statement execute procedure describe();
create trigger t_after_stmt after insert or update or delete on t for each statement execute procedure describe();

-- триггера на уровн строк
create trigger t_before_row before insert or update or delete on t for each row execute procedure describe();
create trigger t_after_row after insert or update or delete on t for each row execute procedure describe();
create or replace procedure proc is
  l_lock_handle varchar2(240);
  l_result integer;
begin
  dbms_lock.allocate_unique(lockname => 'PROCLOCK', 
                            lockhandle => l_lock_handle); /*Создаем уникальную блокировку.*/
  l_result := dbms_lock.request(lockhandle => l_lock_handle, 
                                lockmode => dbms_lock.x_mode, 
								timeout => 0, 
								release_on_commit => true); /*Запрашиваем блокировку*/

  if l_result = 0 then
    dbms_lock.sleep(15);
    
    if dbms_lock.release(lockhandle => l_lock_handle) != 0 then
      raise_application_error('-20001', 'Ошибка снятия блокировки');
    end if;
  else
    raise_application_error('-20001', 'Стоит блокировка');
  end if;
end;


-- Сессия 1. Выполняется 15 сек.
begin
  proc();
end;


-- Сессия 2. Ошибка "Стоит блокировка"
begin
  proc();
end;
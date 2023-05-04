### Определение:
Блокировка - это механизм, применяемый для регулирования параллельного доступа к разделяемому ресурсу.

### Виды
  1. На уровне строк
  2. На уровне таблиц
  3. На уровне Объектов БД. Компиляция объейта, который выполняется. 

### Оптимистичная блокировка
Это когда мы будем изменять информацию не прибегая к блокировке.
Мы оптимистически предполагаем что данные не будут изменены каким-то другим пользователем.

Недостатки:
  - Увеличивает вероятность потери обновления.

Пример:
````
update emp
   set sal = 5000
 where empno = 7934;
commit;
````

### Пессимистичая блокировка 
Это когда мы явно блокируем строку. Например for update.
Мы блокируем строку до попытки ее обновления, т.к. сомневаемся (настроенны пессимистически) - в том, что иначе она останется неизменной.

````
select empno, ename, sal from emp where empno = 7934 for update;

update emp
   set sal = 5000
 where empno = 7934;
commit;
````

Когда применяется: Когда с одной и той же сущностью работают более чем 1 сессия.

Пример: 
  - Между тем, когда мы считали статус платежа (select status) и тем, когда мы совершаем update payment, статус мог измениться.

Первый вариант: добавить for update с опциями
Второй вариант: проверять в update статус. Если строка заблокирована, то выполнение повиснет до освобождения блокировки.

````
procedure fail_payment(p_payment_id payment.payment_id%type
                      ,p_reason   payment.status_change_reason%type)
is
  v_status               payment.status%type;
  e_status_is_not_active exception;
begin
 
  select status
    into v_status
    from payment
   where payment_id = p_payment_id;
 
  if v_status != c_active then
    raise e_status_is_not_active;
  end if;
 
  update payment
     set status               = c_error
        ,status_change_reason = p_reason
   where payment_id = p_payment_id;
 
exception
  when e_status_is_not_active then
     raise_application_error(c_err_code_status_is_not_active, 'Платеж не активный');
                   
  when no_data_found then
     raise_application_error(c_err_code_payment_is_not_found, 'Платеж не найден');    
end;
/
````

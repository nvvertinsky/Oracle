/*
Метод пессимистической блокировки будет вступать в действие непосредственно перед тем, как пользователь изменяет значение на экране.

Когда применяется: 
  - В среде в которой приложение имеет постоянное подключение к базе данных. 
    - То есть приложение должно подключится к БД, заблокировать строку и обновить. И все это в рамках одного подключения. Нельзя закрывать подключение. Т.к. если его закрыть, то блокировку изчезнет.
  
  
*/

-- Запрашиваем данные без блокировки:
-- Получаем строку которую хотим обновить
select empno, ename, sal from emp where empno = 7934;


-- Теперь блокируем эту строку: 
select empno, ename, sal from emp where empno = 7934 for update;

-- Вот поэтому способ называется пессимистической блокировкой. Мы блокируем строку до попытки ее обновления, т.к. сомневаемся (настроенны пессимистически) - в том, что иначе она останется неизменной.


-- Обновляем данные 
update emp
   set sal = 5000
 where empno = 7934;
commit;
 

/*Еще пример блокировки:
БД, в принципе, многосессионная среда. Это API для работы с отдельной сущностью. Подобные обертки в основном реализуются не в DWH, в котором работа с данными выполняется в чуть более свободном режиме.
Соответственно, могут возникать ситуации, когда с одной и той же сущностью работают более чем 1 сессия.
Если совсем на пальцах: между тем, когда мы считали статус платежа (select status) и тем, когда мы совершаем update payment, статус мог измениться. В многосессионной среде так и будет. Разруливаются подобные проблемы - блокировками.

Первый вариант: добавить for update с опциями (https://t.me/oracle_dbd/47), которые соответствуют бизнес-задаче.
select status …  for update с опциями;

Второй вариант: проверять в update статус. Если строка заблокирована, то выполнение повиснет до освобождения блокировки.


*/

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

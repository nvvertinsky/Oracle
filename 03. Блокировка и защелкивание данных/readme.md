### Определение:
Блокировка - это механизм для регулирования параллельного доступа к ресурсу.

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

Пример: 
Между тем, когда мы считали статус платежа (select status) и тем, когда мы совершаем update payment, статус мог измениться.
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

### Взаимоблокировка
Если возникла, то Oracle сразу пишет инфу в трассировочный файл по пути:
````
SELECT value FROM v$parameter WHERE name = 'diagnostic_dest';
-- Или для старых версий:
SELECT value FROM v$parameter WHERE name = 'user_dump_dest';
````

Сам файл выглядит так:
````
*** 2013-06-25 09:37:35.324
DEADLOCK DETECTED ( ORA-00060 )

[Transaction Deadlock]

The following deadlock is not an ORACLE error. It is a deadlock due 
to user error in the design of an application
or from issuing incorrect ad-hoc SQL. The following
information may aid in determining the deadlock:

Deadlock graph:
                   ---------Blocker(s)--------  ---------Waiter(s)---------
Resource Name          process session holds waits  process session holds waits
TM-000151a2-00000000       210      72    SX   SSX      208      24    SX   SSX
TM-000151a2-00000000       208      24    SX   SSX      210      72    SX   SSX

session 72: DID 0001-00D2-000000C6  session 24: DID 0001-00D0-00000043 
session 24: DID 0001-00D0-00000043  session 72: DID 0001-00D2-000000C6 

Rows waited on:
 Session 72: no row
 Session 24: no row

----- Information for the OTHER waiting sessions -----
Session 24:
 sid: 24 ser: 45245 audsid: 31660323 user: 90/USER
  flags: (0x45) USR/- flags_idl: (0x1) BSY/-/-/-/-/-
  flags2: (0x40009) -/-/INC
 pid: 208 O/S info: user: zgrid, term: UNKNOWN, ospid: 2439
   image: oracle@xyz.local
 client details:
   O/S info: user: , term: , ospid: 1234
   machine: xyz.local program: 
 current SQL:
  delete from EMPLOYEE where EMP_ID=:1

 ----- End of information for the OTHER waiting sessions -----

Information for THIS session:

 ----- Current SQL Statement for this session (sql_id=dyfg1wd8xa9qt) -----
 delete from EMPLOYEE where EMP_ID=:1
===================================================
````
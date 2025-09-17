В таблице ниже появились полные дубликаты. Нужно дубликаты удалить и оставить только 1 запись от них.

client_balance(cl_id /*ID клиента*/, cl_name /*Имя клиента*/, dt /*Остаток на день*/, balance /*Баланс на эту дачу*/);

create table client_balance(cl_id number, cl_name varchar2(240), dt date, balance number(12));
insert into client_balance values (1, 'nikolay', to_date('01.01.2024', 'dd.mm.yyyy'), 100);
insert into client_balance values (2, 'nikolay2', to_date('01.01.2024', 'dd.mm.yyyy'), 200);
insert into client_balance values (2, 'nikolay2', to_date('01.01.2024', 'dd.mm.yyyy'), 200);
insert into client_balance values (2, 'nikolay2', to_date('01.01.2024', 'dd.mm.yyyy'), 200);
insert into client_balance values (3, 'nikolay3', to_date('02.01.2024', 'dd.mm.yyyy'), 300);
insert into client_balance values (3, 'nikolay3', to_date('02.01.2024', 'dd.mm.yyyy'), 300);
insert into client_balance values (3, 'nikolay3', to_date('02.01.2024', 'dd.mm.yyyy'), 300);
insert into client_balance values (4, 'nikolay4', to_date('03.01.2024', 'dd.mm.yyyy'), 400);


delete rowid
  from client_balance bb
 where bb.rowid not in (select min(rowid) r
                          from client_balance b
                         group by b.cl_id,
                                  b.cl_name,
                                  b.dt,
                                  b.balance)
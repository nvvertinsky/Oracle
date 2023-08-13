### Когда нужно индексировать внешний ключ:
  1. Вы удаляете строки из родительской таблицы.
  2. Вы обновляете значение первичного ключа родительской таблицы.
  3. Вы выполняете соединение родительской таблицы к дочерней в sql запросе.


````
alter table ua_bc drop constraint bc_pgtw_fk;
drop table da_pgtw;
drop table ua_bc;
drop sequence da_pgtw_q;
drop sequence da_bc_q;

create table da_pgtw (pgtw_id number(12), txt varchar2(240));
alter table da_pgtw add constraint pgtw_pk primary key (pgtw_id);
create table ua_bc (bc_id number(12), pgtw_id number(12), txt varchar2(240));
alter table ua_bc add constraint bc_pgtw_fk foreign key (pgtw_id) references da_pgtw(pgtw_id) on delete cascade;

create sequence da_pgtw_q
minvalue 0
maxvalue 10000000
start with 0
increment by 1
cache 100;

create sequence da_bc_q
minvalue 0
maxvalue 10000000
start with 0
increment by 1
cache 100;


insert into da_pgtw select da_pgtw_q.nextval, 'pgtw' from dual connect by rownum <= 100000;
insert into ua_bc select da_bc_q.nextval, da_bc_q.currval, 'bc' from dual connect by rownum <= 100000;

call dbms_stats.gather_table_stats(ownname => 'A', tabname => 'DA_PGTW');
call dbms_stats.gather_table_stats(ownname => 'A', tabname => 'UA_BC');

select * from da_pgtw pgtw where pgtw.pgtw_id = 99999;
select * from ua_bc bc where bc.pgtw_id = 99999;

-- 0. При удалении записи в родительской таблице, блокируется вся дочерняя таблица. НЕ ПОДТВЕРДИЛОСЬ.
delete from da_pgtw where pgtw_id = 1046; -- сеанс 1
update ua_bc bc set bc.pgtw_id = bc.pgtw_id - 1 where bc.pgtw_id = 100000; -- сеанс 2 выполнит команду без проблем

-- 1. Вы удаляете строки из родительской таблицы
delete from da_pgtw where pgtw_id in (select bc.pgtw_id from ua_bc bc); -- 1:44, 1:45
create index pgtw_idx on ua_bc (pgtw_id);
call dbms_stats.gather_table_stats(ownname => 'A', tabname => 'DA_PGTW');
call dbms_stats.gather_table_stats(ownname => 'A', tabname => 'UA_BC');
delete from da_pgtw where pgtw_id in (select bc.pgtw_id from ua_bc bc); -- 0:02, 0:02
drop index pgtw_idx;

-- 2. Вы обновляете значение первичного ключа родительской таблицы
insert into da_pgtw (pgtw_id, txt) values (100000, 'pgtw');
update ua_bc bc set bc.pgtw_id = bc.pgtw_id + 1 where bc.pgtw_id = 99999;
update da_pgtw pgtw set pgtw.pgtw_id = 100002 where pgtw.pgtw_id = 99999;


-- 3. Вы выполняете соединение родительской таблицы к дочерней
select pgtw.txt
  from da_pgtw pgtw,
       ua_bc bc
 where pgtw.pgtw_id = bc.pgtw_id
   and pgtw.pgtw_id = 2131; -- полное сканирование таблицы ua_bc, cost = 106

create index pgtw_idx on ua_bc (pgtw_id);
call dbms_stats.gather_table_stats(ownname => 'A', tabname => 'DA_PGTW');
call dbms_stats.gather_table_stats(ownname => 'A', tabname => 'UA_BC');

select pgtw.txt
  from da_pgtw pgtw,
       ua_bc bc
 where pgtw.pgtw_id = bc.pgtw_id
   and pgtw.pgtw_id = 2131; -- сканирование индекса ua_bc, cost = 3

drop index pgtw_idx;

````
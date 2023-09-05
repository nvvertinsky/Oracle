create table persn (persn_id number(12), first_name varchar2(240), last_name varchar2(240));

insert into persn (persn_id, first_name, last_name) values (1, 'Nikolay', 'Vertinsky');
insert into persn (persn_id, first_name, last_name) values (2, 'Nikolay', 'Vertinsky');
insert into persn (persn_id, first_name, last_name) values (3, 'Vasya', 'Vertinsky');
insert into persn (persn_id, first_name, last_name) values (4, 'Vladimir', 'Makarov');
insert into persn (persn_id, first_name, last_name) values (5, 'Max', 'Slepchenkov');

-- 01. Сколько всего дублей first_name и last_name
select first_name,
	     last_name,
	     count(*) as cnt
  from persn
 group by first_name,
          last_name
having count(*) > 1

-- 02. Выбрать все дублирующиеся last_name и first_name
select *
  from persn
 where last_name in (select last_name from persn group by last_name having count(*) > 1)
   and first_name in (select first_name from persn group by first_name having count(*) > 1)
   

-- 03. Выбрать все дубликаты first_name и last_name кроме первого 
select persn.*
  from persn
  left outer join (select min(persn_id) as persn_id,
                          first_name
                          last_name
                     from persn
                    group by first_name, last_name) tmp on persn.persn_id = tmp.persn_id
 where tmp.persn_id is null

-- 04. Удалить дубликаты, кроме первого
delete from persn
 where persn.persn_id in (select persn.persn_id
                            from persn
                            left outer join (select min(persn_id) as persn_id,
                                                    first_name
                                                    last_name
                                               from persn
                                              group by first_name, last_name) tmp on persn.persn_id = tmp.persn_id
                           where tmp.persn_id is null)

-- 05. Удалить дубликаты если нет ID
create table t2 (txt varchar2(240));

insert into t2 values ('str-1');
insert into t2 values ('str-1');
insert into t2 values ('str-2');
insert into t2 values ('str-2');
insert into t2 values ('str-3');

select * from t2;

delete 
  from t2
 where rowid not in (select min(rowid)
                       from t2 
                      group by txt
                     having count(txt) > 1) 

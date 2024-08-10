create table t2 (email varchar2(240));

insert into t2 select 'Ivan.ivanov@email.com' from dual
                union all 
               select 'Ivan.ivanov@email.com' from dual
                union all 
               select 'alex.exler@email.com' from dual
                union all 
               select 'svec.expl@email.com' from dual
                union all 
               select 'alex.exler@email.com' from dual
                union all 
               select 'alex.exler@email.' from dual
                union all 
               select 'a@a' from dual
               union all 
               select 'a@a' from dual
                union all 
               select '1111111111' from dual;

select * from t2;


select *
  from t2


delete  
  from t2
 where t2.rowid in (select max(rowid)
                      from t2 
                     where t2.email in (select t2.email
                                          from t2
                                         group by t2.email
                                        having count(*) > 1)
                     group by t2.email)
                     
delete  
  from t2
 where t2.email not like '%@%.com' 
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



delete 
  from t2
 where rowid in (select rowid
                  from t2
                 where not regexp_like(t2.email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                 union
                select t2.rowid
                  from t2,
                       (select min(rowid) r, 
                               t2.email
                          from t2
                         group by t2.email
                        having count(*) > 1) v
                 where t2.email = v.email
                   and t2.rowid != v.r)
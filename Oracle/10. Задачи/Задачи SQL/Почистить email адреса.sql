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


delete 
  from t2 
 where t2.rowid not in (select min(t2.rowid)
                          from t2
                         group by t2.email
                        having count (t2.email) > 1
                         union all
                        select min(t2.rowid)
                          from t2
                         group by t2.email
                        having count(t2.email) = 1) /*Убираем только дубли*/
    or not (  
              regexp_like(upper(t2.email),'^[A-Z0-9._-]+@[A-Z0-9._-]+\.[A-Z]{2,}$')
            or
              regexp_like(upper(t2.email),'^[А-ЯA-Z0-9._-]+@[А-ЯA-Z0-9._-]+\.(РФ)$')
           ) /*Убираем email адреса которые не соответствуют маске*/
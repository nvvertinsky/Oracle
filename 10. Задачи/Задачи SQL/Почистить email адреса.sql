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
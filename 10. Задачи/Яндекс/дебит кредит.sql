Есть таблицы:
credit(acc_id /*Счет*/, dt /*Дата транзакции*/, amnt /*сумма транзакции*/)
debit(acc_id /*Счет*/ , dt /*Дата транзакции*/, amnt /*сумма транзакции*/)
acc(acc_id /*Счет*/)

Нужно найти разность credit от debit по каждому счету по каждому дню.

Итоговый результат: 
01.01.2024	0001	2500
01.01.2024	0002	-300
01.01.2024	0003	0
01.01.2024	0004	0
02.01.2024	0001	0
02.01.2024	0002	9000
02.01.2024	0003	0
02.01.2024	0004	0
03.01.2024	0001	0
03.01.2024	0002	0
03.01.2024	0003	0
03.01.2024	0004	20


with debit as (select 0001 acc_id, to_date('01.01.2024', 'dd.mm.yyyy') dt, 1000 amnt from dual
               union all 
               select 0001 acc_id, to_date('01.01.2024', 'dd.mm.yyyy') dt, 2000 amnt from dual
               union all 
               select 0002 acc_id, to_date('01.01.2024', 'dd.mm.yyyy') dt, 500 amnt from dual
               /*По 3-му счету нет поступлений*/
               union all 
               select 0002 acc_id, to_date('02.01.2024', 'dd.mm.yyyy') dt, 9000 amnt from dual
               union all 
               select 0004 acc_id, to_date('03.01.2024', 'dd.mm.yyyy') dt, 20 amnt from dual),
    credit as (select 0001 acc_id, to_date('01.01.2024', 'dd.mm.yyyy') dt, 500 amnt from dual
               union all 
               select 0002 acc_id, to_date('01.01.2024', 'dd.mm.yyyy') dt, 800 amnt from dual
               /*По 3-му счету нет расходов*/),
    acc as (select '0001' acc_id from dual
            union all
            select '0002' acc_id from dual
            union all
            select '0003' acc_id from dual
            union all
            select '0004' acc_id from dual)
			
			
			
			
			
			
select t.dt, 
       t.acc_id,
       nvl(db.amnt, 0) - nvl(cr.amnt, 0)
  from (select acc.acc_id,
               ddate.dt
          from acc,
              (select to_date('31.12.2023', 'dd.mm.yyyy') + level dt from dual connect by level <= 3) ddate) t,
      (select sum(debit.amnt) amnt,
              debit.acc_id,
              debit.dt
         from debit
        group by debit.acc_id,
                 debit.dt) db,
      (select sum(credit.amnt) amnt,
              credit.acc_id,
              credit.dt
         from credit
        group by credit.acc_id,
                 credit.dt) cr
 where db.acc_id(+) = t.acc_id
   and db.dt(+) = t.dt
   and cr.acc_id(+) = db.acc_id
   and cr.dt(+) = db.dt
 order by t.dt,
          t.acc_id
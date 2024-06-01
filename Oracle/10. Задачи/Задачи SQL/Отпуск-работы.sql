/*
Дана таблица сотрудников EMPLOYEES с датой приема сотрудника на работу и датой увольнения.
Дана таблица VACATIONS с отпусками сотрудников.
Требуется создать запрос который выводит список интервалов и состояний в отпуске/не в отпуске для каждого сотрудника.

Пример входных данных:
EMPLOYEES
---------
ID  DATEFROM    DATETO
1   01.02.2017  14.08.2018

VACATIONS
---------
ID  IDEMP  DATEFROM    DATETO
1   1      10.12.2017  31.12.2017
2   1      03.03.2018  10.03.2018

Пример результата:
DAYTRACKS
---------
ID  EFFECTIVE_DATE_FROM  EFFECTIVE_DATE_TO  ID_VAC
1   01.02.2017           09.12.2017         NULL 
1   10.12.2017           31.12.2017         1
1   01.01.2018           02.03.2018         NULL
1   03.03.2018           10.03.2018         2
1   11.03.2018           14.08.2018         NULL
*/

with employees as (
  select 1 as emp_id, to_date('01.01.2023', 'dd.mm.yyyy') as date_from, to_date('31.12.2023', 'dd.mm.yyyy') as date_to from dual
  union all
  select 2 as emp_id, to_date('01.01.2023', 'dd.mm.yyyy') as date_from, to_date('31.12.2023', 'dd.mm.yyyy') as date_to from dual
  union all
  select 3 as emp_id, to_date('01.01.2023', 'dd.mm.yyyy') as date_from, to_date('31.12.2023', 'dd.mm.yyyy') as date_to from dual
  union all
  select 4 as emp_id, to_date('01.01.2023', 'dd.mm.yyyy') as date_from, to_date('31.12.2023', 'dd.mm.yyyy') as date_to from dual
  union all
  select 5 as emp_id, to_date('01.01.2023', 'dd.mm.yyyy') as date_from, to_date('31.12.2023', 'dd.mm.yyyy') as date_to from dual
)
, vacations as (
  -- первый работник в отпуск не ходил
  -- второй работник был два раза в отпуске в середине периода
  select 1 as vac_id, 2 as emp_id, to_date('03.02.2023', 'dd.mm.yyyy') as date_from, to_date('10.02.2023', 'dd.mm.yyyy') as date_to from dual
  union all
  select 7 as vac_id, 2 as emp_id, to_date('03.04.2023', 'dd.mm.yyyy') as date_from, to_date('10.04.2023', 'dd.mm.yyyy') as date_to from dual
  -- третий работник был в отпуске с момента начала работы до когда-то и с когда-то до конца работы
  union all
  select 3 as vac_id, 3 as emp_id, to_date('01.01.2023', 'dd.mm.yyyy') as date_from, to_date('10.02.2023', 'dd.mm.yyyy') as date_to from dual
  union all
  select 5 as vac_id, 3 as emp_id, to_date('03.12.2023', 'dd.mm.yyyy') as date_from, to_date('31.12.2023', 'dd.mm.yyyy') as date_to from dual
  -- четвертый работник был в соприкасающихся отпусках внутри интервала
  union all
  select 2 as vac_id, 4 as emp_id, to_date('03.02.2023', 'dd.mm.yyyy') as date_from, to_date('10.02.2023', 'dd.mm.yyyy') as date_to from dual
  union all
  select 6 as vac_id, 4 as emp_id, to_date('11.02.2023', 'dd.mm.yyyy') as date_from, to_date('10.03.2023', 'dd.mm.yyyy') as date_to from dual
  -- пятый работник всю работу провел в отпуске
  union all
  select 4 as vac_id, 5 as emp_id, to_date('01.01.2023', 'dd.mm.yyyy') as date_from, to_date('31.12.2023', 'dd.mm.yyyy') as date_to from dual
)

-- 1. Делать будем через union. Делаем фильтрацию по emp_id. 
-- 2. Каждый запрос будет возвращать какие то свои данные. 
--   2.1. Первый запрос будет возвращать когда сотрудник в отпуске
--   2.2. Второй запрос будет возвращать данные если по сотруднику нет вообще отпуска. Сделать через not exists
--   2.3. Третий запрос будет возвращать данные перед отпуском сотрудника. 
--      - Находим отпуска сотрудника.
--      - EFFECTIVE_DATE_FROM - Нужно указать время начала его работы. Нужно посмотреть был ли отпуск перед работой. Если был взять время окончания предыдущего отпуска + 1, иначе возвращаем дату его найма. 
--      - EFFECTIVE_DATE_TO - Нужно указать дату начала отпуска - 1
--   2.4. Четвертый запрос будет возвращать данные после отпуска сотрудника. 
--      - Находим отпуска сотрудника.
--      - EFFECTIVE_DATE_FROM - Нужно указать время начала его работы. Указываем дату окончания отпуска + 1. 
--      - EFFECTIVE_DATE_TO - Нужно указать время окончания его работы до следующего отпуска ( если он есть). Посмотреть есть ли отпуск, если есть то берем время следующего отпуска - 1 лень. Если нет отпуска, то время его увольнения.
--   2.5. Пятый запрос будет находить есть ли строки, где дата начала отпуска совпадает с датой найма и минусовать их. 
--   2.6. Шестой запрос будет находить есть ли строки, где дата окончания отпуска совпадает с датой уволнения и минусовать их. 

select emp.emp_id id,
       vac.date_from EFFECTIVE_DATE_FROM,
       vac.date_to EFFECTIVE_DATE_TO,
       vac.vac_id
  from employees emp,
       vacations vac
 where vac.emp_id = emp.emp_id 
   and emp.emp_id = 5
 union 
select emp.emp_id id,
       emp.date_from EFFECTIVE_DATE_FROM,
       emp.date_to EFFECTIVE_DATE_TO,
       null vac_id
  from employees emp
 where emp.emp_id = 5
   and not exists (select *
                     from vacations vac
                    where vac.emp_id = emp.emp_id)
 union 
select emp.emp_id id,
       case when lag(vac.date_to) over (order by vac.date_to) is null then emp.date_from else lag(vac.date_to) over (order by vac.date_to) + 1 end EFFECTIVE_DATE_FROM,
       vac.date_from - 1 EFFECTIVE_DATE_TO,
       null vac_id
  from employees emp,
       vacations vac
 where emp.emp_id = 5
   and vac.emp_id = emp.emp_id
 union 
select emp.emp_id id,
       vac.date_to + 1 EFFECTIVE_DATE_FROM,
       case when lead(vac.date_from) over (order by vac.date_from) is null then emp.date_to else lead(vac.date_from) over (order by vac.date_from) - 1 end EFFECTIVE_DATE_TO,
       null vac_id
  from employees emp,
       vacations vac
 where emp.emp_id = 5
   and vac.emp_id = emp.emp_id
 minus
select emp.emp_id id,
       emp.date_from EFFECTIVE_DATE_FROM,
       emp.date_from - 1 EFFECTIVE_DATE_TO,
       null vac_id
  from employees emp,
       vacations vac
 where emp.emp_id = 5
   and vac.emp_id = emp.emp_id
   and vac.date_from = emp.date_from
 minus
select emp.emp_id id,
       emp.date_to + 1 EFFECTIVE_DATE_FROM,
       emp.date_to EFFECTIVE_DATE_TO,
       null vac_id
  from employees emp,
       vacations vac
 where emp.emp_id = 5
   and vac.emp_id = emp.emp_id
   and vac.date_to = emp.date_to
 
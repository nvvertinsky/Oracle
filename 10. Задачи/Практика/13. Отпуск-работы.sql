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
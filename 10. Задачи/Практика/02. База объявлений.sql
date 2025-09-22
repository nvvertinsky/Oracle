/*
Есть база объявлений (таблица offers)
Состоящая из: Номер объвления, владелец, дата публикации, дата снятия, марка
*/

/*
Для каждого пользователя вывести: 
  - Кол-во объявлений 
  - Дату публикации первого опубликованного объявления 
  - Дату снятия последнего объявления. 
*/

offer_id    user_id    date_from    date_to    mark
  1         u1       2020-01-01  2020-01-02   M1
  2         u1       2020-01-03  2020-01-04   M2
  3         u1       2020-01-05  2020-01-07   M1 
  4         u1       2020-03-01  2020-03-10   M3  
  5         u2       2020-04-01  2020-04-05   M1
  6         u2       2020-04-06  2020-04-07   M2 
  7         u2       2020-04-10  2020-04-11   M2 
  8         u3       2020-08-01  2020-08-10   M2 
  9         u3       2020-08-03  2020-08-10   M3 
  10        u3       2020-08-04  2020-08-09   M4 
  11        u4       2020-03-04  2020-03-08   M1
  12        u5       2021-03-04  2021-03-08   M1
  13        u5       2021-03-04  2021-03-07   M2 

with t as (select 1 offer_id, 'u1' user_id, to_date('01.01.2020', 'dd.mm.yyyy') bg, to_date('02.01.2020', 'dd.mm.yyyy') fn, 'M1' mark from dual
           union all
           select 2 offer_id, 'u1' user_id, to_date('03.01.2020', 'dd.mm.yyyy') bg, to_date('04.01.2020', 'dd.mm.yyyy') fn, 'M2' mark from dual
           union all
           select 3 offer_id, 'u1' user_id, to_date('05.01.2020', 'dd.mm.yyyy') bg, to_date('07.01.2020', 'dd.mm.yyyy') fn, 'M1' mark from dual
           union all
           select 4 offer_id, 'u1' user_id, to_date('01.03.2020', 'dd.mm.yyyy') bg, to_date('10.03.2020', 'dd.mm.yyyy') fn, 'M3' mark from dual
           union all
           select 5 offer_id, 'u2' user_id, to_date('01.04.2020', 'dd.mm.yyyy') bg, to_date('05.04.2020', 'dd.mm.yyyy') fn, 'M1' mark from dual
           union all
           select 6 offer_id, 'u2' user_id, to_date('06.04.2020', 'dd.mm.yyyy') bg, to_date('07.04.2020', 'dd.mm.yyyy') fn, 'M2' mark from dual
           union all
           select 7 offer_id, 'u2' user_id, to_date('10.04.2020', 'dd.mm.yyyy') bg, to_date('11.04.2020', 'dd.mm.yyyy') fn, 'M2' mark from dual
           union all
           select 8 offer_id, 'u3' user_id, to_date('01.08.2020', 'dd.mm.yyyy') bg, to_date('10.08.2020', 'dd.mm.yyyy') fn, 'M2' mark from dual
           union all
           select 9 offer_id, 'u3' user_id, to_date('03.08.2020', 'dd.mm.yyyy') bg, to_date('10.08.2020', 'dd.mm.yyyy') fn, 'M3' mark from dual
           union all
           select 10 offer_id, 'u3' user_id, to_date('04.08.2020', 'dd.mm.yyyy') bg, to_date('09.08.2020', 'dd.mm.yyyy') fn, 'M4' mark from dual
           union all
           select 11 offer_id, 'u4' user_id, to_date('03.04.2020', 'dd.mm.yyyy') bg, to_date('08.03.2020', 'dd.mm.yyyy') fn, 'M1' mark from dual
           union all
           select 12 offer_id, 'u5' user_id, to_date('04.03.2021', 'dd.mm.yyyy') bg, to_date('08.03.2021', 'dd.mm.yyyy') fn, 'M1' mark from dual
           union all
           select 13 offer_id, 'u5' user_id, to_date('04.03.2021', 'dd.mm.yyyy') bg, to_date('07.03.2021', 'dd.mm.yyyy') fn, 'M2' mark from dual)


select t.user_id,
       count(*) "Кол-во объяв",
       min(t.bg) "Первое объяв",
       max(t.fn) "Послед объяв"
  from t
 group by t.user_id
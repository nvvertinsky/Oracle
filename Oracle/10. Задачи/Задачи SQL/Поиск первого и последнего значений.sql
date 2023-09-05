/*
Необходимо выбрать все валюты и для каждой из них дату последнего изменения курса и сам курс.

Дана таблица FxRates с курсами валют:
name ddate rate
USDRUB 2001-01-03 63.54
EURRUB 2002-01-02 74.90
USDRUB 2002-03-10 65.01
USDRUB 2006-01-01 77.43
EURRUB 2005-02-03 65.10
USDRUB 2006-03-04 78.99

Пример ответа
name ddate rate
USDRUB 2006-03-04 78.99
EURRUB 2005-02-03 65.10

*/



select t.name
      ,min(ddate) keep(dense_rank first order by ddate desc nulls last) ddate
      ,min(rate) keep(dense_rank first order by ddate desc nulls last) rate
  from FxRates t
 group by t.name;

-- Запрос можно переписать на такой:

select t.name
      ,min(ddate) keep(dense_rank last order by ddate asc nulls first) ddate
      ,min(rate) keep(dense_rank last order by ddate asc nulls first) rate
  from FxRates t
 group by t.name;
 
 
 
 
/*
01. order by ddate - сортируем результирующий набор данных. От меньшей даты к большей.
02. dense_rank - ранжируем эти даты. Например от 1 до 4. Где 4 - самая большая дата по USDRUB
03. last - выбираем самое больше ранжирующее значение которое получилось на шаге 2. Это 4. Это будет самая большая дата. Например для USDRUB - это 2006-03-04
04. max(ddate) - из набора данных который получился в keep (dense_rank last order by ddate) (по USDRUB там только 2006-03-04) выбираем максимальную дату. Это разумеется 2006-03-04
*/
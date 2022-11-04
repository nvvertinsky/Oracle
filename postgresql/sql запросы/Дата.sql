select now();
SELECT current_date; -- date
SELECT current_time; -- today time
SELECT current_timestamp; -- date + time
SELECT localtime;
SELECT clock_timestamp();


SELECT CAST('1999-10-1' as date) + INTERVAL '1';
SELECT CAST('1999-10-1' as date) + INTERVAL '1 day 2:03:33'; day to second;
SELECT CAST('1999-10-1' as date) + INTERVAL '1 day 2:03:33';
SELECT CAST('1999-10-1 12:12:12' as timestamp)


SELECT date '2001-09-28' + time '03:00';
SELECT interval '1 day' + interval '1 hour' as inte_erval;
SELECT time '01:00' + interval '3 hours';
SELECT time '01:00:30' + interval '3 hours';
SELECT time '01:00:30' + interval '3 hours 30 minutes';
SELECT date '2001-10-01' - date '2001-09-28';
SELECT interval '1 day' - interval '1 hour';
SELECT 900 * interval '1 second';
SELECT interval '1 hour'/ 6;


SELECT age(timestamp '2005-10-14', timestamp '1997-10-14');
SELECT age(timestamp '1997-10-14');


SELECT date_part('hour',timestamp '2000-10-14 11:12:13');

--EXTRACT: 
SELECT EXTRACT(CENTURY FROM TIMESTAMP '2000-12-16 12:21:13');
SELECT EXTRACT(day FROM TIMESTAMP '2000-12-16 12:21:13');
SELECT date_trunc('hour', timestamp '2000-10-14 11:30:15');
SELECT (DATE '2001-02-16', DATE '2001-12-21') OVERLAPS
       (DATE '2001-10-30', DATE '2002-10-30');






























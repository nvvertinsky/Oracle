-- Почему тормозит, допустим: 
-- Сессия 1. Вставляет или обновляет данные в таблице TR. Срабатывает триггер FKD, который блокирует строку в таблице trt.
-- Сессия 1. Продолжает свое выполнение. Например дальше она сталкивается с долгим запросом либо делает долгих http запрос.
-- Сессия 2. Так же вставляет данные в TR. Так же срабатывает триггер FKD, который пытается заблокировать  строку в таблице trt. Но строка уже заблокирована, поэтому ждем. 
-- Сессия 3-n. Делает тоже самое. 


/*Сколько сейчас активных сессий. Топ выполнений.*/
select t.SID,
       t.SERIAL#,
       t.final_blocking_session "SID Блок сессии",
       t.sql_exec_start "Начало выполнения SQL", -- выполняемого в данный момент этим сеансом NULL if SQL_ID is NULL
       t.USERNAME,
       t.OSUSER,
       t.CLIENT_INFO,
       t.module,
       t.action,
       round(60 /*Переводит в минуты*/ * 24 /*Переводит в часы*/ * (sysdate - t.sql_exec_start)) "Время выполнения в минутах",
       l.sql_text "Выполняемый SQL",
       l.SQL_FULLTEXT,
       --
       block_sid.SERIAL# "SERIAL Блок сессии",
       block_sid.sql_exec_start "Начало SQL блок",
       round(60 /*Переводит в минуты*/ * 24 /*Переводит в часы*/ * (sysdate - block_sid.sql_exec_start)) "Время в минутах блок.",
       block_l.sql_text "Выполняемый SQL блок",
       'alter system kill Session '''|| t.SID || ',' || t.SERIAL# || ''' IMMEDIATE' cmd
  from v$session t,
       v$sql l,
       v$session block_sid,
       v$sql block_l
 where t.SID != (select DISTINCT SID from v$mystat) /*Исключаю сессию, из которой делаю этот запрос */
   -- 
   and l.sql_id(+) = t.sql_id
   --
   and block_sid.SID(+) = t.final_blocking_session
   --
   and block_l.SQL_ID(+) = block_sid.SQL_ID
 order by t.sql_exec_start nulls last;

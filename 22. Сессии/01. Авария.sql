-- 01. Сколько сейчас активных сессий. Сколько они выполняются. Топ выполнений.
-- 02. Почему сессии долго выполняются? 

select t.SID,
       t.SERIAL#,
       t.sql_exec_start "Начало выполнения SQL", -- выполняемого в данный момент этим сеансом NULL if SQL_ID is NULL
       t.USERNAME,
       t.CLIENT_INFO,
       t.module,
       t.action,
       round(60 /*Переводит в минуты*/ * 24 /*Переводит в часы*/ * (sysdate - t.sql_exec_start)) "Время выполнения в минутах",
       l.sql_text "Выполняемый SQL",
       t.final_blocking_session,
       --
       block_sid.SID "SID Блок сессии",
       block_sid.SERIAL# "SERIAL Блок сессии",
       block_sid.sql_exec_start "Начало SQL блок",
       round(60 /*Переводит в минуты*/ * 24 /*Переводит в часы*/ * (sysdate - block_sid.sql_exec_start)) "Время в минутах блок.",
       block_l.sql_text "Выполняемый SQL блок"
  from v$session t,
       v$sql l,
       v$session block_sid,
       v$sql block_l
 where t.status = 'ACTIVE'
   and l.sql_id(+) = t.sql_id
   and block_sid.SID(+) = t.final_blocking_session
   and block_l.SQL_ID(+) = block_sid.SQL_ID
 order by t.sql_exec_start nulls last;
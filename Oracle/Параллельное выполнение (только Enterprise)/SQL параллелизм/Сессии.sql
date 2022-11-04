-- посмотреть сеансы (сессии) для параллельного выполнения
-- Если в системе параллельного выполнения не происходит, то сеансов параллельного выполнения в v$session вы не увидите
select sid,
       username,
       program
  from v$session
 where sid in (select sid
	         from v$px_session
	        where qcsid = 258);
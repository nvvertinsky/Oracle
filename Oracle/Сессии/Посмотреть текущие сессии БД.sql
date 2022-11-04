SELECT t.SID, 
       t.SERIAL#, 
       t.osuser as "User", 
       t.MACHINE as "PC", 
       t.PROGRAM as "Program"
  FROM v$session t
--WHERE (NLS_LOWER(t.PROGRAM) = 'cash.exe') -- посмотреть сессии от программы cash.exe
--WHERE status='ACTIVE' and osuser!='SYSTEM' -- посмотреть пользовательские сессии
--WHERE username = 'схема' -- посмотреть сессии к схеме (пользователь)
  ORDER BY 4 ASC;
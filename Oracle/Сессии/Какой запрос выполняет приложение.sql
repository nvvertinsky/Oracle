SELECT PROCESS pid, 
       sess.process, 
       sess.status, 
       sess.username, 
       sess.schemaname, 
       sql.sql_text
  FROM v$session sess, 
       v$sql sql
 WHERE sql.sql_id(+) = sess.sql_id 
   AND sess.type = 'USER';
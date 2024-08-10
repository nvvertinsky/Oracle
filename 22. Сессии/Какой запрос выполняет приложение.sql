SELECT sess.sid, 
       sess.serial#, 
       sess.osuser, 
       sess.machine, 
       sess.program,
       sess.STATUS,
       sess.process pid, 
       sess.process, 
       sess.status, 
       sess.username, 
       sess.schemaname, 
       sql.sql_text,
       sql.sql_fulltext
  FROM v$session sess, 
       v$sql sql
 WHERE sql.sql_id(+) = sess.sql_id 
   AND sess.type = 'USER';
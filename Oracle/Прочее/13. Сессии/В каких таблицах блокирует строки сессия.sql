select sess.sid, 
       sess.serial#, 
       sess.osuser, 
       sess.machine, 
       sess.program,
       sess.STATUS,
       null holding_session,
       obj.OWNER || '.' || obj.object_name object_name,
       vlock.addr row_addr
  from v$session sess,
       dba_objects obj,
       v$sql vsql,
       v$lock vlock
 where vlock.SID = sess.SID
   --
   and obj.OBJECT_ID = vlock.ID1
   --
   and vsql.SQL_ID(+) = sess.SQL_ID
   --
   and sess.SID = 681
 order by obj.OWNER || '.' || obj.object_name

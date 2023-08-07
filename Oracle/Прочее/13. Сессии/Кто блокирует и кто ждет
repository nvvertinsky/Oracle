select 'BLOCKER',
       sess.sid, 
       sess.serial#, 
       sess.osuser, 
       sess.machine, 
       sess.program,
       sess.STATUS,
       null holding_session,
       obj.OBJECT_NAME
  from v$session sess,
       dba_blockers blckr,
       v$locked_object lckobj,
       dba_objects obj,
       v$sql vsql
 where blckr.holding_session = sess.SID
   and lckobj.SESSION_ID = blckr.holding_session
   and obj.OBJECT_ID = lckobj.OBJECT_ID
   and vsql.SQL_ID(+) = sess.SQL_ID
 union all
select 'WAITERS',
       sess.sid, 
       sess.serial#, 
       sess.osuser, 
       sess.machine, 
       sess.program,
       sess.STATUS,
       wtr.holding_session,
       null object_name
  from v$session sess,
       dba_waiters wtr,
       v$sql vsql
 where wtr.waiting_session = sess.SID
   and vsql.SQL_ID(+) = sess.SQL_ID

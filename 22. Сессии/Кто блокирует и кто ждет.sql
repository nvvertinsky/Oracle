select v.who,
       v.sid, 
       v.serial#, 
       v.osuser, 
       v.machine, 
       v.program,
       v.STATUS,
       v.holding_session,
       v.object_name,
       v.row_addr
  from (select 'BLOCKER' who,
               sess.sid, 
               sess.serial#, 
               sess.osuser, 
               sess.machine, 
               sess.program,
               sess.STATUS,
               null holding_session,
               obj.OWNER || '.' || obj.object_name object_name,
               vlock.addr row_addr
          from v$session sess,
               dba_blockers blckr,
               v$locked_object lckobj,
               dba_objects obj,
               v$sql vsql,
               v$lock vlock
         where blckr.holding_session = sess.SID
           and lckobj.SESSION_ID = blckr.holding_session
           and obj.OBJECT_ID = lckobj.OBJECT_ID
           and vsql.SQL_ID(+) = sess.SQL_ID
           and vlock.SID = blckr.holding_session
           and vlock.ID1 = obj.OBJECT_ID
         union all
        select 'WAITERS' who,
               sess.sid, 
               sess.serial#, 
               sess.osuser, 
               sess.machine, 
               sess.program,
               sess.STATUS,
               wtr.holding_session,
               null object_name,
               null row_addr
          from v$session sess,
               dba_waiters wtr,
               v$sql vsql
         where wtr.waiting_session = sess.SID
           and vsql.SQL_ID(+) = sess.SQL_ID) v 
 order by v.who,
          v.sid;

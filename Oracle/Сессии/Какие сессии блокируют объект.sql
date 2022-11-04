SELECT 'ALTER SYSTEM KILL SESSION '''||(s.sid)||','||(s.serial#)||''';' command,
       s.INST_ID, 
       s.SID, 
       s.SERIAL#, 
       s.USERNAME, 
       s.STATUS, 
       s.MACHINE
  FROM gv$lock l, 
       gv$session s 
 WHERE l.INST_ID=s.INST_ID
   AND l.TYPE='TO'
   AND l.SID=s.SID
   AND l.id1 IN (SELECT o.object_id 
	           FROM dba_objects o 
                  WHERE o.object_name = 'NAME'
                    AND o.owner='OWNER');
select t.sid, 
       t.serial#, 
       t.osuser, 
       t.machine, 
       t.program
  from v$session t
  order by 4 asc;
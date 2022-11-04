SELECT status, 
       SECONDS_IN_WAIT, 
       BLOCKING_SESSION, 
       SEQ#
  FROM v$session
 WHERE username=upper('scott');
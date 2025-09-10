select usr.spare4 usr_pass,
       substr(usr.spare4, -20) usr_salt
  from sys.user$ usr
 where name = 'SYS';
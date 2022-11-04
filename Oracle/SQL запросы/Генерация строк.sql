 select level as id_row /*,round(dbms_random.value(1,100)) as gen_num*/
   from dual
connect by level <= 5;
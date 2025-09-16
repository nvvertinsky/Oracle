# Какой PLSQL блок быстрее



### select into + exception = 14 сек
````
declare
  l_var a.ua_ag.hid%type;
  
  function func return a.ua_ag.hid%type is 
    l_hid a.ua_ag.hid%type;
  begin
    select ag.hid
      into l_hid
      from a.ua_ag ag
     where ag.ag_id = -1;
     
    return l_hid;
  exception
    when no_data_found then
      return null; 
  end; 
begin
  for i in 1..1000000
  loop
    l_var := func();
  end loop;
end;
````


### select into + exception = 10 сек
````
declare
  l_var a.ua_ag.hid%type;
  
  function func return a.ua_ag.hid%type is 
  begin
    for cur in (select ag.hid
                  from a.ua_ag ag
                 where ag.ag_id = -1)
    loop
      return cur.hid;
    end loop;
     
    return null;
  end; 
begin
  for i in 1..1000000
  loop
    l_var := func();
  end loop;
end; -- 10 сек

````

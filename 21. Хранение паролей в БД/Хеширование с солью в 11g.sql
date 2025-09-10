-- Самый популярный алгоритм шифрования Sha256

declare
  l_salt varchar2(20);

  function i_get_hash(p_pass in varchar2, p_salt in varchar2) return varchar2 is
  begin
    return dbms_crypto.hash(src => utl_raw.concat(r1 => utl_raw.cast_to_raw(c => p_pass), 
                                                  r2 => hextoraw(c => p_salt)), 
                            typ => dbms_crypto.hash_sh1) || p_salt;
    
  end;
begin
  
  l_salt := rawtohex(dbms_crypto.RandomBytes(number_bytes => 10));
  
  dbms_output.put_line(l_salt);
  
  dbms_output.put_line(a => i_get_hash(p_pass => '1', p_salt => l_salt));
end;


declare
  l_salt varchar2(20);

  function i_get_hash(p_pass in varchar2, p_salt in varchar2) return varchar2 is
    l_hash_pass raw(32767);  
  begin
    l_hash_pass := dbms_crypto.hash(src => utl_raw.concat(r1 => utl_raw.cast_to_raw(c => p_pass), 
                                                          r2 => hextoraw(c => p_salt)), 
                                    typ => dbms_crypto.hash_sh1);
                                    
    for i in 1..1023
    loop
       l_hash_pass := dbms_crypto.hash(src => l_hash_pass, typ => dbms_crypto.hash_sh1);
    end loop;
    
    return l_hash_pass || p_salt;
    
  end;
begin
  l_salt := rawtohex(dbms_crypto.RandomBytes(number_bytes => 10));
  dbms_output.put_line(l_salt);
  dbms_output.put_line(a => i_get_hash(p_pass => '1', p_salt => l_salt));
end;

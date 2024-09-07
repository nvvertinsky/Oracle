declare
  l_src_clob clob;
  l_blob blob;
  l_dest_clob clob;
  l_bytes varchar2(32767);
begin
  l_src_clob := 'Я'; -- Русская в кодировке БД: CL8MSWIN1251
  
  select dump(to_char(l_src_clob))
    into l_bytes
    from dual;
  
  dbms_output.put_line('Символ в кодировке БД CL8MSWIN1251: "' || l_src_clob || '" десятичный код символа: ' || l_bytes );
  
  dbms_lob.createtemporary(l_blob, true);
  dbms_lob.createtemporary(l_dest_clob, true);
  
  -- Мы говорим: Переведи clob в эту кодировку и уже новые коды символов сохрани в blob.
  declare
    l_dest_offset   integer := 1;
    l_source_offset integer := 1;
    l_lang_context  integer := dbms_lob.default_lang_ctx;
    l_warning       integer := dbms_lob.warn_inconvertible_char;
  begin
    dbms_lob.converttoblob(dest_lob     => l_blob,
                           src_clob     => l_src_clob,
                           amount       => dbms_lob.getlength(l_src_clob),
                           dest_offset  => l_dest_offset,
                           src_offset   => l_source_offset,
                           blob_csid    => nls_charset_id('AL32UTF8'),
                           lang_context => l_lang_context,
                           warning      => l_warning);
    
  end; 
  
  -- Мы говорим: Что в BLOB храняться байты, которые должны быть переведены в тестовые данные с помощью кодировки AL32UTF8 и затем переведены в кодировку БД CL8MSWIN1251
  declare
    l_dest_offset   integer := 1;
    l_source_offset integer := 1;
    l_lang_context  integer := dbms_lob.default_lang_ctx;
    l_warning       integer := dbms_lob.warn_inconvertible_char;
  begin
    dbms_lob.converttoclob(dest_lob     => l_dest_clob,
                           src_blob     => l_blob,
                           amount       => dbms_lob.lobmaxsize,
                           dest_offset  => l_dest_offset,
                           src_offset   => l_source_offset,
                           blob_csid    => nls_charset_id('AL32UTF8'), 
                           lang_context => l_lang_context,
                           warning      => l_warning);
  end;
  
  select dump(to_char(l_dest_clob))
    into l_bytes
    from dual;

  dbms_output.put_line('Результат в "' || to_char(l_dest_clob) ||  '" десятичный код символа: ' || l_bytes );
  
  dbms_lob.freetemporary(l_blob);
  dbms_lob.freetemporary(l_dest_clob);
end;


declare
  l_vch varchar2(10);
  l_bytes varchar2(32767);
  l_raw raw(32767);
begin
  l_vch := 'Я'; -- Русская в кодировке БД: CL8MSWIN1251
  
  select dump(l_vch)
    into l_bytes
    from dual;
 
  dbms_output.put_line('Символ в кодировке БД CL8MSWIN1251: "' || l_vch || '" десятичный код символа: ' || l_bytes );
  dbms_output.put_line('Перевожу в кодировку в AL32UTF8');
  
  l_vch := utl_raw.cast_to_varchar2(utl_i18n.string_to_raw(data => l_vch, dst_charset => 'AL32UTF8')); -- преобразовываем в UTF-8, изначальная кодировка Oracle считает кодировку БД. 
  
  select dump(l_vch)
    into l_bytes
    from dual;
  
  dbms_output.put_line('dbms_output выводит строку в кодировке 1251. Но сама строка в UTF-8 и вот что получается: ' || l_vch || ' код: ' || l_bytes);
  
  
  dbms_output.put_line('Перевожу обратно в CL8MSWIN1251');
  
  l_vch := convert(l_vch, 'CL8MSWIN1251', 'AL32UTF8');
    
  select dump(l_vch)
    into l_bytes
    from dual;
    
  dbms_output.put_line('Получилось: "' || l_vch || '" десятичный код символа: ' || l_bytes); 
end; 

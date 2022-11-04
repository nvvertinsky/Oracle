create or replace function parallel_pipelined(l_cursor in sys_refcursor) return t2_tab_type pipelined
parallel_enable(partition l_cursor by any) is -- позволяем Oracle самому выбрать подходящую степерь параллелизма
  l_session_id number;
  l_rec t1%rowtype;
begin
  select sid
    into l_session_id
    from v$mystat
   where rownum = 1;

  loop
    fetch l_cursor into l_rec;
    exit when l_cursor%notfound;
    -- что то делаем с данными
    pipe row(t2_type(l_rec.id, l_rec.text, l_session_id));
  end loop;
  close l_cursor;
  return;
end;
/


alter session enable parallel dml;
insert /*+ append*/ into select *
			   from table(parallel_pipelined(cursor(select /*+ parallel(t1) */ * from t1)));
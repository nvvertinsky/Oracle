-- 01. Даём гранты для работы с очередями.
grant create session to a;
alter user a quota unlimited on ts;
grant create table to a;
grant create trigger to a;
grant create synonym to a;
grant create sequence to a;
grant create procedure to a;
grant create type to a;
grant create view to a;
grant create materialized view to a;
grant execute on dbms_aqadm to a;
grant execute on dbms_aq to a;

-- 02. Создаём тип для сообщения в очереди
create or replace type pymt_obj as object(pymt_id number, amnt number);

-- 03. Создаём таблицу для очереди
begin
  dbms_aqadm.create_queue_table(queue_table => 'pymt_queue_tbl', queue_payload_type => 'pymt_obj');
end;

-- 04. Проверим что таблицы создались 
select * from pymt_queue_tbl; -- или посмотреть в словаре данных: select * from user_queue_tables;

-- 05. Создаём саму очередь
begin                     
  dbms_aqadm.create_queue(queue_name => 'pymt_queue', queue_table => 'pymt_queue_tbl');
end;

-- 06. Заупускаем очередь
begin           
  dbms_aqadm.start_queue(queue_name => 'pymt_queue');
end;

-- 07. Создаем таблицу логирования. Где будет отслеживать как отработало каждое сообщение в очереди. 
create table log_tbl(dt timestamp default systimestamp not null, msg varchar2(4000));


-- 08. Создадим спеку пакета
create or replace package pymt_queue_pkg is 
  -- Процедура Подписчик. Когда в очереди появляется сообщение, то автоматически выполняется процедура подписчика. 
  -- Должна иметь точную спецификацию как ниже.
  procedure subscriber(context in raw, 
                       reginfo in sys.aq$_reg_info,
                       descr in sys.aq$_descriptor,
                       payload in raw,
                       payload1 number);

end;

-- 09. Создадим тело пакета 
create or replace package body pymt_queue_pkg is

  procedure i_log(p_msg in log_tbl.msg%type) is 
  begin
    insert into log_tbl(msg) values (p_msg);
  end; 

  procedure subscriber(p_context in raw, 
                       p_reginfo in sys.aq$_reg_info,
                       p_descr in sys.aq$_descriptor,
                       p_payload in raw,
                       p_payload1 number) is 
    l_pymt_obj pymt_obj;
    l_queue_opts sys.dbms_aq.dequeue_options_t;
    l_msg_props sys.dbms_aq.message_properties_t;
    l_msg_id raw(16);
  begin
    l_queue_opts.consumer_name := p_descr.consumer_name;
    l_queue_opts.msgid := p_descr.msg_id;
    
    dbms_aq.dequeue(queue_name         => p_descr.queue_name,
                    dequeue_options    => l_queue_opts,
                    message_properties => l_msg_props,
                    payload            => l_pymt_obj,
                    msgid              => l_msg_id);
    
    do_something(l_pymt_obj); -- бизнес-логика
    i_log(l_pymt_obj.msg);
  exception
    when others then
      i_log(l_pymt_obj.msg || sqlerrm);
  end; 
end; 

-- 10. Регистрируем подписчика в очереди. 
begin
  dbms_aqadm.add_subscriber(queue_name     => 'pymt_queue',
                            subscriber     => sys.ag$_agent('pymt_subscriber', null, null),
                            rule           => null,
                            transformation => null);
  dbms_aq.register(reg_list => sys.aq$_reg_info_list(sys.aq$_reg_info('pymt_queue:pymt_subscriber', dbms_aq.namespace_aq, 'plsql://pkg_queue.subscriber', hextoraw('FF'))), reg_count => 1);
end; 


-- 11. Теперь достаточно добавить сообщение в очередь. 
declare
  l_msg_props   dbms_aq.message_properties_t;
  l_queue_opts  dbms_aq.enqueue_options_t;
  l_msg_id      raw(16);
begin
  dbms_aq.enqueue('pymt_queue', l_queue_opts, l_msg_props, pymt_obj(1, 100), l_msg_id);
  commit;
end;


-- https://innerlife.io/ru/oracle-db-advanced-queuing-subscriber-2/
-- https://gist.github.com/dbobylev/64206405cc800fd9dc27077a50076a9b
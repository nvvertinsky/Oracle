-- Использование XML схемы.

-- пакет dbms_xmlschema
-- registerSchema
-- deleteSchema
-- copyEvolve

begin
  dbms_xmlschema.registerSchema(schemaURL => '', schemaDoc => '');
end;

-- Пример валидации экземпляра XMLType по зарегистрированной схеме

declare
  xml_instance XMLType;
begin
  select ord
    into xml_instance
    from my_orders
   where my_orders = 3;
   
   if xml_instance.isSchemaValid() = 0 then
     null;
   else
     null;
   end if;
end;

-- ������������� XML �����.

-- ����� dbms_xmlschema
-- registerSchema
-- deleteSchema
-- copyEvolve

begin
  dbms_xmlschema.registerSchema(schemaURL => '', schemaDoc => '');
end;

-- ������ ��������� ���������� XMLType �� ������������������ �����

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

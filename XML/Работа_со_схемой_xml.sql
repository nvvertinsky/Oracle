-- Èñïîëüçîâàíèå XML ñõåìû.

-- ïàêåò dbms_xmlschema
-- registerSchema
-- deleteSchema
-- copyEvolve

begin
  dbms_xmlschema.registerSchema(schemaURL => '', schemaDoc => '');
end;

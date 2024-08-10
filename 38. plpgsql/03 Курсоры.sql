DO
$$
DECLARE
  rec record; -- нужно объявить явно
BEGIN
  FOR rec IN (SELECT * FROM t)
  LOOP
    RAISE NOTICE '%', rec;
  END LOOP;
  
  RAISE NOTICE 'Было ли что-то найдено в курсоре = %', FOUND;
END;
$$;
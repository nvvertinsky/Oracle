DO
$$
DECLARE
  l_id integer := 1;
  l_code text;
BEGIN
  SELECT id,
		 code
    INTO l_id,
		 l_code
	FROM t 
   WHERE t.id = l_id;
  
  RAISE NOTICE '%, %', l_id, l_code;
END;
$$;

DO
$$
DECLARE
  l_id integer;
  l_code text;
  l_rowcount integer;
  l_rowfound varchar;
BEGIN
  /*Запрос возвращает несколько строк. Без STRICT в переменную попадет только первая строка.
    Если запрос ничего не вернет, то в переменных будет null
	С STRICT будет ошибка с обоих случаях*/
  SELECT id,
		 code
    INTO /*STRICT*/ l_id,
				    l_code
	FROM t;
	
	-- Можно проверять сколько строк вернулось/обновилось/удалилось/вставилось
	GET DIAGNOSTICS l_rowcount = ROW_COUNT;
	GET DIAGNOSTICS l_rowfound = FOUND;
  
  RAISE NOTICE '%, %', l_id, l_code;
END;
$$;


CREATE FUNCTION do_something() RETURNS void as
$$
BEGIN
  RAISE NOTICE 'Что-то случилось';
END;
$$ LANGUAGE plpgsql;


DO
$$
BEGIN
  PERFORM do_something();
END;
$$


-- Табличная функция
CREATE FUNCTION t() RETURNS TABLE (LIKE t) AS
$$
BEGIN
  RETURN QUERY SELECT id, code FROM t ORDER BY id;
END;
$$ STABLE LANGUAGE plpgsql

select * from t();


-- Табличная функция, которая возвращает значения построчно
CREATE FUNCTION days_of_week() RETURNS SETOF text AS 
$$
BEGIN
  FOR i IN 7..13
  LOOP
    RETURN NEXT to_char(to_date(i::text, 'J'), 'TMDy');
  END LOOP;
END;
$$ STABLE LANGUAGE plpgsql;


SELECT * FROM days_of_week() WITH ORDINALITY; /*добавляет виртуальную колонку с порядком*/
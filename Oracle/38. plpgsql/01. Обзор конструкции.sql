DECLARE
  -- объявления 
BEGIN
  -- операторы
EXCEPTION
  -- обработка ошибок
END;

-- Важно:
-- BEGIN  - начало исполняемой секции в pl/pgsql - блоке
-- BEGIN; - команда SQL, открывающая транзакцию



-- Объявление функций
CREATE FUNCTION get_persn_name(in persn_id integer, /*INOUT name varchar*/) RETURNS varchar as 
$$
DECLARE
  l_name varchar;
BEGIN
  RETURN l_name;
END;
$$ LANGUAGE plpgsql /*VOLATILE, STABLE, IMMUTABLE,*/ /*STRICT - если в параметре значение null, то возвращаем null*/;


-- анонимные блоки
DO /*LANGUAGE plpgsql*/ 
$$ 
DECLARE
  -- объявления 
BEGIN
  -- операторы
  RAISE NOTICE '%, %', 'Hello', 'World'; -- выводим на экран
EXCEPTION
  -- обработка ошибок
END;
$$


-- Условные операторы как в pl/sql
-- Циклы как в pl/sql
-- \dL - какие языки допупны сейчас
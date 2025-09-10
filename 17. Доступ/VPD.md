# VPD

### Описание 
  - Позволяет ограничивать доступ к информации на уровне строк или столбцов.



### Шаг 1. Создаем функцию предикант
````
CREATE OR REPLACE FUNCTION get_salary_visibility (p_schema VARCHAR2, p_table VARCHAR2)
RETURN VARCHAR2 IS
  v_predicate VARCHAR2(1000);
BEGIN
  -- Получаем имя текущего пользователя
  DECLARE
    v_username VARCHAR2(30);
  BEGIN
    SELECT SYS_CONTEXT('USERENV', 'SESSION_USER') INTO v_username FROM dual;
    
    -- Определяем условие фильтрации данных в зависимости от роли пользователя
    IF v_username = 'HR_MANAGER' THEN
      v_predicate := '1=1'; -- HR-менеджеры видят все зарплаты
    ELSE
      v_predicate := 'ID = SYS_CONTEXT(''USERENV'', ''SESSION_USER'')'; -- Остальные пользователи видят только свою зарплату
    END IF;
  END;
  
  -- Возвращаем результат
  RETURN v_predicate;
END;
````


### Шаг 2. Создание политики
````
BEGIN
  -- Создаем политику доступа
  DBMS_RLS.ADD_POLICY(
    object_schema   => 'HR',
    object_name     => 'EMPLOYEES',
    policy_name     => 'SALARY_POLICY',
    function_schema => 'HR',
    policy_function => 'get_salary_visibility',
    statement_types => 'SELECT',
    update_check    => FALSE,
    enable          => TRUE
  );
END;
````


### Проверяем как работает. Заходим под HR_MANAGER
````
SELECT * FROM HR.EMPLOYEES;  # Увидит все данные по зарплате  
````


### Заходим под любым другим пользователем
````
SELECT * FROM HR.EMPLOYEES;  # Увидит только свои данные по зарплате. Так как его имя соответствует его идентификатору "ID".  
````
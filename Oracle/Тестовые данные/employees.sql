create table EMPLOYEES
(
  EMPLOYEE_ID    NUMBER(6) not null,
  FIRST_NAME     VARCHAR2(20),
  LAST_NAME      VARCHAR2(25) not null,
  EMAIL          VARCHAR2(25) not null,
  PHONE_NUMBER   VARCHAR2(20),
  HIRE_DATE      DATE not null,
  JOB_ID         VARCHAR2(10) not null,
  SALARY         NUMBER(8,2),
  COMMISSION_PCT NUMBER(2,2),
  MANAGER_ID     NUMBER(6),
  DEPARTMENT_ID  NUMBER(4)
);

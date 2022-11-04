create table JOB_HISTORY
(
  EMPLOYEE_ID   NUMBER(6) not null,
  START_DATE    DATE not null,
  END_DATE      DATE not null,
  JOB_ID        VARCHAR2(10) not null,
  DEPARTMENT_ID NUMBER(4)
);

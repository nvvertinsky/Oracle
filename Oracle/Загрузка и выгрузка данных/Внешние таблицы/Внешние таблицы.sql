--Директория. Псевдоним для каталога файловой системе на сервере или в сети, в котором размещены или будут размещены данные.
CREATE OR REPLACE DIRECTORY SQL_REBIRTH_14 AS '/mnt/oracle'

--Внешняя таблица
CREATE TABLE EXT_EMPS
(
   emp_id         number(6),
   first_name     varchar2(20),
   last_name      varchar2(25),
   email          varchar2(25),
   phone_num      varchar2(20),
   hire_date      varchar2(20),
   job_id         varchar2(10),
   salary         varchar2(10),
   commission_pct varchar2(10),
   manager_id     number(6),
   department_id  number(4)
)
ORGANIZATION EXTERNAL
(
TYPE ORACLE_LOADER -- тип драйвера: ORACLE_LOADER / ORACLE_DATAPUMP 
DEFAULT DIRECTORY SQL_REBIRTH_14 -- директории, в которых искать нужный файл
   ACCESS PARAMETERS
   (
     RECORDS DELIMITED BY NEWLINE
     NOLOGFILE
     NOBADFILE
     NODISCARDFILE
     SKIP 1
     FIELDS TERMINATED BY ';'
   )
   LOCATION (SQL_REBIRTH_14:'Emps.csv') -- директория и имя файла
 )
REJECT LIMIT UNLIMITED

create table LOCATIONS
(
  LOCATION_ID    NUMBER(4) not null,
  STREET_ASSRESS VARCHAR2(40),
  POSTAL_CODE    VARCHAR2(12),
  CITY           VARCHAR2(30) not null,
  STATE_PROVINCE VARCHAR2(25),
  COUNTRY_ID     CHAR(2)
);
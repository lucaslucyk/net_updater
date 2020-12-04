-- DROP tablespace TS_NETTIME_D including contents;
-- DROP tablespace TS_NETTIME_I including contents;

CREATE TABLESPACE TS_NETTIME_D LOGGING DATAFILE 'TS_NETTIME_D.ora' SIZE 250M AUTOEXTEND ON NEXT 10000K;

CREATE TABLESPACE TS_NETTIME_I LOGGING DATAFILE 'TS_NETTIME_I.ora' SIZE 150M AUTOEXTEND ON NEXT 10000K;

CREATE USER nettimeadm PROFILE "DEFAULT" IDENTIFIED BY "spec" DEFAULT TABLESPACE TS_NETTIME_D TEMPORARY TABLESPACE "TEMP" ACCOUNT UNLOCK;

GRANT CONNECT TO nettimeadm;

GRANT RESOURCE TO nettimeadm;

GRANT CREATE VIEW TO nettimeadm;

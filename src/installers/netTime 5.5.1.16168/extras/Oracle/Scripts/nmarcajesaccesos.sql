CREATE TABLE NMarcajesAccesos(
  IDMAR NUMBER NOT NULL,
  IDPER NUMBER NOT NULL,
  IDINC NUMBER NULL,
  IDTER NUMBER NULL,
  IDLEC NUMBER NULL,
  IDZONA NUMBER NULL,
  FECHA timestamp NOT NULL,
  ORIGEN NUMBER NULL,
  TIPO NUMBER NULL,
  ESTADO NUMBER NULL,
  TAR VARCHAR2(50) NULL,
  IP VARCHAR2(15) NULL,
  USUARIO VARCHAR2(250) NULL,
  ACCESO CHAR(1) NULL
) TABLESPACE TS_NETTIME_D;
/

CREATE UNIQUE INDEX NMARCAJESACCESOS_PK ON NMARCAJESACCESOS (
	IDMAR
) TABLESPACE TS_NETTIME_I;
/

CREATE INDEX NMARCAJESACCESOS_IDPER_FECHA ON NMARCAJESACCESOS (IDPER, FECHA) TABLESPACE TS_NETTIME_I;
/

CREATE INDEX NMARCAJESACCESOS_FECHA ON NMARCAJESACCESOS (FECHA) TABLESPACE TS_NETTIME_I;
/


ALTER TABLE NMARCAJESACCESOS ADD CONSTRAINT NMARCAJESACCESOS_PK PRIMARY KEY (IDMAR) USING INDEX TABLESPACE TS_NETTIME_I ENABLE;
/

create sequence IDMARACCSEQ minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20;
/


CREATE OR REPLACE PROCEDURE ResetIDMARACCSEQ AS

cval   INTEGER;
inc_by VARCHAR2(25);
startvalue integer;

BEGIN
  SELECT NVL(MAX(IDMAR), 0)+1 INTO startvalue FROM NMARCAJES;
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDMARACCSEQ MINVALUE 0';
  EXECUTE IMMEDIATE 'SELECT IDMARACCSEQ.NEXTVAL FROM dual' INTO cval;

  cval := cval - startvalue + 1;
  IF cval < 0 THEN
    inc_by := ' INCREMENT BY ';
    cval:= ABS(cval);
  ELSE
    inc_by := ' INCREMENT BY -';
  END IF;
   
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDMARACCSEQ ' || inc_by || cval;
  EXECUTE IMMEDIATE 'SELECT IDMARACCSEQ.NEXTVAL FROM dual' INTO cval;
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDMARACCSEQ INCREMENT BY 1';

END;
/


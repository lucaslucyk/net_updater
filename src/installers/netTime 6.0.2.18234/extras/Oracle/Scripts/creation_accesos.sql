
create or replace function TipoMarcaje(paramISOK char, paramTIPOMARCAJE int, paramTIPO int) return char deterministic is
begin
	if (paramTIPOMARCAJE = 0) then
		return(1);
	end if;

	if(	(paramISOK = 1 AND paramTIPOMARCAJE = BITAND(paramTIPO, paramTIPOMARCAJE)) OR (paramISOK = 0 AND 0 = BITAND(paramTIPO, paramTIPOMARCAJE))	) then
		return(1);
	end if;
	return(0);
end;
/

CREATE OR REPLACE PROCEDURE GuardarMarcajeAccesos(paramIDPER   IN int DEFAULT NULL,
                                            paramIDINC   IN int DEFAULT NULL,
                                            paramIDTER   IN int DEFAULT NULL,
                                            paramIDLEC   IN int DEFAULT NULL,
                                            paramIDZONA  IN int DEFAULT NULL,
                                            paramFECHA   IN timestamp DEFAULT NULL,
                                            paramORIGEN  IN int DEFAULT NULL,
                                            paramTIPO    IN int DEFAULT NULL,
                                            paramESTADO  IN int DEFAULT NULL,
                                            paramTAR     IN VARCHAR2 DEFAULT NULL,
                                            paramIP      IN VARCHAR2 DEFAULT NULL,
                                            paramUSUARIO IN VARCHAR2 DEFAULT NULL,
                                            paramACCESO  IN CHAR DEFAULT NULL) AS
BEGIN
   INSERT INTO NMarcajesAccesos
      (IDMAR,
       IDPER,
       IDINC,
       IDTER,
       IDLEC,
       IDZONA,
       FECHA,
       ORIGEN,
       TIPO,
       ESTADO,
       TAR,
       IP,
       USUARIO,
       ACCESO)
    VALUES
      (IDMARACCSEQ.nextval,
       paramIDPER,
       paramIDINC,
       paramIDTER,
       paramIDLEC,
       paramIDZONA,
       paramFECHA,
       paramORIGEN,
       paramTIPO,
       paramESTADO,
       paramTAR,
       paramIP,
       paramUSUARIO,
       paramACCESO);
END;
/


CREATE OR REPLACE PROCEDURE ObtenerMarcajesAccesos( paramFECHAMIN IN timestamp DEFAULT NULL,
																										paramFECHAMAX IN timestamp DEFAULT NULL,
																										paramISOK IN	char DEFAULT NULL,
																										paramTIPOMARCAJE	smallint DEFAULT NULL,
																										RCT1 IN OUT GLOBALPKG.RCT1) AS
BEGIN
  OPEN RCT1 FOR
		SELECT IDMAR, IDPER, IDINC, IDTER, IDLEC, IDZONA, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, USUARIO, ACCESO 
		FROM NMarcajesAccesos M1  
		WHERE  FECHA >= paramFECHAMIN and FECHA <= paramFECHAMAX AND TipoMarcaje(paramISOK, paramTIPOMARCAJE, TIPO) = 1
		ORDER BY FECHA, IDMAR;
END;
/

CREATE OR REPLACE PROCEDURE ObtenerAccesosPersona(	paramIDPERSONA IN int DEFAULT NULL,
																										paramFECHAMIN IN timestamp DEFAULT NULL,
																										paramFECHAMAX IN timestamp DEFAULT NULL,
																										paramISOK IN	char DEFAULT NULL,
																										paramTIPOMARCAJE	smallint DEFAULT NULL,
																										RCT1 IN OUT GLOBALPKG.RCT1) AS
BEGIN
  OPEN RCT1 FOR
		SELECT IDMAR, IDPER, IDINC, IDTER, IDLEC, IDZONA, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, USUARIO, ACCESO 
		FROM NMarcajesAccesos M1  
		WHERE IDPER = paramIDPERSONA AND FECHA >= paramFECHAMIN and FECHA <= paramFECHAMAX AND TipoMarcaje(paramISOK, paramTIPOMARCAJE, TIPO) = 1;
END;
/

CREATE OR REPLACE PROCEDURE ObtenerAccesosPersonaPosterior(	paramIDPERSONA IN int DEFAULT NULL,
																										paramFECHA IN timestamp DEFAULT NULL,
																										paramISOK IN	char DEFAULT NULL,
																										paramTIPOMARCAJE	smallint DEFAULT NULL,
																										RCT1 IN OUT GLOBALPKG.RCT1) AS
BEGIN
  OPEN RCT1 FOR
		SELECT IDMAR, IDPER, IDINC, IDTER, IDLEC, IDZONA, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, USUARIO, ACCESO 
		FROM NMarcajesAccesos M1  
		WHERE IDPER = paramIDPERSONA AND FECHA > paramFECHA AND ESTADO = 0 AND TipoMarcaje(paramISOK, paramTIPOMARCAJE, TIPO) = 1
		ORDER BY  IDPER, FECHA DESC;
END;
/

CREATE OR REPLACE PROCEDURE ObtenerAccesosZonasCorrectos(	paramIDZONAS IN VARCHAR2 DEFAULT NULL,
																										paramFECHAMIN IN timestamp DEFAULT NULL,
																										paramFECHAMAX IN timestamp DEFAULT NULL,
																										paramISOK IN	char DEFAULT NULL,
																										paramTIPOMARCAJE	smallint DEFAULT NULL,
																										RCT1 IN OUT GLOBALPKG.RCT1) AS
BEGIN
  OPEN RCT1 FOR
		SELECT IDMAR, IDPER, IDINC, IDTER, IDLEC, IDZONA, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, USUARIO, ACCESO 
		FROM NMarcajesAccesos M1 JOIN TABLE(TableFromString(paramIDZONAS)) S
				ON
				M1.IDZONA  = S.column_value
			WHERE  ESTADO = 0 AND FECHA >= paramFECHAMIN and FECHA <= paramFECHAMAX AND 
				TipoMarcaje(paramISOK, paramTIPOMARCAJE, TIPO) = 1
			ORDER BY FECHA DESC;
END;
/

create or replace function IDMARMasReciente(idPersona int, paramISOK char, tipoMar int, fechaMax timestamp) return int as
PEPE int default 0;
begin
   SELECT IDMAR into PEPE FROM (
      SELECT IDMAR FROM NMarcajesAccesos M2
        WHERE
          M2.IDPER = idPersona AND
          M2.ESTADO = 0 AND
          M2.FECHA <= fechaMax AND
          TipoMarcaje(paramISOK, tipoMar, M2.TIPO) = 1
        ORDER BY M2.FECHA DESC)
        WHERE ROWNUM < 2;

  return PEPE;
end;
/


CREATE OR REPLACE PROCEDURE ObtenerUltAccCorrectosZona(  paramIDZONA IN int DEFAULT NULL,
                                                    paramFECHAMIN IN timestamp DEFAULT NULL,
                                                    paramFECHAMAX IN timestamp DEFAULT NULL,
                                                    paramISOK IN  char DEFAULT NULL,
                                                    paramTIPOMARCAJE  smallint DEFAULT NULL,
                                                    RCT1 IN OUT GLOBALPKG.RCT1) AS
BEGIN
  OPEN RCT1 FOR
    SELECT IDMAR, IDPER, IDINC, IDTER, IDLEC, IDZONA, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, USER, ACCESO
    FROM NMarcajesAccesos M1
    WHERE
			M1.IDZONA = paramIDZONA AND
			M1.ESTADO = 0 AND
			TipoMarcaje(paramISOK, paramTIPOMARCAJE, M1.TIPO) = 1 AND
			M1.FECHA >= paramFECHAMIN AND
      M1.IDMAR = IDMARMasReciente(M1.IDPER, paramISOK, paramTIPOMARCAJE, paramFECHAMAX)
			ORDER BY IDMAR;
END;
/

CREATE OR REPLACE PROCEDURE ObtenerUltAccCorrectoPersona(	paramIDPERSONA IN int DEFAULT NULL,
																										paramFECHAMIN IN timestamp DEFAULT NULL,
																										paramFECHAMAX IN timestamp DEFAULT NULL,
																										paramISOK IN	CHAR DEFAULT NULL,
																										paramTIPOMARCAJE	smallint DEFAULT NULL,
																										RCT1 IN OUT GLOBALPKG.RCT1) AS
BEGIN
  OPEN RCT1 FOR
		SELECT * FROM (
			SELECT IDMAR, IDPER, IDINC, IDTER, IDLEC, IDZONA, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, USUARIO, ACCESO FROM NMarcajesAccesos M1 
				WHERE
					M1.IDPER = paramIDPERSONA AND 
					M1.ESTADO = 0 AND 
					M1.FECHA >= paramFECHAMIN AND
					M1.FECHA <= paramFECHAMAX AND
					TipoMarcaje(paramISOK, paramTIPOMARCAJE, TIPO) = 1
				ORDER BY FECHA DESC, IDMAR DESC)
			WHERE ROWNUM < 2;
END;
/

/* INIT Gestion de sesiones */

create sequence IDSESSEQ minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20;
/

CREATE OR REPLACE PROCEDURE ResetIDSESSEQ AS

cval   INTEGER;
inc_by VARCHAR2(25);
startvalue integer;

BEGIN
  SELECT NVL(MAX(ID), 0)+1 INTO startvalue FROM Sessions;
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDSESSEQ MINVALUE 0';
  EXECUTE IMMEDIATE 'SELECT IDSESSEQ.NEXTVAL FROM dual' INTO cval;

  cval := cval - startvalue + 1;
  IF cval < 0 THEN
    inc_by := ' INCREMENT BY ';
    cval:= ABS(cval);
  ELSE
    inc_by := ' INCREMENT BY -';
  END IF;
   
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDSESSEQ ' || inc_by || cval;
  EXECUTE IMMEDIATE 'SELECT IDSESSEQ.NEXTVAL FROM dual' INTO cval;
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDSESSEQ INCREMENT BY 1';

END;
/

CREATE OR REPLACE PROCEDURE OpenSession(	paramUNAME IN varchar2 DEFAULT NULL,
																										paramIP IN varchar2 DEFAULT NULL,
																										paramAuthType IN varchar2 DEFAULT NULL,
																										paramSTART IN	timestamp DEFAULT NULL,
																										RCT1 IN OUT GLOBALPKG.RCT1) AS
newIDSES int := 0;
BEGIN
  SELECT IDSESSEQ.nextval INTO newIDSES FROM DUAL;

	INSERT INTO Sessions (ID, UNAME, IP, AuthType, START_)
	VALUES (newIDSES, paramUNAME, paramIP, paramAuthType, paramSTART);

  OPEN RCT1 FOR
    SELECT newIDSES FROM SYS.DUAL;

END;
/

CREATE OR REPLACE PROCEDURE CloseSession(	paramIDSES IN int DEFAULT NULL, paramEND IN timestamp DEFAULT NULL) AS
BEGIN
	UPDATE Sessions SET END = paramEND WHERE ID = paramIDSES;
END;
/


CREATE OR REPLACE PROCEDURE AddSessionDetail(	paramIDSES IN int DEFAULT NULL,
																							paramTS IN timestamp DEFAULT NULL,
																							paramURL IN varchar2 DEFAULT NULL,
																							paramDATA IN blob DEFAULT NULL) AS
BEGIN
	INSERT INTO SessionDetail (IDSES, TS, URL, DATA)
	VALUES (paramIDSES, paramTS, paramURL, paramDATA);
END;
/


CREATE OR REPLACE PROCEDURE GetSession(	paramIDSES IN int DEFAULT NULL,
																							RCT1 IN OUT GLOBALPKG.RCT1) AS
BEGIN
	OPEN RCT1 FOR SELECT UNAME, IP FROM Sessions WHERE ID = paramIDSES;
END;
/

/* FIN Gestion de sesiones */

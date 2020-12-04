/*

TODO: Update IDMARSEQ una vez finalizada la recuperación de marcajes!!!

*/


CREATE OR REPLACE PACKAGE GLOBALPKG
AS
  TYPE RCT1 IS REF CURSOR;
  TRANCOUNT INTEGER := 0;
  IDENTITY INTEGER;
END;
/

create or replace function hex_to_number(hex in string) return number is
	num number default 0;
	tmp number default 0;
	work_str varchar2(255) default NULL;
	begin
		for i in 1..length(hex) loop
			work_str := substr(hex, i, 1);
			if Upper(work_str) = 'A' then
				tmp := 10;
			elsif Upper(work_str) = 'B' then
				tmp := 11;
			elsif Upper(work_str) = 'C' then
				tmp := 12;
			elsif Upper(work_str) = 'D' then
				tmp := 13;
			elsif Upper(work_str) = 'E' then
				tmp := 14;
			elsif Upper(work_str) = 'F' then
				tmp := 15;
			else
				tmp := to_number(work_str);
			end if;
			num := num*16 + tmp;
		end loop;
	return num;
end hex_to_number; 
/

create sequence IDDIASEQ minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20;
/

CREATE OR REPLACE PROCEDURE GuardarDia_v2(paramIDPER   IN int DEFAULT NULL,
                                         paramFECHA   IN timestamp DEFAULT NULL,
                                         paramIDJOR   IN int DEFAULT NULL,
                                         paramTM      IN int DEFAULT NULL,
                                         paramIDANO   IN int DEFAULT NULL,
                                         paramVALORES IN RAW DEFAULT NULL,
                                         paramMINFIN  IN int DEFAULT NULL,
                                         paramDragTT  IN int DEFAULT NULL,
                                         paramDaysTT  IN int DEFAULT NULL,
                                         paramDragWA  IN int DEFAULT NULL,
                                         paramDaysWA  IN int DEFAULT NULL,
                                         paramDragWO  IN int DEFAULT NULL,
                                         paramDaysWO  IN int DEFAULT NULL) AS
BEGIN

merge into DIAS using dual on (IDPER = paramIDPER and FECHA = paramFECHA)
 when not matched then INSERT (IDDIA, IDPER, FECHA, IDJOR, TM, IDANO, VALORES, MINFIN, DragTT, DaysTT, DragWA, DaysWA, DragWO, DaysWO)
  VALUES (IDDIASEQ.nextval, paramIDPER, paramFECHA, paramIDJOR, paramTM, paramIDANO, paramVALORES, paramMINFIN, paramDragTT, paramDaysTT, paramDragWA, paramDaysWA, paramDragWO, paramDaysWO)
     when matched then UPDATE SET IDJOR = paramIDJOR, TM = paramTM, IDANO = paramIDANO, VALORES = paramVALORES, MINFIN = paramMINFIN, DragTT = paramDragTT, DaysTT = paramDaysTT, DragWA = paramDragWA, DaysWA = paramDaysWA, DragWO = paramDragWO, DaysWO = paramDaysWO;
END; 
/

create or replace type IntList as TABLE OF integer;
/

create or replace function TableFromString(lv_string string) return IntList is
  Result IntList := IntList();
  lv_length               Number(38)   := length(lv_string);
  lv_appendstring         Varchar2(1000);
  lv_resultstring         Varchar2(100);
  lv_count                Number(2);

begin
    lv_appendstring := lv_string||',';
    for i in 1..lv_length loop
      lv_resultstring:=substr(lv_appendstring,1,(instr(lv_appendstring,',')-1));
      lv_count:=instr(lv_appendstring,',')+1;
      lv_appendstring:=substr(lv_appendstring,lv_count,length(lv_appendstring));
      if length(trim(lv_resultstring)) > 0 THEN
            Result.EXTEND;
            Result(Result.LAST) := to_number(lv_resultstring);
      end if;
      exit when (lv_count=0);
    end loop;

    return(Result);
end TableFromString;
/

CREATE OR REPLACE PROCEDURE ObtenerDiasxPersonaxFecha_v2(paramIDPER    IN int DEFAULT NULL,
                                                        FECHAINI IN timestamp DEFAULT NULL,
                                                        FECHAFIN IN timestamp DEFAULT NULL,
                                                        RCT1     IN OUT GLOBALPKG.RCT1) AS
BEGIN

  OPEN RCT1 FOR
    SELECT IDPER, FECHA, IDJOR, TM, IDANO, VALORES, IDDIA, MINFIN, DragTT, DaysTT, DragWA, DaysWA, DragWO, DaysWO
      FROM DIAS
     WHERE IDPER = paramIDPER
       AND FECHA >= FECHAINI
       AND FECHA < FECHAFIN
     ORDER BY FECHA;
END;
/

create sequence IDMARSEQ minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20;
/

CREATE OR REPLACE PROCEDURE GuardaMarcaje(paramIDMAR   IN int DEFAULT NULL,
                                            paramIDPER   IN int DEFAULT NULL,
                                            paramIDINC   IN int DEFAULT NULL,
                                            paramIDTER   IN int DEFAULT NULL,
                                            paramIDLEC   IN int DEFAULT NULL,
                                            paramFECHA   IN timestamp DEFAULT NULL,
                                            paramORIGEN  IN int DEFAULT NULL,
                                            paramTIPO    IN int DEFAULT NULL,
                                            paramESTADO  IN int DEFAULT NULL,
                                            paramTAR     IN VARCHAR2 DEFAULT NULL,
                                            paramIP      IN VARCHAR2 DEFAULT NULL,
                                            paramUSUARIO IN VARCHAR2 DEFAULT NULL,
                                            paramACCESO  IN CHAR DEFAULT NULL,
                                            paramLAT		 IN decimal DEFAULT NULL,
                                            paramLON		 IN decimal DEFAULT NULL,
                                            paramMOBILEID	IN VARCHAR2 DEFAULT NULL,
											paramCRC IN int DEFAULT NULL,
                                            RCT1 IN OUT GLOBALPKG.RCT1) AS
newIDMAR int := paramIDMAR;
BEGIN
  IF (newIDMAR = -1) THEN SELECT IDMARSEQ.nextval INTO newIDMAR FROM DUAL; END IF;

    INSERT INTO NMarcajes
      (IDMAR,
       IDPER,
       IDINC,
       IDTER,
       IDLEC,
       FECHA,
       ORIGEN,
       TIPO,
       ESTADO,
       TAR,
       IP,
       USUARIO,
       ACCESO,
		LAT,
		LON,
		MOBILEID,
		CRC)
    VALUES
      (newIDMAR,
       paramIDPER,
       paramIDINC,
       paramIDTER,
       paramIDLEC,
       paramFECHA,
       paramORIGEN,
       paramTIPO,
       paramESTADO,
       paramTAR,
       paramIP,
       paramUSUARIO,
       paramACCESO,
       paramLAT,
       paramLON,
       paramMOBILEID,
	   paramCRC);

  OPEN RCT1 FOR
    SELECT newIDMAR FROM SYS.DUAL;

END;
/

CREATE OR REPLACE PROCEDURE ObtenerMarcajesXPersonaYFec_v2(paramIdPer IN int DEFAULT NULL,
                                                          paramFecha    IN timestamp DEFAULT NULL,
                                                          LastFecha     IN timestamp DEFAULT NULL,
                                                          RCT1          IN OUT GLOBALPKG.RCT1) AS
BEGIN

  OPEN RCT1 FOR
    SELECT IDMAR,
           FECHA,
           IDPER,
           IDTER,
           IDLEC,
           IDINC,
           ORIGEN,
           TIPO,
           ESTADO,
           TAR,
           IP,
           USUARIO,
           LAT,
           LON,
           MOBILEID,
		   CRC
      FROM NMarcajes
     WHERE IDPER = paramIdPer AND FECHA >= paramFecha AND FECHA <= LastFecha
  ORDER BY FECHA, IDMAR;

END;
/

CREATE OR REPLACE PROCEDURE ObtenerMarcajeXIDMAR(paramIDMAR IN int DEFAULT NULL,
                                                   RCT1  IN OUT GLOBALPKG.RCT1) AS
BEGIN

  OPEN RCT1 FOR
    SELECT IDMAR,
           FECHA,
           IDPER,
           IDTER,
           IDLEC,
           IDINC,
           ORIGEN,
           TIPO,
           ESTADO,
           TAR,
           IP,
           USUARIO,
           LAT,
           LON,
           MOBILEID,
		   CRC
      FROM NMarcajes
     WHERE IDMAR = paramIDMAR;
END;
/

CREATE OR REPLACE PROCEDURE ModificaMarcaje(paramIDMAR   IN int DEFAULT NULL,
                                              paramIDPER   IN int DEFAULT NULL,
                                              paramIDINC   IN int DEFAULT NULL,
                                              paramIDTER   IN int DEFAULT NULL,
                                              paramIDLEC   IN int DEFAULT NULL,
                                              paramFECHA   IN timestamp DEFAULT NULL,
                                              paramORIGEN  IN int DEFAULT NULL,
                                              paramTIPO    IN int DEFAULT NULL,
                                              paramESTADO  IN int DEFAULT NULL,
                                              paramTAR     IN VARCHAR2 DEFAULT NULL,
                                              paramIP      IN VARCHAR2 DEFAULT NULL,
                                              paramUSUARIO IN VARCHAR2 DEFAULT NULL,
                                              paramACCESO  IN CHAR DEFAULT NULL,
                                              paramLAT		 IN decimal DEFAULT NULL,
                                              paramLON		 IN decimal DEFAULT NULL,
                                              paramMOBILEID	IN VARCHAR2 DEFAULT NULL) AS
BEGIN

  UPDATE NMarcajes
     SET IDPER   = paramIDPER,
         IDINC   = paramIDINC,
         IDTER   = paramIDTER,
         IDLEC   = paramIDLEC,
         FECHA   = paramFECHA,
         ORIGEN  = paramORIGEN,
         TIPO    = paramTIPO,
         ESTADO  = paramESTADO,
         TAR     = paramTAR,
         IP      = paramIP,
         USUARIO = paramUSUARIO,
         ACCESO  = paramACCESO,
				 LAT		 = paramLAT,
				 LON		 = paramLON,
				 MOBILEID = paramMOBILEID
   WHERE IDMAR = paramIDMAR;
END;
/

CREATE OR REPLACE PROCEDURE EliminarMarcaje(paramIDMAR IN int DEFAULT NULL, RCT1 IN OUT GLOBALPKG.RCT1) AS
rowsAffected int := 0;
BEGIN
  DELETE FROM NMarcajes WHERE IDMAR = paramIDMAR RETURNING count(IDMAR) INTO rowsAffected;
  OPEN RCT1 FOR SELECT rowsAffected from SYS.DUAL;
END;
/

CREATE OR REPLACE PROCEDURE EliminarMarcajesXPersonaYfecha(paramIDPER      IN int DEFAULT NULL,
                                                           paramFECHA      IN timestamp DEFAULT NULL,
                                                           FECHADESDE IN timestamp DEFAULT NULL,
                                                           FECHAHASTA IN timestamp DEFAULT NULL,
                                                           RCT1 IN OUT GLOBALPKG.RCT1) AS
    allDayFlag int := HEX_TO_NUMBER('8000000');
    rowsAffected int := 0;
BEGIN

  DELETE NMarcajes
   WHERE IDPER = paramIDPER
     AND (
         (FECHA >= FECHADESDE AND FECHA <= FECHAHASTA AND BITAND(TIPO, allDayFlag) = 0) OR
         (FECHA = paramFECHA AND BITAND(TIPO, allDayFlag) = allDayFlag))
          RETURNING count(IDMAR) INTO rowsAffected;
  OPEN RCT1 FOR SELECT rowsAffected from SYS.DUAL;
END;
/

CREATE OR REPLACE PROCEDURE EliminarMarcajesXPersonaYfech2(paramIDPER      IN int DEFAULT NULL,
                                                           FECHADESDE IN timestamp DEFAULT NULL,
                                                           FECHAHASTA IN timestamp DEFAULT NULL,
                                                           RCT1 IN OUT GLOBALPKG.RCT1) AS
    rowsAffected int := 0;
BEGIN

  IF (FECHADESDE is null AND FECHAHASTA is null) THEN
    BEGIN
      DELETE NMarcajes WHERE IDPER = paramIDPER RETURNING count(IDMAR) INTO rowsAffected;
    END;
  ELSE
    IF (FECHADESDE is null) THEN
     BEGIN
      DELETE NMarcajes WHERE IDPER = paramIDPER AND FECHA <= FECHAHASTA RETURNING count(IDMAR) INTO rowsAffected; 
     END;
  	ELSE
     IF (FECHAHASTA is null) THEN
       BEGIN
         DELETE NMarcajes WHERE IDPER = paramIDPER AND FECHA >= FECHADESDE RETURNING count(IDMAR) INTO rowsAffected; 
       END;
	 ELSE
       BEGIN
         DELETE NMarcajes WHERE IDPER = paramIDPER AND (FECHA >= FECHADESDE AND FECHA <= FECHAHASTA) RETURNING count(IDMAR) INTO rowsAffected;
       END;
	 END IF;
	END IF;
  END IF;

  OPEN RCT1 FOR SELECT rowsAffected from SYS.DUAL;
END;
/

CREATE OR REPLACE PROCEDURE EliminarDiasxPersonaxFecha(paramIDPER    IN int DEFAULT NULL,
                                                       FECHAINI IN timestamp DEFAULT NULL,
                                                       FECHAFIN IN timestamp DEFAULT NULL) AS
BEGIN
  IF (FECHAINI is null AND FECHAFIN is null) THEN
    BEGIN
      delete DIAS where IDPER = paramIDPER;
    END;
  ELSE
    BEGIN
      IF (FECHAINI is not null AND FECHAFIN is not null) THEN
        BEGIN
          delete from DIAS where IDPER = paramIDPER AND FECHA >= FECHAINI AND FECHA <= FECHAFIN;
        END;
      ELSE
        BEGIN
          IF (FECHAFIN is null) THEN
            BEGIN
              delete DIAS where IDPER = paramIDPER AND FECHA >= FECHAINI;
            END;
          ELSE
            BEGIN
              delete DIAS where IDPER = paramIDPER AND FECHA <= FECHAFIN;
            END;
          END IF;
        END;
      END IF;
    END;
  END IF;
END; 
/

CREATE OR REPLACE PROCEDURE GuardarElemento(paramIDTYPE IN int DEFAULT NULL,
                                            paramIDELEM IN int DEFAULT NULL,
                                            paramNAME   IN VARCHAR2 DEFAULT NULL,
                                            paramDATA   IN blob DEFAULT NULL) AS
BEGIN

merge into AppData using dual on (IDTYPE = paramIDTYPE AND IDELEM = paramIDELEM)
 when not matched then INSERT (IDTYPE, IDELEM, NAME, DATA) VALUES (paramIDTYPE, paramIDELEM, paramNAME, paramDATA)
     when matched then UPDATE SET NAME = paramNAME, DATA = paramDATA;
END;
/

CREATE OR REPLACE PROCEDURE ObtenerElementosXIdType(paramIDTYPE IN int DEFAULT NULL,
                                                    RCT1 IN OUT GLOBALPKG.RCT1) AS
BEGIN

  OPEN RCT1 FOR
    SELECT IDTYPE, IDELEM, NAME, DATA
      FROM AppData
     WHERE IDTYPE = paramIDTYPE;
END;
/


CREATE OR REPLACE PROCEDURE ObtenerElementoXIdTypeXIdelem(paramIDTYPE IN int DEFAULT NULL,
                                                          paramIDELEM IN int DEFAULT NULL,
                                                          RCT1   IN OUT GLOBALPKG.RCT1) AS
BEGIN

  OPEN RCT1 FOR
    SELECT IDTYPE, IDELEM, NAME, DATA
      FROM AppData
     WHERE IDTYPE = paramIDTYPE
       AND IDELEM = paramIDELEM;
END;
/

CREATE OR REPLACE PROCEDURE EliminarElementoXIdTypeXIdelem(paramIDTYPE IN int DEFAULT NULL,
                                                           paramIDELEM IN int DEFAULT NULL) AS
BEGIN

  DELETE FROM AppData
   WHERE IDTYPE = paramIDTYPE
     AND IDELEM = paramIDELEM;
END;
/

CREATE OR REPLACE PROCEDURE ResetIDMARSEQ AS

cval   INTEGER;
inc_by VARCHAR2(25);
startvalue integer;

BEGIN
  SELECT NVL(MAX(IDMAR), 0)+1 INTO startvalue FROM NMARCAJES;
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDMARSEQ MINVALUE 0';
  EXECUTE IMMEDIATE 'SELECT IDMARSEQ.NEXTVAL FROM dual' INTO cval;

  cval := cval - startvalue + 1;
  IF cval < 0 THEN
    inc_by := ' INCREMENT BY ';
    cval:= ABS(cval);
  ELSE
    inc_by := ' INCREMENT BY -';
  END IF;
   
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDMARSEQ ' || inc_by || cval;
  EXECUTE IMMEDIATE 'SELECT IDMARSEQ.NEXTVAL FROM dual' INTO cval;
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDMARSEQ INCREMENT BY 1';

END;
/

CREATE OR REPLACE PROCEDURE ResetIDDIASEQ AS

cval   INTEGER;
inc_by VARCHAR2(25);
startvalue integer;

BEGIN
  SELECT NVL(MAX(IDDIA), 0)+1 INTO startvalue FROM DIAS;
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDDIASEQ MINVALUE 0';
  EXECUTE IMMEDIATE 'SELECT IDDIASEQ.NEXTVAL FROM dual' INTO cval;

  cval := cval - startvalue + 1;
  IF cval < 0 THEN
    inc_by := ' INCREMENT BY ';
    cval:= ABS(cval);
  ELSE
    inc_by := ' INCREMENT BY -';
  END IF;
   
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDDIASEQ ' || inc_by || cval;
  EXECUTE IMMEDIATE 'SELECT IDDIASEQ.NEXTVAL FROM dual' INTO cval;
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDDIASEQ INCREMENT BY 1';

END;
/

CREATE OR REPLACE PROCEDURE ResetIDNOTISEQ AS

cval   INTEGER;
inc_by VARCHAR2(25);
startvalue integer;

BEGIN
  SELECT NVL(MAX(ID), 0)+1 INTO startvalue FROM NOTIFICACIONES;
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDNOTISEQ MINVALUE 0';
  EXECUTE IMMEDIATE 'SELECT IDNOTISEQ.NEXTVAL FROM dual' INTO cval;

  cval := cval - startvalue + 1;
  IF cval < 0 THEN
    inc_by := ' INCREMENT BY ';
    cval:= ABS(cval);
  ELSE
    inc_by := ' INCREMENT BY -';
  END IF;
   
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDNOTISEQ ' || inc_by || cval;
  EXECUTE IMMEDIATE 'SELECT IDNOTISEQ.NEXTVAL FROM dual' INTO cval;
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDNOTISEQ INCREMENT BY 1';

END;
/

create sequence IDMSGSEQ minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20;
/

CREATE OR REPLACE PROCEDURE ResetIDMSGSEQ AS

cval   INTEGER;
inc_by VARCHAR2(25);
startvalue integer;

BEGIN
  SELECT NVL(MAX(IDMSG), 0)+1 INTO startvalue FROM MENSAJES;
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDMSGSEQ MINVALUE 0';
  EXECUTE IMMEDIATE 'SELECT IDMSGSEQ.NEXTVAL FROM dual' INTO cval;

  cval := cval - startvalue + 1;
  IF cval < 0 THEN
    inc_by := ' INCREMENT BY ';
    cval:= ABS(cval);
  ELSE
    inc_by := ' INCREMENT BY -';
  END IF;
   
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDMSGSEQ ' || inc_by || cval;
  EXECUTE IMMEDIATE 'SELECT IDMSGSEQ.NEXTVAL FROM dual' INTO cval;
  EXECUTE IMMEDIATE 'ALTER SEQUENCE IDMSGSEQ INCREMENT BY 1';

END;
/


-- ============================================= 
-- Author:		JLL 
-- Create date: 30/5/2006 
-- Description:	Devuelve las anomalias entre las fechas especificadas para 1 usuario 
-- ============================================= 
CREATE OR REPLACE PROCEDURE ObtenerAnomaliasXIdXFecha(paramIDANO IN int DEFAULT NULL,
                                                        FECHAINI IN timestamp DEFAULT NULL,
                                                        FECHAFIN IN timestamp DEFAULT NULL,
                                                        RCT1     IN OUT GLOBALPKG.RCT1) AS
BEGIN
  IF paramIDANO = 0 THEN
    BEGIN

      OPEN RCT1 FOR
        SELECT *
          FROM DIAS
         WHERE IDANO <> paramIDANO
           AND FECHA >= FECHAINI
           AND FECHA <= FECHAFIN
         ORDER BY FECHA, IDPER;
    END;
  ELSE
    BEGIN

      OPEN RCT1 FOR
        SELECT *
          FROM DIAS
         WHERE IDANO = paramIDANO
           AND FECHA >= FECHAINI
           AND FECHA <= FECHAFIN
         ORDER BY FECHA, IDPER;
    END;
  END IF;
END;
/

-- sequence para la tabla Notificaciones
create sequence IDNOTISEQ minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20;
/

CREATE OR REPLACE PROCEDURE GuardarNotificacion(paramID         IN int DEFAULT NULL,
                                                paramTIPO       IN int DEFAULT NULL,
                                                paramFINALIZADA IN number DEFAULT NULL,
                                                paramTEXTO      IN VARCHAR2 DEFAULT NULL,
                                                paramCREACION   IN timestamp DEFAULT NULL,
                                                paramFIN        IN timestamp DEFAULT NULL,
                                                paramIDPER      IN int DEFAULT NULL,
                                                paramFECHA      IN timestamp DEFAULT NULL) AS
newIDNOTI int := paramID;
BEGIN
  IF (newIDNOTI = -1) THEN
    BEGIN
      SELECT IDNOTISEQ.nextval INTO newIDNOTI FROM DUAL;

      INSERT INTO NOTIFICACIONES
        (ID, TIPO, FINALIZADA, TEXTO, CREACION, FIN, IDPER, FECHA)
      VALUES
        (newIDNOTI,
         paramTIPO,
         paramFINALIZADA,
         paramTEXTO,
         paramCREACION,
         paramFIN,
         paramIDPER,
         paramFECHA);
    END;
  ELSE
    BEGIN

      UPDATE NOTIFICACIONES
         SET TIPO       = paramTIPO,
             FINALIZADA = paramFINALIZADA,
             TEXTO      = paramTEXTO,
             CREACION   = paramCREACION,
             FIN        = paramFIN,
             IDPER      = paramIDPER,
             FECHA      = paramFECHA
       WHERE ID = newIDNOTI;
    END;
  END IF;
END;
/


-- ============================================= 
-- Author:		JLL 
-- Create date: 19/4/2007 
-- Description:	Devuelve las notifiaciones del tipo y la persona indicadas 
-- ============================================= 
CREATE OR REPLACE PROCEDURE ObtenerNotificacionesxID(paramID   IN int DEFAULT NULL,
                                                     RCT1 IN OUT GLOBALPKG.RCT1) AS
BEGIN

  OPEN RCT1 FOR
    SELECT ID, TIPO, FINALIZADA, TEXTO, CREACION, FIN, IDPER, FECHA
      FROM NOTIFICACIONES
     WHERE ID = paramID;
END;
/

CREATE OR REPLACE PROCEDURE ObtenerNotificacionesxFECHA(FECHAMIN      IN timestamp DEFAULT NULL,
                                                        FECHAMAX      IN timestamp DEFAULT NULL,
                                                        FINALIZADAS   IN NUMBER DEFAULT NULL,
                                                        NOFINALIZADAS IN NUMBER DEFAULT NULL,
                                                        SISTEMA       IN NUMBER DEFAULT NULL,
                                                        RCT1 IN OUT GLOBALPKG.RCT1) AS
BEGIN
  OPEN RCT1 FOR
    SELECT ID, TIPO, FINALIZADA, TEXTO, CREACION, FIN, IDPER, FECHA
      FROM NOTIFICACIONES
         WHERE FECHA BETWEEN NVL(FECHAMIN, TO_DATE('01011900', 'MMDDYYYY')) AND 
               NVL(FECHAMAX, TO_DATE('01012900', 'MMDDYYYY')) AND
               ((FINALIZADAS != 0 AND FINALIZADA = 1) OR (NOFINALIZADAS != 0 AND FINALIZADA = 0)) AND
               ((SISTEMA = 0 AND IDPER != 1) OR (SISTEMA != 0));

END;
/

CREATE OR REPLACE PROCEDURE ObtenerNotiXTIPOxIDPERxFECHA(paramTIPO IN NUMBER,
                                                                   paramIDPER   IN NUMBER,
                                                                   paramFECHA   IN timestamp,
                                                                   RCT1 IN OUT GLOBALPKG.RCT1) AS
BEGIN
  OPEN RCT1 FOR
    SELECT ID, TIPO, FINALIZADA, TEXTO, CREACION, FIN, IDPER, FECHA
      FROM NOTIFICACIONES
         WHERE TIPO = paramTIPO AND IDPER = paramIDPER AND FECHA = paramFECHA;
END;
/

-- =============================================
-- Author:		JLL
-- Create date: 18/04/2007
-- Description:	guarda 1 mensaje
-- =============================================
CREATE OR REPLACE PROCEDURE GuardarMensaje(	paramTIPO       IN int DEFAULT NULL,
																						paramID         IN int DEFAULT NULL,
																						paramDIA	IN timestamp DEFAULT NULL,
																						paramTEXTO      IN VARCHAR2 DEFAULT NULL,
																						paramFECHA IN timestamp DEFAULT NULL,
                                            paramIP      IN VARCHAR2 DEFAULT NULL,
                                            paramUSER IN VARCHAR2 DEFAULT NULL) AS

valueIDMSG int := -1;
BEGIN
  SELECT IDMSGSEQ.nextval INTO valueIDMSG FROM DUAL;

	INSERT INTO MENSAJES (IDMSG, TIPO, ID, DIA, TEXTO, FECHA, IP, USER_) 
	VALUES (valueIDMSG, paramTIPO, paramID, paramDIA, paramTEXTO, paramFECHA, paramIP, paramUSER);
END;
/


-- =============================================
-- Author:    JLL
-- Create date: 18/04/2007
-- Description:  guarda 1 mensaje
-- =============================================
CREATE OR REPLACE PROCEDURE HayMensajes(  paramTIPO  IN int DEFAULT NULL, 
                                          paramID    IN int DEFAULT NULL, 
                                          paramDIA  IN timestamp DEFAULT NULL,
                                          RCT1 IN OUT GLOBALPKG.RCT1) AS
BEGIN
  IF paramDIA is null THEN
		BEGIN
			OPEN RCT1 FOR SELECT COUNT(IDMSG) FROM MENSAJES WHERE TIPO = paramTIPO AND ID = paramID;
		END;
  ELSE
		BEGIN
			OPEN RCT1 FOR SELECT COUNT(IDMSG) FROM MENSAJES WHERE TIPO = paramTIPO AND ID = paramID AND DIA = paramDIA;
		END;
  END IF;
END;
/

-- =============================================
-- Author:		JLL
-- Create date: 18/4/2007
-- Description:	Devuelve los comentarios de un tipo y un Id
-- =============================================
CREATE OR REPLACE PROCEDURE ObtenerComentariosxTipoXId(	paramTIPO  IN int DEFAULT NULL, 
																												paramID    IN int DEFAULT NULL, 
																												paramDIA  IN timestamp DEFAULT NULL,
																												RCT1 IN OUT GLOBALPKG.RCT1) AS
BEGIN
	IF paramDIA IS null THEN
		BEGIN
			OPEN RCT1 FOR SELECT IDMSG, TIPO, ID, DIA, FECHA, TEXTO, USER_, IP FROM MENSAJES M1  WHERE M1.ID = paramID AND M1.TIPO = paramTIPO;
		END;
	ELSE
		BEGIN
			OPEN RCT1 FOR SELECT IDMSG, TIPO, ID, DIA, FECHA, TEXTO, USER_, IP FROM MENSAJES M1  WHERE M1.ID = paramID AND M1.TIPO = paramTIPO AND M1.DIA = paramDIA;
		END;
	END IF;
END;
/


create or replace view VMarcajes as
  SELECT marc.IDMAR, marc.IDPER, marc.IDINC, marc.IDTER, marc.IDLEC, marc.FECHA, marc.ORIGEN, marc.TIPO, marc.ESTADO, marc.TAR, marc.IP, marc.USUARIO, men.COMMENTS, marc.LAT, marc.LON, marc.MOBILEID, marc.CRC 
    FROM NMarcajes marc LEFT OUTER JOIN
      (SELECT     ID AS idmar, COUNT(1) AS COMMENTS
        FROM          MENSAJES
        WHERE      (TIPO = 0)
        GROUP BY ID) men ON men.idmar = marc.IDMAR;
/
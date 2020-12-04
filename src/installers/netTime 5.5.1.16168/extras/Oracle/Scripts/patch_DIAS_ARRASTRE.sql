/*

Patch para la nueva manera de calcular (info de arrastre en la tabla DIAS)

*/

ALTER TABLE DIAS ADD (
	DragTT NUMBER NULL,
	DaysTT NUMBER NULL,
	DragWA NUMBER NULL,
	DaysWA NUMBER NULL,
	DragWO NUMBER NULL,
	DaysWO NUMBER NULL
);
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
           MOBILEID
      FROM NMarcajes
     WHERE IDPER = paramIdPer AND FECHA >= paramFecha AND FECHA <= LastFecha
  ORDER BY FECHA, IDMAR;

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
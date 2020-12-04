/*

Patch para que funcione la query CleanDate

*/

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


CREATE OR REPLACE PROCEDURE ClearXTime AS
BEGIN
  delete from AppData;
  delete from NMarcajes;
  delete from Dias;
  delete from Mensajes;
  delete from NMARCAJESACCESOS;
  delete from NOTIFICACIONES;
  ResetIDMARSEQ;
  ResetIDDIASEQ;
  ResetIDNOTISEQ;
  ResetIDMSGSEQ;
  ResetIDSESSEQ;
  ResetIDPASEQ;
  ResetIDPREASEQ;
  ResetIDMARACCSEQ;
END; 
/

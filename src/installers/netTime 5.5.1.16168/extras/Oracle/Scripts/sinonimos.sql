
/* create USR */
CREATE USER nettimeusr PROFILE "DEFAULT" IDENTIFIED BY "spec" DEFAULT TABLESPACE TS_NETTIME_D TEMPORARY TABLESPACE "TEMP" ACCOUNT UNLOCK;


/* tables */
GRANT SELECT ON nettimeadm.APPDATA TO nettimeusr;
GRANT SELECT ON nettimeadm.DIAS TO nettimeusr;
GRANT SELECT ON nettimeadm.MENSAJES TO nettimeusr;
GRANT SELECT ON nettimeadm.NMARCAJES TO nettimeusr;
GRANT SELECT ON nettimeadm.NMARCAJESACCESOS TO nettimeusr;
GRANT SELECT ON nettimeadm.NOTIFICACIONES TO nettimeusr;
GRANT SELECT ON nettimeadm.PERFILESACCESOS TO nettimeusr;
GRANT SELECT ON nettimeadm.PRESENCIAACCESOS TO nettimeusr;
GRANT SELECT ON nettimeadm.SESSIONDETAIL TO nettimeusr;
GRANT SELECT ON nettimeadm.SESSIONS TO nettimeusr;
GRANT UPDATE ON nettimeadm.APPDATA TO nettimeusr;
GRANT UPDATE ON nettimeadm.DIAS TO nettimeusr;
GRANT UPDATE ON nettimeadm.MENSAJES TO nettimeusr;
GRANT UPDATE ON nettimeadm.NMARCAJES TO nettimeusr;
GRANT UPDATE ON nettimeadm.NMARCAJESACCESOS TO nettimeusr;
GRANT UPDATE ON nettimeadm.NOTIFICACIONES TO nettimeusr;
GRANT UPDATE ON nettimeadm.PERFILESACCESOS TO nettimeusr;
GRANT UPDATE ON nettimeadm.PRESENCIAACCESOS TO nettimeusr;
GRANT UPDATE ON nettimeadm.SESSIONDETAIL TO nettimeusr;
GRANT UPDATE ON nettimeadm.SESSIONS TO nettimeusr;
GRANT INSERT ON nettimeadm.APPDATA TO nettimeusr;
GRANT INSERT ON nettimeadm.DIAS TO nettimeusr;
GRANT INSERT ON nettimeadm.MENSAJES TO nettimeusr;
GRANT INSERT ON nettimeadm.NMARCAJES TO nettimeusr;
GRANT INSERT ON nettimeadm.NMARCAJESACCESOS TO nettimeusr;
GRANT INSERT ON nettimeadm.NOTIFICACIONES TO nettimeusr;
GRANT INSERT ON nettimeadm.PERFILESACCESOS TO nettimeusr;
GRANT INSERT ON nettimeadm.PRESENCIAACCESOS TO nettimeusr;
GRANT INSERT ON nettimeadm.SESSIONDETAIL TO nettimeusr;
GRANT INSERT ON nettimeadm.SESSIONS TO nettimeusr;
GRANT DELETE ON nettimeadm.APPDATA TO nettimeusr;
GRANT DELETE ON nettimeadm.DIAS TO nettimeusr;
GRANT DELETE ON nettimeadm.MENSAJES TO nettimeusr;
GRANT DELETE ON nettimeadm.NMARCAJES TO nettimeusr;
GRANT DELETE ON nettimeadm.NMARCAJESACCESOS TO nettimeusr;
GRANT DELETE ON nettimeadm.NOTIFICACIONES TO nettimeusr;
GRANT DELETE ON nettimeadm.PERFILESACCESOS TO nettimeusr;
GRANT DELETE ON nettimeadm.PRESENCIAACCESOS TO nettimeusr;
GRANT DELETE ON nettimeadm.SESSIONDETAIL TO nettimeusr;
GRANT DELETE ON nettimeadm.SESSIONS TO nettimeusr;


/* Views */
GRANT SELECT ON nettimeadm.VMarcajes TO nettimeusr;


/* procedures */

grant create session to nettimeusr;

GRANT EXECUTE ON nettimeadm.OBTENERCOMENTARIOSXTIPOXID TO nettimeusr;
GRANT EXECUTE ON nettimeadm.HAYMENSAJES TO nettimeusr;
GRANT EXECUTE ON nettimeadm.GUARDARMENSAJE TO nettimeusr;
GRANT EXECUTE ON nettimeadm.GUARDARDIA TO nettimeusr;
GRANT EXECUTE ON nettimeadm.GUARDARDIA_V2 TO nettimeusr;
GRANT EXECUTE ON nettimeadm.OBTENERDIASXIDS TO nettimeusr;
GRANT EXECUTE ON nettimeadm.OBTENERDIASXPERSONAXFECHA TO nettimeusr;
GRANT EXECUTE ON nettimeadm.OBTENERDIASXPERSONAXFECHA_V2 TO nettimeusr;
GRANT EXECUTE ON nettimeadm.GUARDAMARCAJE TO nettimeusr;
GRANT EXECUTE ON nettimeadm.OBTENERMARCAJESXPERSONAYFEC_V2 TO nettimeusr;
GRANT EXECUTE ON nettimeadm.OBTENERMARCAJEXIDMAR TO nettimeusr;
GRANT EXECUTE ON nettimeadm.MODIFICAMARCAJE TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ELIMINARMARCAJE TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ELIMINARMARCAJESXPERSONAYFECHA TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ELIMINARMARCAJESXPERSONAYFECH2 TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ELIMINARDIASXPERSONAXFECHA TO nettimeusr;
GRANT EXECUTE ON nettimeadm.GUARDARELEMENTO TO nettimeusr;
GRANT EXECUTE ON nettimeadm.OBTENERELEMENTOSXIDTYPE TO nettimeusr;
GRANT EXECUTE ON nettimeadm.OBTENERELEMENTOXIDTYPEXIDELEM TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ELIMINARELEMENTOXIDTYPEXIDELEM TO nettimeusr;
GRANT EXECUTE ON nettimeadm.RESETIDMARSEQ TO nettimeusr;
GRANT EXECUTE ON nettimeadm.RESETIDDIASEQ TO nettimeusr;
GRANT EXECUTE ON nettimeadm.RESETIDNOTISEQ TO nettimeusr;
GRANT EXECUTE ON nettimeadm.RESETIDMSGSEQ TO nettimeusr;
GRANT EXECUTE ON nettimeadm.OBTENERANOMALIASXIDXFECHA TO nettimeusr;
GRANT EXECUTE ON nettimeadm.GUARDARNOTIFICACION TO nettimeusr;
GRANT EXECUTE ON nettimeadm.OBTENERNOTIFICACIONESXID TO nettimeusr;
GRANT EXECUTE ON nettimeadm.OBTENERNOTIFICACIONESXFECHA TO nettimeusr;
GRANT EXECUTE ON nettimeadm.OBTENERNOTIXTIPOXIDPERXFECHA TO nettimeusr;
GRANT EXECUTE ON nettimeadm.CLEARXTIME TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ResetIDMARACCSEQ TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ResetIDPASEQ TO nettimeusr;
GRANT EXECUTE ON nettimeadm.GuardaPerfilAccesos TO nettimeusr;
GRANT EXECUTE ON nettimeadm.DamePerfilAccesos TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ResetIDPREASEQ TO nettimeusr;
GRANT EXECUTE ON nettimeadm.GuardarPresencia TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ObtenerPresencia TO nettimeusr;
GRANT EXECUTE ON nettimeadm.EliminarPresenciaDesde TO nettimeusr;

GRANT EXECUTE ON nettimeadm.GuardarMarcajeAccesos TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ObtenerMarcajesAccesos TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ObtenerAccesosPersona TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ObtenerAccesosPersonaPosterior TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ObtenerAccesosZonasCorrectos TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ObtenerUltAccCorrectosZona TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ObtenerUltAccCorrectoPersona TO nettimeusr;
GRANT EXECUTE ON nettimeadm.OpenSession TO nettimeusr;
GRANT EXECUTE ON nettimeadm.CloseSession TO nettimeusr;
GRANT EXECUTE ON nettimeadm.AddSessionDetail TO nettimeusr;
GRANT EXECUTE ON nettimeadm.GetSession TO nettimeusr;
GRANT EXECUTE ON nettimeadm.ResetIDSESSEQ TO nettimeusr;

/* package */
GRANT EXECUTE ON nettimeadm.GLOBALPKG TO nettimeusr;

/* function */
GRANT EXECUTE ON nettimeadm.TABLEFROMSTRING TO nettimeusr;
GRANT EXECUTE ON nettimeadm.HEX_TO_NUMBER TO nettimeusr;
GRANT EXECUTE ON nettimeadm.IDMARMasReciente TO nettimeusr;
GRANT EXECUTE ON nettimeadm.TipoMarcaje TO nettimeusr;


/* sequence */
GRANT SELECT ON nettimeadm.IDDIASEQ TO nettimeusr;
GRANT SELECT ON nettimeadm.IDMARSEQ TO nettimeusr;
GRANT SELECT ON nettimeadm.IDNOTISEQ TO nettimeusr;
GRANT SELECT ON nettimeadm.IDMARACCSEQ TO nettimeusr;
GRANT SELECT ON nettimeadm.IDPASEQ TO nettimeusr;
GRANT SELECT ON nettimeadm.IDPREASEQ TO nettimeusr;
GRANT SELECT ON nettimeadm.IDSESSEQ TO nettimeusr;
GRANT SELECT ON nettimeadm.IDMSGSEQ TO nettimeusr;

/* TYPE */

GRANT EXECUTE, DEBUG ON nettimeadm.nettimeadm TO nettimeusr;
GRANT EXECUTE, DEBUG on nettimeadm.INTLIST TO nettimeusr;
GRANT EXECUTE, DEBUG ON nettimeadm.TYPE TO nettimeusr;


/* sinonimos */


CREATE SYNONYM nettimeusr.APPDATA FOR nettimeadm.APPDATA;
CREATE SYNONYM nettimeusr.APPDATA_PK FOR nettimeadm.APPDATA_PK;

CREATE SYNONYM nettimeusr.DIAS FOR nettimeadm.DIAS;
CREATE SYNONYM nettimeusr.DIAS_PK FOR nettimeadm.DIAS_PK;
CREATE SYNONYM nettimeusr.DIAS_IDPER FOR nettimeadm.DIAS_IDPER;
CREATE SYNONYM nettimeusr.DIAS_IDPERFECHA FOR nettimeadm.DIAS_IDPERFECHA;

CREATE SYNONYM nettimeusr.MENSAJES FOR nettimeadm.MENSAJES;
CREATE SYNONYM nettimeusr.MENSAJES_PK FOR nettimeadm.MENSAJES_PK;
CREATE SYNONYM nettimeusr.MENSAJES_TIPO FOR nettimeadm.MENSAJES_TIPO;

CREATE SYNONYM nettimeusr.NMARCAJES FOR nettimeadm.NMARCAJES;
CREATE SYNONYM nettimeusr.NMARCAJES_PK FOR nettimeadm.NMARCAJES_PK;
CREATE SYNONYM nettimeusr.NMARCAJES_IDPER_FECHA FOR nettimeadm.NMARCAJES_IDPER_FECHA;

CREATE SYNONYM nettimeusr.NMarcajesAccesos FOR nettimeadm.NMarcajesAccesos;
CREATE SYNONYM nettimeusr.NMARCAJESACCESOS_PK FOR nettimeadm.NMARCAJESACCESOS_PK;
CREATE SYNONYM nettimeusr.NMARCAJESACCESOS_IDPER_FECHA FOR nettimeadm.NMARCAJESACCESOS_IDPER_FECHA;
CREATE SYNONYM nettimeusr.NMARCAJESACCESOS_FECHA FOR nettimeadm.NMARCAJESACCESOS_FECHA;

CREATE SYNONYM nettimeusr.NOTIFICACIONES FOR nettimeadm.NOTIFICACIONES;
CREATE SYNONYM nettimeusr.NOTIFICACIONES_PK FOR nettimeadm.NOTIFICACIONES_PK;
CREATE SYNONYM nettimeusr.NOTIFICACIONES_TIPOIDPERFECHA FOR nettimeadm.NOTIFICACIONES_TIPOIDPERFECHA;

CREATE SYNONYM nettimeusr.PerfilesAccesos FOR nettimeadm.PerfilesAccesos;
CREATE SYNONYM nettimeusr.PERFILESACCESOS_PK FOR nettimeadm.PERFILESACCESOS_PK;

CREATE SYNONYM nettimeusr.PresenciaAccesos FOR nettimeadm.PresenciaAccesos;
CREATE SYNONYM nettimeusr.PresenciaAccesos_PK FOR nettimeadm.PresenciaAccesos_PK;
CREATE SYNONYM nettimeusr.PresenciaAccesos_FECHA FOR nettimeadm.PresenciaAccesos_FECHA;

CREATE SYNONYM nettimeusr.Sessions FOR nettimeadm.Sessions;
CREATE SYNONYM nettimeusr.SESSIONS_PK FOR nettimeadm.SESSIONS_PK;
CREATE SYNONYM nettimeusr.SESSIONS_USER FOR nettimeadm.SESSIONS_USER;
CREATE SYNONYM nettimeusr.SessionDetail FOR nettimeadm.SessionDetail;
CREATE SYNONYM nettimeusr.SESSIONDETAIL_PK FOR nettimeadm.SESSIONDETAIL_PK;
CREATE SYNONYM nettimeusr.SESSIONDETAIL_IDSES FOR nettimeadm.SESSIONDETAIL_IDSES;


CREATE SYNONYM nettimeusr.GLOBALPKG FOR nettimeadm.GLOBALPKG;
CREATE SYNONYM nettimeusr.IDDIASEQ FOR nettimeadm.IDDIASEQ;
CREATE SYNONYM nettimeusr.OBTENERCOMENTARIOSXTIPOXID FOR nettimeadm.OBTENERCOMENTARIOSXTIPOXID;
CREATE SYNONYM nettimeusr.HAYMENSAJES FOR nettimeadm.HAYMENSAJES;
CREATE SYNONYM nettimeusr.GUARDARMENSAJE FOR nettimeadm.GUARDARMENSAJE;
CREATE SYNONYM nettimeusr.GUARDARDIA FOR nettimeadm.GUARDARDIA;
CREATE SYNONYM nettimeusr.GUARDARDIA_V2 FOR nettimeadm.GUARDARDIA_V2;
CREATE SYNONYM nettimeusr.INTLIST FOR nettimeadm.INTLIST;
CREATE SYNONYM nettimeusr.TABLEFROMSTRING FOR nettimeadm.TABLEFROMSTRING;
CREATE SYNONYM nettimeusr.OBTENERDIASXIDS FOR nettimeadm.OBTENERDIASXIDS;

CREATE SYNONYM nettimeusr.OBTENERDIASXPERSONAXFECHA FOR nettimeadm.OBTENERDIASXPERSONAXFECHA;
CREATE SYNONYM nettimeusr.OBTENERDIASXPERSONAXFECHA_V2 FOR nettimeadm.OBTENERDIASXPERSONAXFECHA_V2;
CREATE SYNONYM nettimeusr.IDMARSEQ FOR nettimeadm.IDMARSEQ;
CREATE SYNONYM nettimeusr.GUARDAMARCAJE FOR nettimeadm.GUARDAMARCAJE;
CREATE SYNONYM nettimeusr.OBTENERMARCAJESXPERSONAYFEC_V2 FOR nettimeadm.OBTENERMARCAJESXPERSONAYFEC_V2;
CREATE SYNONYM nettimeusr.OBTENERMARCAJEXIDMAR FOR nettimeadm.OBTENERMARCAJEXIDMAR;
CREATE SYNONYM nettimeusr.MODIFICAMARCAJE FOR nettimeadm.MODIFICAMARCAJE;
CREATE SYNONYM nettimeusr.ELIMINARMARCAJE FOR nettimeadm.ELIMINARMARCAJE;
CREATE SYNONYM nettimeusr.HEX_TO_NUMBER FOR nettimeadm.HEX_TO_NUMBER;
CREATE SYNONYM nettimeusr.ELIMINARMARCAJESXPERSONAYFECHA FOR nettimeadm.ELIMINARMARCAJESXPERSONAYFECHA;
CREATE SYNONYM nettimeusr.ELIMINARMARCAJESXPERSONAYFECH2 FOR nettimeadm.ELIMINARMARCAJESXPERSONAYFECH2;
CREATE SYNONYM nettimeusr.ELIMINARDIASXPERSONAXFECHA FOR nettimeadm.ELIMINARDIASXPERSONAXFECHA;
CREATE SYNONYM nettimeusr.GUARDARELEMENTO FOR nettimeadm.GUARDARELEMENTO;
CREATE SYNONYM nettimeusr.OBTENERELEMENTOSXIDTYPE FOR nettimeadm.OBTENERELEMENTOSXIDTYPE;
CREATE SYNONYM nettimeusr.OBTENERELEMENTOXIDTYPEXIDELEM FOR nettimeadm.OBTENERELEMENTOXIDTYPEXIDELEM;

CREATE SYNONYM nettimeusr.ELIMINARELEMENTOXIDTYPEXIDELEM FOR nettimeadm.ELIMINARELEMENTOXIDTYPEXIDELEM;
CREATE SYNONYM nettimeusr.RESETIDMARSEQ FOR nettimeadm.RESETIDMARSEQ;
CREATE SYNONYM nettimeusr.RESETIDDIASEQ FOR nettimeadm.RESETIDDIASEQ;
CREATE SYNONYM nettimeusr.RESETIDNOTISEQ FOR nettimeadm.RESETIDNOTISEQ;
CREATE SYNONYM nettimeusr.RESETIDMSGSEQ FOR nettimeadm.RESETIDMSGSEQ;
CREATE SYNONYM nettimeusr.OBTENERANOMALIASXIDXFECHA FOR nettimeadm.OBTENERANOMALIASXIDXFECHA;
CREATE SYNONYM nettimeusr.IDNOTISEQ FOR nettimeadm.IDNOTISEQ;
CREATE SYNONYM nettimeusr.GUARDARNOTIFICACION FOR nettimeadm.GUARDARNOTIFICACION;
CREATE SYNONYM nettimeusr.OBTENERNOTIFICACIONESXID FOR nettimeadm.OBTENERNOTIFICACIONESXID;
CREATE SYNONYM nettimeusr.OBTENERNOTIFICACIONESXFECHA FOR nettimeadm.OBTENERNOTIFICACIONESXFECHA;
CREATE SYNONYM nettimeusr.OBTENERNOTIXTIPOXIDPERXFECHA FOR nettimeadm.OBTENERNOTIXTIPOXIDPERXFECHA;
CREATE SYNONYM nettimeusr.CLEARXTIME FOR nettimeadm.CLEARXTIME;

CREATE SYNONYM nettimeusr.IDMARACCSEQ FOR nettimeadm.IDMARACCSEQ;
CREATE SYNONYM nettimeusr.IDPASEQ FOR nettimeadm.IDPASEQ;
CREATE SYNONYM nettimeusr.IDPREASEQ FOR nettimeadm.IDPREASEQ;

CREATE SYNONYM nettimeusr.ResetIDMARACCSEQ FOR nettimeadm.ResetIDMARACCSEQ;
CREATE SYNONYM nettimeusr.ResetIDPASEQ FOR nettimeadm.ResetIDPASEQ;
CREATE SYNONYM nettimeusr.GuardaPerfilAccesos FOR nettimeadm.GuardaPerfilAccesos;
CREATE SYNONYM nettimeusr.DamePerfilAccesos FOR nettimeadm.DamePerfilAccesos;
CREATE SYNONYM nettimeusr.ResetIDPREASEQ FOR nettimeadm.ResetIDPREASEQ;
CREATE SYNONYM nettimeusr.GuardarPresencia FOR nettimeadm.GuardarPresencia;
CREATE SYNONYM nettimeusr.ObtenerPresencia FOR nettimeadm.ObtenerPresencia;
CREATE SYNONYM nettimeusr.EliminarPresenciaDesde FOR nettimeadm.EliminarPresenciaDesde;

CREATE SYNONYM nettimeusr.GuardarMarcajeAccesos FOR nettimeadm.GuardarMarcajeAccesos;
CREATE SYNONYM nettimeusr.ObtenerMarcajesAccesos FOR nettimeadm.ObtenerMarcajesAccesos;
CREATE SYNONYM nettimeusr.ObtenerAccesosPersona FOR nettimeadm.ObtenerAccesosPersona;
CREATE SYNONYM nettimeusr.ObtenerAccesosPersonaPosterior FOR nettimeadm.ObtenerAccesosPersonaPosterior;
CREATE SYNONYM nettimeusr.ObtenerAccesosZonasCorrectos FOR nettimeadm.ObtenerAccesosZonasCorrectos;
CREATE SYNONYM nettimeusr.ObtenerUltAccCorrectosZona FOR nettimeadm.ObtenerUltAccCorrectosZona;
CREATE SYNONYM nettimeusr.ObtenerUltAccCorrectoPersona FOR nettimeadm.ObtenerUltAccCorrectoPersona;
CREATE SYNONYM nettimeusr.OpenSession FOR nettimeadm.OpenSession;
CREATE SYNONYM nettimeusr.CloseSession FOR nettimeadm.CloseSession;
CREATE SYNONYM nettimeusr.AddSessionDetail FOR nettimeadm.AddSessionDetail;
CREATE SYNONYM nettimeusr.GetSession FOR nettimeadm.GetSession;
CREATE SYNONYM nettimeusr.ResetIDSESSEQ FOR nettimeadm.ResetIDSESSEQ;

CREATE SYNONYM nettimeusr.IDMARMasReciente FOR nettimeadm.IDMARMasReciente;
CREATE SYNONYM nettimeusr.TipoMarcaje FOR nettimeadm.TipoMarcaje;

CREATE SYNONYM nettimeusr.IDSESSEQ FOR nettimeadm.IDSESSEQ;
CREATE SYNONYM nettimeusr.VMarcajes FOR nettimeadm.VMarcajes;

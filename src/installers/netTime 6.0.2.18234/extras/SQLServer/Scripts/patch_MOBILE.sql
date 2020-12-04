/* ------------------------------------------------------------

   DESCRIPTION:  Modifica la tabla Dias y los sptoreds asociados para agregar el campo MINFIN

    procedures:
        [dbo].[GuardarDia], [dbo].[ObtenerDiasxPersonaxFecha], [dbo].[GuardarDias], [dbo].[ObtenerDiasXIDs]

    tables:
        [dbo].[Dias_TMP], [dbo].[Dias]


   AUTHOR:	JL

   DATE:	21/02/2008 9:53:08

   LEGAL:	2008 SPEC SA

   ------------------------------------------------------------ */

SET NOEXEC OFF
SET ANSI_WARNINGS ON
SET XACT_ABORT ON
SET IMPLICIT_TRANSACTIONS OFF
SET ARITHABORT ON
SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
GO



IF EXISTS(SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#error_status'))
BEGIN
	DROP TABLE #error_status
END
GO
CREATE TABLE #error_status (has_error int)
GO
-- Backing up database
Print 'Backing up database'
BACKUP DATABASE [netTime]
	TO DISK = 'DiffBackup_netTime_MOBILE.bak'
GO

IF @@ERROR <> 0
	SET NOEXEC ON
USE [netTime]
GO

BEGIN TRAN
GO

-- Add Column LAT to NMarcajes
Print 'Add Column LAT to NMarcajes'
GO
ALTER TABLE [dbo].[NMarcajes]
	ADD [LAT] decimal NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO

-- Add Column LON to NMarcajes
Print 'Add Column LON to NMarcajes'
GO
ALTER TABLE [dbo].[NMarcajes]
	ADD [LON] decimal NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO

-- Add Column MOBILEID to NMarcajes
Print 'Add Column MOBILEID to NMarcajes'
GO
ALTER TABLE [dbo].[NMarcajes]
	ADD [MOBILEID] varchar(100) COLLATE Modern_Spanish_CI_AS NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO

-- Alter Procedure GuardarMarcaje
Print 'Alter Procedure GuardaMarcaje'
GO


-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	Inserta un marcaje
-- =============================================
ALTER PROCEDURE [dbo].[GuardaMarcaje]
	@IDMAR  int,
	@IDPER  int, 
	@IDINC  int,
	@IDTER  int,
	@IDLEC  int,
	@FECHA  datetime,
	@ORIGEN  int,
	@TIPO  int,
	@ESTADO  int,
	@TAR  varchar(50),
	@IP  varchar(15),
	@USUARIO  varchar(20),
	@ACCESO  char(1),
	@LAT decimal,
	@LON decimal,
	@MOBILEID  varchar(100)
AS
BEGIN
	SET NOCOUNT ON

	IF (@IDMAR = -1)
	BEGIN
		INSERT INTO NMarcajes 
			(IDPER, IDINC, IDTER, IDLEC, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, USUARIO, ACCESO, LAT, LON, MOBILEID) 
		VALUES
			(@IDPER, @IDINC, @IDTER, @IDLEC, @FECHA, @ORIGEN, @TIPO, @ESTADO, @TAR, @IP, @USUARIO, @ACCESO, @LAT, @LON, @MOBILEID)
		
		SELECT CONVERT(int,@@IDENTITY);
	END
	ELSE
	BEGIN
		SET IDENTITY_INSERT NMarcajes ON
		INSERT INTO NMarcajes 
			(IDMAR, IDPER, IDINC, IDTER, IDLEC, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, USUARIO, ACCESO, LAT, LON, MOBILEID) 
		VALUES
			(@IDMAR, @IDPER, @IDINC, @IDTER, @IDLEC, @FECHA, @ORIGEN, @TIPO, @ESTADO, @TAR, @IP, @USUARIO, @ACCESO, @LAT, @LON, @MOBILEID)
		SET IDENTITY_INSERT NMarcajes OFF
	END
END



GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO
-- Alter Procedure ModificaMarcaje
Print 'Alter Procedure ModificaMarcaje'
GO



-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	Modifica un marcaje
-- =============================================
ALTER PROCEDURE [dbo].[ModificaMarcaje]
	@IDMAR  int, 
	@IDPER  int, 
	@IDINC  int,
	@IDTER  int,
	@IDLEC  int,
	@FECHA  datetime,
	@ORIGEN  int,
	@TIPO  int,
	@ESTADO  int,
	@TAR  varchar(50),
	@IP  varchar(15),
	@USUARIO  varchar(20),
	@ACCESO  char(1),
	@LAT decimal,
	@LON decimal,
	@MOBILEID varchar(100)
AS
BEGIN
	SET NOCOUNT ON

	UPDATE NMarcajes SET
		IDPER = @IDPER, 
		IDINC = @IDINC, 
		IDTER = @IDTER, 
		IDLEC = @IDLEC, 
		FECHA = @FECHA, 
		ORIGEN = @ORIGEN, 
		TIPO = @TIPO, 
		ESTADO = @ESTADO, 
		TAR = @TAR, 
		IP = @IP, 
		USUARIO = @USUARIO, 
		ACCESO = @ACCESO,
		LAT = @LAT,
		LON = @LON,
		MOBILEID = @MOBILEID
	WHERE IDMAR = @IDMAR
END





GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO

-- Alter Procedure ObtenerMarcaje
Print 'Alter Procedure ObtenerMarcaje'
GO


-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	Devuelve el marcaje con IDMAR
-- =============================================
ALTER PROCEDURE [dbo].[ObtenerMarcaje]
	@IDMAR int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IDMAR,IDPER,IDINC,IDTER,IDLEC,FECHA,ORIGEN,TIPO,ESTADO,TAR,IP,USUARIO,ACCESO,LAT,LON,MOBILEID
	FROM NMarcajes 
	WHERE IDMAR=@IDMAR 

END





GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO-- Alter Procedure ObtenerMarcajeXIDMAR
Print 'Alter Procedure ObtenerMarcajeXIDMAR'
GO


-- =============================================
-- Author:		JLL
-- Create date: 30/5/2007
-- Description:	Devuelve un marcaje
-- =============================================
ALTER PROCEDURE [dbo].[ObtenerMarcajeXIDMAR]
	@IDMAR int
AS
BEGIN
	SET NOCOUNT ON;

SELECT 
		IDMAR,
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
  WHERE IDMAR = @IDMAR 

END





GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO
-- Alter Procedure ObtenerMarcajesXPersonaYFecha
Print 'Alter Procedure ObtenerMarcajesXPersonaYFecha_v2'
GO

-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	Devuelve los marcajes entre las fechas especificadas para 1 usuario
-- =============================================
ALTER PROCEDURE [dbo].[ObtenerMarcajesXPersonaYFecha_v2]
	@IdPer  int, 
	@Fecha  datetime,
	@LastFecha  datetime
AS
BEGIN
	SET NOCOUNT ON;
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
     FROM  NMarcajes 
    WHERE  IDPER = @IdPer and FECHA >= @Fecha and FECHA <= @LastFecha
 ORDER BY  FECHA, IDMAR
END



GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF

USE master
GO
IF EXISTS(SELECT * FROM #error_status)
BEGIN
-- Restoring database
Print 'Restoring database '
	RESTORE DATABASE [netTime]
		FROM DISK = 'DiffBackup_netTime_MOBILE.bak'
END
GO
DROP TABLE #error_status
GO

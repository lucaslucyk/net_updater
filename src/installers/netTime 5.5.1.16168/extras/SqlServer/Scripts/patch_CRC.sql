/* ------------------------------------------------------------

   DESCRIPTION:  Modifica la tabla Dias y los sptoreds asociados para agregar el campo MINFIN

    procedures:
        [dbo].[GuardaMarcaje], [dbo].[ModificaMarcaje],  [dbo].[ObtenerMarcajeXIDMAR], [dbo].[ObtenerMarcajesXPersonaYFecha_v2]

    tables:
        [dbo].[NMarcajes]
	views:
		[dbo].[VMarcajes]


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

Print 'Add Column CRC to NMarcajes'
GO
ALTER TABLE [dbo].[NMarcajes]
	ADD [CRC] int NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO

Print 'Add Column CRC to VMarcajes'
GO
ALTER VIEW [dbo].[VMarcajes]
AS
SELECT     marc.IDMAR, marc.IDPER, marc.IDINC, marc.IDTER, marc.IDLEC, marc.FECHA, marc.ORIGEN, marc.TIPO, marc.ESTADO, marc.TAR, marc.IP, marc.USUARIO, 
                      men.COMMENTS, marc.LAT, marc.LON, marc.MOBILEID, marc.CRC
FROM         dbo.NMarcajes AS marc LEFT OUTER JOIN
                          (SELECT     ID AS idmar, COUNT(1) AS COMMENTS
                            FROM          dbo.MENSAJES
                            WHERE      (TIPO = 0)
                            GROUP BY ID) AS men ON men.idmar = marc.IDMAR

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO


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
	@LAT decimal(18,8),
	@LON decimal(18,8),
	@MOBILEID  varchar(100),
	@CRC int
AS
BEGIN
	SET NOCOUNT ON

	IF (@IDMAR = -1)
	BEGIN
		INSERT INTO NMarcajes 
			(IDPER, IDINC, IDTER, IDLEC, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, USUARIO, ACCESO, LAT, LON, MOBILEID, CRC) 
		VALUES
			(@IDPER, @IDINC, @IDTER, @IDLEC, @FECHA, @ORIGEN, @TIPO, @ESTADO, @TAR, @IP, @USUARIO, @ACCESO, @LAT, @LON, @MOBILEID, @CRC)
		
		SELECT CONVERT(int,@@IDENTITY);
	END
	ELSE
	BEGIN
		SET IDENTITY_INSERT NMarcajes ON
		INSERT INTO NMarcajes 
			(IDMAR, IDPER, IDINC, IDTER, IDLEC, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, USUARIO, ACCESO, LAT, LON, MOBILEID, CRC) 
		VALUES
			(@IDMAR, @IDPER, @IDINC, @IDTER, @IDLEC, @FECHA, @ORIGEN, @TIPO, @ESTADO, @TAR, @IP, @USUARIO, @ACCESO, @LAT, @LON, @MOBILEID, @CRC)
		SET IDENTITY_INSERT NMarcajes OFF
	END
END
GO



GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO

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
	@MOBILEID varchar(100),
	@CRC int
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
		MOBILEID = @MOBILEID,
		CRC = @CRC
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
		MOBILEID,
		CRC
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
		   MOBILEID,
		   CRC
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

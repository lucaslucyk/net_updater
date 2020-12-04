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
	TO DISK = 'DiffBackup_netTime_MINFIN.bak'
GO

IF @@ERROR <> 0
	SET NOEXEC ON
USE [netTime]
GO

BEGIN TRAN
GO

-- Add Column MINFIN to Dias_TMP
Print 'Add Column MINFIN to Dias_TMP'
GO
ALTER TABLE [dbo].[Dias_TMP]
	ADD [MINFIN] int NULL

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO
-- Add Default Constraint DF_Dias_TMP_MINFIN to Dias_TMP
Print 'Add Default Constraint DF_Dias_TMP_MINFIN to Dias_TMP'
GO
ALTER TABLE [dbo].[Dias_TMP]
	ADD
	CONSTRAINT [DF_Dias_TMP_MINFIN]
	DEFAULT ((-1)) FOR [MINFIN]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO
-- Add Column MINFIN to Dias
Print 'Add Column MINFIN to Dias'
GO
ALTER TABLE [dbo].[Dias]
	ADD [MINFIN] int NULL

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO
-- Add Default Constraint DF_Dias_MINFIN to Dias
Print 'Add Default Constraint DF_Dias_MINFIN to Dias'
GO
ALTER TABLE [dbo].[Dias]
	ADD
	CONSTRAINT [DF_Dias_MINFIN]
	DEFAULT ((-1)) FOR [MINFIN]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO
-- Alter Procedure GuardarDia
Print 'Alter Procedure GuardarDia'
GO


-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	guarda o actualiza 1 día para 1 persona y fecha 
-- =============================================
ALTER PROCEDURE [dbo].[GuardarDia]
	@IDPER  int, 
	@FECHA  datetime,
	@IDJOR  int, 
	@TM		int, 
	@IDANO	int, 
	@VALORES  varbinary(8000),
	@MINFIN int
AS
BEGIN
	UPDATE DIAS SET IDJOR=@IDJor, TM=@TM, IDANO=@IDAno, VALORES=@Valores, MINFIN = @MINFIN
	WHERE IDPER=@IDPer AND FECHA=@Fecha

	IF @@ROWCOUNT = 0
	BEGIN
		INSERT INTO DIAS (IDPER, FECHA, IDJOR, TM, IDANO, VALORES, MINFIN) 
		VALUES ( @IDPer, @Fecha, @IDJor, @TM, @IDAno, @Valores, @MINFIN)
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
-- Alter Procedure ObtenerDiasxPersonaxFecha
Print 'Alter Procedure ObtenerDiasxPersonaxFecha'
GO



-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	elimina los días para 1 persona en el rango de fecha especificado
-- =============================================
ALTER PROCEDURE [dbo].[ObtenerDiasxPersonaxFecha]
	@IDPER  int, 
	@FECHAINI  datetime,
	@FECHAFIN  datetime
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IDPER, 
		   FECHA, 
		   IDJOR, 
		   TM, 
		   IDANO, 
		   VALORES, 
		   IDDIA,
		   MINFIN
	  FROM DIAS 
	 WHERE IDPER = COALESCE(@IdPer, @IdPer) 
	   and FECHA >= @FECHAINI 
	   and FECHA < @FECHAFIN 
	 ORDER BY FECHA
END





GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO
-- Alter Procedure GuardarDias
Print 'Alter Procedure GuardarDias'
GO


-- =============================================
-- Author:		JLL
-- Create date: 30/10/2006
-- Description:	guarda o actualiza n días para n persona y fechas 
-- =============================================
ALTER PROCEDURE [dbo].[GuardarDias]
AS
BEGIN
	UPDATE DIAS SET IDJOR= T.IDJor, TM= T.TM, IDANO= T.IDAno, VALORES= T.Valores, MINFIN = T.MINFIN
	FROM DIAS_TMP T
	WHERE DIAS.IDPER= T.IDPer AND DIAS.FECHA= T.Fecha

	INSERT INTO DIAS (IDPER, FECHA, IDJOR, TM, IDANO, VALORES, MINFIN) 
	SELECT IDPER, FECHA, IDJOR, TM, IDANO, VALORES, MINFIN
	FROM DIAS_TMP T
	WHERE T.IDPER NOT IN (
		SELECT IDPER
		FROM DIAS D
		WHERE D.IDPER= T.IDPer AND D.FECHA= T.Fecha
	)

	TRUNCATE TABLE DIAS_TMP
END





GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN
	IF @@TRANCOUNT>0
		ROLLBACK
	INSERT INTO #error_status (has_error) VALUES (1)
	SET NOEXEC ON
END
GO
-- Alter Procedure ObtenerDiasXIDs
Print 'Alter Procedure ObtenerDiasXIDs'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ObtenerDiasXIDs]
	@IDs VarChar(1024)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT IDPER, 
		   FECHA, 
		   IDJOR, 
		   TM, 
		   IDANO, 
		   VALORES, 
		   IDDIA,
		   MINFIN
	  FROM DIAS as D
		JOIN dbo.SplitCSV(@IDs) AS S ON D.IDDIA  = S.ID 
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
		FROM DISK = 'DiffBackup_netTime_MINFIN.bak'
END
GO
DROP TABLE #error_status
GO

CREATE DATABASE [netTime] 
GO
EXEC dbo.sp_dbcmptlevel @dbname=N'netTime', @new_cmptlevel=100
GO
ALTER DATABASE [netTime] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [netTime] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [netTime] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [netTime] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [netTime] SET ARITHABORT OFF 
GO
ALTER DATABASE [netTime] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [netTime] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [netTime] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [netTime] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [netTime] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [netTime] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [netTime] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [netTime] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [netTime] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [netTime] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [netTime] SET  DISABLE_BROKER 
GO
ALTER DATABASE [netTime] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [netTime] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [netTime] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [netTime] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [netTime] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [netTime] SET  READ_WRITE 
GO
ALTER DATABASE [netTime] SET RECOVERY FULL 
GO
ALTER DATABASE [netTime] SET  MULTI_USER 
GO
ALTER DATABASE [netTime] SET PAGE_VERIFY NONE  
GO
ALTER DATABASE [netTime] SET DB_CHAINING OFF 
GO
ALTER DATABASE [netTime] COLLATE Modern_Spanish_CI_AS

USE [netTime]
GO
/****** Object:  User [netTime]    Script Date: 02/21/2008 10:11:33 ******/
GO
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'netTime')
BEGIN
	CREATE LOGIN netTime WITH PASSWORD = 'netTime';
END
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'netTime')
BEGIN
	CREATE USER netTime FOR LOGIN netTime;
END
EXEC sp_addrolemember 'db_owner', 'netTime'
GO
/****** Objeto:  UserDefinedFunction [dbo].[SplitCSV]    Fecha de la secuencia de comandos: 01/28/2010 11:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[SplitCSV]
(
	@IDList varchar(1024)
)
RETURNS 
@ParsedList table
(
	ID int
)
AS
BEGIN
	DECLARE @OrderID varchar(10), @Pos int

	SET @IDList = LTRIM(RTRIM(@IDList))+ ','
	SET @Pos = CHARINDEX(',', @IDList, 1)

	IF REPLACE(@IDList, ',', '') <> ''
	BEGIN
		WHILE @Pos > 0
		BEGIN
			SET @OrderID = LTRIM(RTRIM(LEFT(@IDList, @Pos - 1)))
			IF @OrderID <> ''
			BEGIN
				INSERT INTO @ParsedList (ID) 
				VALUES (CAST(@OrderID AS int)) --Use Appropriate conversion
			END
			SET @IDList = RIGHT(@IDList, LEN(@IDList) - @Pos)
			SET @Pos = CHARINDEX(',', @IDList, 1)

		END
	END	
	RETURN
END
GO
/****** Objeto:  Table [dbo].[Dias]    Fecha de la secuencia de comandos: 01/28/2010 11:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Dias](
	[iddia] [int] IDENTITY(1,1) NOT NULL,
	[IDPER] [int] NOT NULL,
	[FECHA] [datetime] NOT NULL,
	[IDJOR] [int] NULL,
	[TM] [int] NULL,
	[IDANO] [int] NULL,
	[VALORES] [varbinary](8000) NULL,
	[MINFIN] [int] NULL CONSTRAINT [DF_Dias_MINFIN]  DEFAULT ((-1)),
	[DragTT] [int] NULL, 
	[DaysTT] [int] NULL, 
	[DragWA] [int] NULL, 
	[DaysWA] [int] NULL, 
	[DragWO] [int] NULL, 
	[DaysWO] [int] NULL
 CONSTRAINT [PK_Dias] PRIMARY KEY NONCLUSTERED 
(
	[IDPER] ASC,
	[FECHA] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

CREATE NONCLUSTERED INDEX [IDPER] ON [dbo].[Dias] 
(
	[IDPER] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Objeto:  Table [dbo].[MENSAJES]    Fecha de la secuencia de comandos: 01/28/2010 11:50:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MENSAJES](
	[IDMSG] [int] IDENTITY(1,1) NOT NULL,
	[TIPO] [int] NULL,
	[ID] [int] NULL,
	[DIA] [datetime] NULL,
	[FECHA] [datetime] NULL,
	[TEXTO] [varchar](8000) COLLATE Modern_Spanish_CI_AS NULL,
	[USER] [varchar](20) COLLATE Modern_Spanish_CI_AS NULL,
	[IP] [varchar](15) COLLATE Modern_Spanish_CI_AS NULL,
	[BDATA] [varbinary](max) NULL,
 CONSTRAINT [PK_MENSAJES] PRIMARY KEY CLUSTERED 
(
	[IDMSG] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Objeto:  Table [dbo].[NMarcajes]    Fecha de la secuencia de comandos: 01/28/2010 11:50:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NMarcajes](
	[IDMAR] [int] IDENTITY(1,1) NOT NULL,
	[IDPER] [int] NOT NULL,
	[IDINC] [int] NULL,
	[IDTER] [int] NULL,
	[IDLEC] [int] NULL,
	[FECHA] [datetime] NOT NULL,
	[ORIGEN] [int] NULL,
	[TIPO] [int] NULL,
	[ESTADO] [int] NULL,
	[TAR] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[IP] [varchar](15) COLLATE Modern_Spanish_CI_AS NULL,
	[USUARIO] [varchar](20) COLLATE Modern_Spanish_CI_AS NULL,
	[ACCESO] [char](1) COLLATE Modern_Spanish_CI_AS NULL,
	[LAT] decimal(18,8) NULL,
	[LON] decimal(18,8) NULL,
	[MOBILEID] [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[CRC] [int] NULL,
 CONSTRAINT [PK_NMarcajes] PRIMARY KEY NONCLUSTERED 
(
	[IDMAR] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE CLUSTERED INDEX [NMarcajes_IDPER_FECHA] ON [dbo].[NMarcajes] 
(
	[IDPER] ASC,
	[FECHA] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Objeto:  StoredProcedure [dbo].[ObtenerElementoXIdTypeXIdelem]    Fecha de la secuencia de comandos: 01/28/2010 11:50:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	obtiene el xml de configuración
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerElementoXIdTypeXIdelem]
	@IDTYPE  int, 
	@IDELEM  int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DATA, BDATA, NAME
	FROM AppData
	WHERE IDTYPE=@IDTYPE and IDELEM=@IDELEM;
END
GO
/****** Objeto:  Table [dbo].[AppData]    Fecha de la secuencia de comandos: 01/28/2010 11:50:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AppData](
	[IDTYPE] [int] NOT NULL,
	[IDELEM] [int] NOT NULL,
	[NAME] [varchar](150) COLLATE Modern_Spanish_CI_AS NULL,
	[DATA] [xml] NULL,
	[BDATA] [varbinary](max) NULL,
 CONSTRAINT [PK_AppData] PRIMARY KEY CLUSTERED 
(
	[IDTYPE] ASC,
	[IDELEM] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Objeto:  UserDefinedFunction [dbo].[TipoMarcaje]    Fecha de la secuencia de comandos: 01/28/2010 11:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 20/01/2010
-- Description:	Comprueba si un marcaje es de un tipo concreto
-- =============================================
CREATE FUNCTION [dbo].[TipoMarcaje] 
(
	@ISOK			bit,
	@TIPOMARCAJE	smallint,
	@TIPO			int
)
RETURNS bit
AS
BEGIN
	IF (@TIPOMARCAJE = 0)
		RETURN(1)

	IF(	(@ISOK = 1 AND @TIPOMARCAJE = (@TIPO & @TIPOMARCAJE)) OR 
		(@ISOK = 0 AND 0 = (@TIPO & @TIPOMARCAJE))	)
		RETURN(1)

	RETURN(0)
END
GO
/****** Objeto:  Table [dbo].[PerfilesAccesos]    Fecha de la secuencia de comandos: 01/28/2010 11:51:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PerfilesAccesos](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDPERFIL] [bigint] NOT NULL,
	[ANO] [int] NOT NULL,
	[IDLEC] [int] NULL,
	[FRANJASDIA] [varbinary](8000) NOT NULL,
 CONSTRAINT [PK__PerfilesAccesos__45F365D3] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

/****** Objeto:  Table [dbo].[PresenciaAccesos]   Fecha de la secuencia de comandos: 01/28/2010 11:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PresenciaAccesos] (
  [ID] int IDENTITY(1, 1) NOT NULL,
  [IDZONA] int NOT NULL,
  [FECHA] datetime NOT NULL,
  [EMPLEADOS] varbinary(max) NULL,
  [VISITAS] varbinary(max) NULL,
  PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

CREATE NONCLUSTERED INDEX [PresenciaAccesos_idx] ON [dbo].[PresenciaAccesos]
  ([FECHA] DESC)
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

/****** Objeto:  Table [dbo].[NMarcajesAccesos]    Fecha de la secuencia de comandos: 01/28/2010 11:50:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NMarcajesAccesos](
	[IDMAR] [int] IDENTITY(1,1) NOT NULL,
	[IDPER] [int] NOT NULL,
	[IDINC] [int] NULL,
	[IDTER] [int] NULL,
	[IDLEC] [int] NULL,
	[IDZONA] [int] NULL,
	[FECHA] [datetime] NOT NULL,
	[ORIGEN] [int] NULL,
	[TIPO] [int] NULL,
	[ESTADO] [int] NULL,
	[TAR] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[IP] [varchar](15) COLLATE Modern_Spanish_CI_AS NULL,
	[USER] [varchar](20) COLLATE Modern_Spanish_CI_AS NULL,
	[ACCESO] [char](1) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_NMarcajesAccesos] PRIMARY KEY NONCLUSTERED 
(
	[IDMAR] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE CLUSTERED INDEX [NMarcajesAccesos_IDZONA_FECHA] ON [dbo].[NMarcajesAccesos] 
(
	[IDZONA] ASC,
	[FECHA] DESC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [NMarcajesAccesos_idx_FECHA] ON [dbo].[NMarcajesAccesos]
  ([FECHA] DESC)
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [_dta_index_NMarcajesAccesos_18_1685581043__K2_K10_K7_1_3_4_5_6_8_9_11_12_13_14] ON [dbo].[NMarcajesAccesos] 
(
	[IDMAR] ASC,
	[ESTADO] ASC,
	[FECHA] ASC
)
INCLUDE ( [IDINC],
[IDTER],
[IDLEC],
[IDZONA],
[ORIGEN],
[TIPO],
[TAR],
[IP],
[USER],
[ACCESO],
[IDPER]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_index_NMarcajesAccesos_18_1685581043__K7_1_2_3_4_5_6_8_9_10_11_12_13_14] ON [dbo].[NMarcajesAccesos] 
(
	[FECHA] ASC
)
INCLUDE ( [IDMAR],
[IDPER],
[IDINC],
[IDTER],
[IDLEC],
[IDZONA],
[ORIGEN],
[TIPO],
[ESTADO],
[TAR],
[IP],
[USER],
[ACCESO]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_index_NMarcajesAccesos_18_1685581043__K7_K2_K1] ON [dbo].[NMarcajesAccesos] 
(
	[FECHA] ASC,
	[IDPER] ASC,
	[IDMAR] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Objeto:  StoredProcedure [dbo].[ObtenerAccesosZonasCorrectos]    Fecha de la secuencia de comandos: 01/28/2010 11:50:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 20/01/2010
-- Description:	Devuelve los marcajes correctos para las zonas y entre las fechas especificadas
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerAccesosZonasCorrectos]
	@IDZONAS		varchar(1000),
	@FECHAMIN		datetime,
	@FECHAMAX		datetime,
	@ISOK			bit,
	@TIPOMARCAJE	smallint
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IDMAR, IDPER, IDINC, IDTER, IDLEC, IDZONA, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, [USER], ACCESO
	FROM NMarcajesAccesos M1 	JOIN
	dbo.SplitCSV(@IDZONAS) AS s
		ON
		M1.IDZONA  = s.ID  
	WHERE ESTADO = 0 AND FECHA >= @FECHAMIN and FECHA <= @FECHAMAX AND 
		dbo.TipoMarcaje(@ISOK, @TIPOMARCAJE, TIPO) = 1
	ORDER BY FECHA DESC
END
GO
/****** Objeto:  StoredProcedure [dbo].[ObtenerDiasXIDs]    Fecha de la secuencia de comandos: 01/28/2010 11:50:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerDiasXIDs]
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

/****** Objeto:  StoredProcedure [dbo].[EliminarDiasxPersonaxFecha]    Fecha de la secuencia de comandos: 01/28/2010 11:49:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	elimina los días para 1 persona en el rango de fecha especificado
-- =============================================
CREATE PROCEDURE [dbo].[EliminarDiasxPersonaxFecha]
	@IDPER  int, 
	@FECHAINI  datetime,
	@FECHAFIN  datetime
AS
BEGIN
	SET NOCOUNT ON;

	if(@FECHAINI is null AND @FECHAFIN is null)
	BEGIN
		delete from DIAS where IDPER=@IDPER 
	END
	ELSE
	BEGIN
		if(@FECHAINI is not null AND @FECHAFIN is not null)
		BEGIN
			delete from DIAS where IDPER=@IDPER AND FECHA>=@FECHAINI AND FECHA<=@FECHAFIN;
		END
		else
		BEGIN
			if(@FECHAFIN is null)
			BEGIN
				delete DIAS FROM DIAS where IDPER = @IDPER AND FECHA >= @FECHAINI OPTION (HASH JOIN);
			END
			ELSE
			BEGIN 
				delete DIAS FROM DIAS where IDPER = @IDPER AND FECHA <= @FECHAFIN OPTION (LOOP JOIN);
			END
		END
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[ObtenerDiasxPersonaxFecha_v2]    Fecha de la secuencia de comandos: 01/28/2010 11:50:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	elimina los días para 1 persona en el rango de fecha especificado
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerDiasxPersonaxFecha_v2]
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
		   MINFIN,
		   DragTT,
		   DaysTT,
		   DragWA,
		   DaysWA,
		   DragWO,
		   DaysWO
	  FROM DIAS 
	 WHERE IDPER = COALESCE(@IDPER, @IDPER) 
	   and FECHA >= @FECHAINI 
	   and FECHA < @FECHAFIN 
	 ORDER BY FECHA
END
GO
/****** Objeto:  StoredProcedure [dbo].[SaveDays]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TYPE dbo.CalcDay
AS TABLE
(
	[IDPER] [int] NOT NULL,
	[FECHA] [datetime] NOT NULL,
	[IDJOR] [int] NULL,
	[TM] [int] NULL,
	[IDANO] [int] NULL,
	[VALORES] [varbinary](8000) NULL,
	[MINFIN] [int] NULL,
	[DragTT] [int] NULL, 
	[DaysTT] [int] NULL, 
	[DragWA] [int] NULL, 
	[DaysWA] [int] NULL, 
	[DragWO] [int] NULL, 
	[DaysWO] [int] NULL
);
GO

CREATE PROCEDURE [dbo].[SaveDays]
	@days AS dbo.CalcDay READONLY
AS
BEGIN

MERGE Dias AS TARGET
USING @days AS SOURCE
On 
  (TARGET.IDPER = SOURCE.IDPER AND TARGET.FECHA = SOURCE.FECHA)
When Matched Then
	UPDATE SET IDJOR=SOURCE.IDJOR, TM=SOURCE.TM, IDANO=SOURCE.IDANO, VALORES=SOURCE.VALORES, MINFIN = SOURCE.MINFIN, DragTT = SOURCE.DragTT, DaysTT = SOURCE.DaysTT, DragWA = SOURCE.DragWA, DaysWA = SOURCE.DaysWA, DragWO = SOURCE.DragWO, DaysWO = SOURCE.DaysWO
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IDPER, FECHA, IDJOR, TM, IDANO, VALORES, MINFIN, DragTT, DaysTT, DragWA, DaysWA, DragWO, DaysWO) 
	VALUES ( SOURCE.IDPER, SOURCE.FECHA, SOURCE.IDJOR, SOURCE.TM, SOURCE.IDANO, SOURCE.VALORES, SOURCE.MINFIN, SOURCE.DragTT, SOURCE.DaysTT, SOURCE.DragWA, SOURCE.DaysWA, SOURCE.DragWO, SOURCE.DaysWO);
END
GO
/****** Objeto:  StoredProcedure [dbo].[ObtenerAnomaliasXIdXFecha]    Fecha de la secuencia de comandos: 01/28/2010 11:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	Devuelve las anomalias entre las fechas especificadas para 1 usuario
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerAnomaliasXIdXFecha]
	@IDANO  int, 
	@FECHAINI  datetime,
	@FECHAFIN  datetime
AS
BEGIN
	SET NOCOUNT ON;

	IF @IDANO=0
	BEGIN
		SELECT * 
		  FROM DIAS WITH (INDEX (FECHAIDANO)) 
		 WHERE IDANO <> @IDANO 
		   and FECHA >= @FECHAINI 
		   AND FECHA <= @FECHAFIN 
		 ORDER BY FECHA,IDPER
	END
	ELSE
	BEGIN
		SELECT * 
		  FROM DIAS WITH (INDEX (FECHAIDANO)) 
		 WHERE IDANO = @IDANO 
		   and FECHA >= @FECHAINI
		   AND FECHA <= @FECHAFIN 
		 ORDER BY FECHA, IDPER
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[GuardarMensaje]    Fecha de la secuencia de comandos: 01/28/2010 11:49:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SaveComment]
	@TIPO	int, 
	@ID		int, 
	@DIA	datetime, 
	@FECHA	datetime, 
	@BDATA	varbinary(max)
AS
BEGIN
	INSERT INTO MENSAJES (TIPO, ID, DIA, FECHA, BDATA) VALUES (@TIPO, @ID, @DIA, @FECHA, @BDATA)
END
GO
/****** Objeto:  StoredProcedure [dbo].[HayMensajes]    Fecha de la secuencia de comandos: 01/28/2010 11:49:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 18/04/2007
-- Description:	guarda 1 mensaje
-- =============================================
CREATE PROCEDURE [dbo].[HayMensajes]
	@TIPO	int, 
	@ID		int,
	@DIA	datetime
AS
BEGIN
	DECLARE @return int
	SET @return = 0
	IF @DIA is null
	BEGIN
		SELECT @return = count(IDMSG) FROM MENSAJES WHERE TIPO = @TIPO AND ID = @ID
	END
	ELSE
	BEGIN
		SELECT @return = count(IDMSG) FROM MENSAJES WHERE TIPO = @TIPO AND ID = @ID AND DIA = @DIA
	END

	if @return IS NULL SET @return = 0
	SELECT @return
END
GO
/****** Objeto:  StoredProcedure [dbo].[ObtenerComentariosxTipoXId]    Fecha de la secuencia de comandos: 01/28/2010 11:50:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetComments]
	@TIPO  int, 
	@ID  int,
	@DIA  datetime
AS
BEGIN
	SET NOCOUNT ON;
IF @DIA IS NULL
BEGIN
	SELECT IDMSG, TIPO, ID, DIA, FECHA, TEXTO, [USER], IP, BDATA
	FROM MENSAJES M1 
	WHERE M1.ID = @ID AND M1.TIPO = @TIPO;
END
ELSE
BEGIN
	SELECT IDMSG, TIPO, ID, DIA, FECHA, TEXTO, [USER], IP, BDATA
	FROM MENSAJES M1 
	WHERE M1.ID = @ID AND M1.TIPO = @TIPO AND M1.DIA = @DIA;
END

END
GO
/****** Objeto:  StoredProcedure [dbo].[EliminarMarcaje]    Fecha de la secuencia de comandos: 01/28/2010 11:49:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	Eliminar un marcaje
-- =============================================
CREATE PROCEDURE [dbo].[EliminarMarcaje]
	@IDMAR  int
AS
BEGIN
	SET NOCOUNT ON

	DELETE FROM NMarcajes 
	WHERE IDMAR = @IDMAR;
END
GO
/****** Objeto:  StoredProcedure [dbo].[GuardaMarcaje]    Fecha de la secuencia de comandos: 01/28/2010 11:49:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	Inserta un marcaje
-- =============================================
CREATE PROCEDURE [dbo].[GuardaMarcaje]
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
/****** Objeto:  StoredProcedure [dbo].[GuardaPerfilAccesos]    Fecha de la secuencia de comandos: 01/28/2010 11:49:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 10/3/2010
-- Description: guarda un perfil de accesos
-- =============================================
CREATE PROCEDURE [dbo].[GuardaPerfilAccesos]
	@IDPERFIL  bigint, 
	@ANO  int, 
	@IDLEC  int, 
	@FRANJASDIA  varbinary(8000)
AS
BEGIN
	SET NOCOUNT ON;

    IF EXISTS(SELECT IDPERFIL FROM PerfilesAccesos WHERE IDPERFIL = @IDPERFIL AND ANO = @ANO AND IDLEC = @IDLEC)
    BEGIN

		UPDATE PerfilesAccesos SET FRANJASDIA = @FRANJASDIA 
        WHERE IDPERFIL = @IDPERFIL AND ANO = @ANO AND IDLEC = @IDLEC
    END
    ELSE
    BEGIN
        INSERT INTO PerfilesAccesos 
        (IDPERFIL, ANO, IDLEC, FRANJASDIA) VALUES 
        (@IDPERFIL, @ANO, @IDLEC, @FRANJASDIA);
    END

END
GO
/****** Objeto:  StoredProcedure [dbo].[DamePerfilAccesos]    Fecha de la secuencia de comandos: 01/28/2010 11:49:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 10/3/2010
-- Description: Obtiene un perfil de accesos
-- =============================================
CREATE PROCEDURE [dbo].[DamePerfilAccesos]
	@IDPERFIL  bigint, 
	@ANO  int, 
	@IDLEC  int
AS
BEGIN
	IF @ANO < 0 AND @IDLEC < 0
    BEGIN
    	SELECT * FROM PerfilesAccesos WHERE IDPERFIL = @IDPERFIL;
    END
    ELSE IF  @ANO < 0
    BEGIN
    	SELECT * FROM PerfilesAccesos WHERE IDPERFIL = @IDPERFIL AND IDLEC = @IDLEC;
    END
    ELSE IF  @IDLEC < 0
    BEGIN
		SELECT * FROM PerfilesAccesos WHERE IDPERFIL = @IDPERFIL AND ANO = @ANO;
    END
    ELSE
    BEGIN
	    SELECT * FROM PerfilesAccesos WHERE IDPERFIL = @IDPERFIL AND ANO = @ANO AND IDLEC = @IDLEC;
    END
END
GO

/****** Objeto:  StoredProcedure [dbo].[EliminarMarcajesXPersonaYfecha]    Fecha de la secuencia de comandos: 01/28/2010 11:49:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	elimina los marcajes entre las fechas especificadas para 1 persona
-- =============================================
CREATE PROCEDURE [dbo].[EliminarMarcajesXPersonaYfecha]
	@IDPER  int, 
	@FECHA  datetime,
	@FECHADESDE  datetime,
	@FECHAHASTA  datetime
AS
BEGIN
	SET NOCOUNT ON;

	delete NMarcajes 
	  FROM NMarcajes 
	 where IDPER >= @IDPER 
	   AND IDPER <= @IDPER 
	   and ((FECHA >= @FECHADESDE 
			AND FECHA <= @FECHAHASTA 
			AND TIPO & 0x8000000 = 0 )
			 OR (FECHA = @FECHA 
			AND TIPO & 0x8000000 = 0x8000000)) 
	OPTION (FORCE ORDER)
END
GO

/****** Objeto:  StoredProcedure [dbo].[EliminarMarcajesXPersonaYfecha2]    Fecha de la secuencia de comandos: 10/15/2014 11:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 15/10/2014
-- Description:	elimina los marcajes entre las fechas especificadas para 1 persona
-- =============================================
CREATE PROCEDURE [dbo].[EliminarMarcajesXPersonaYfecha2]
	@IDPER  int, 
	@FECHADESDE  datetime,
	@FECHAHASTA  datetime
AS
BEGIN
	SET NOCOUNT ON;

	delete NMarcajes 
	  FROM NMarcajes 
	 where IDPER = @IDPER 
	   and (FECHA >= @FECHADESDE AND FECHA <= @FECHAHASTA)
	OPTION (FORCE ORDER)
END
GO

/****** Object:  View [dbo].[VMarcajes]    Script Date: 12/29/2011 13:30:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VMarcajes]
AS
SELECT     marc.IDMAR, marc.IDPER, marc.IDINC, marc.IDTER, marc.IDLEC, marc.FECHA, marc.ORIGEN, marc.TIPO, marc.ESTADO, marc.TAR, marc.IP, marc.USUARIO, 
                      men.COMMENTS, marc.LAT, marc.LON, marc.MOBILEID, marc.CRC
FROM         dbo.NMarcajes AS marc LEFT OUTER JOIN
                          (SELECT     ID AS idmar, COUNT(1) AS COMMENTS
                            FROM          dbo.MENSAJES
                            WHERE      (TIPO = 0)
                            GROUP BY ID) AS men ON men.idmar = marc.IDMAR

GO

/****** Objeto:  StoredProcedure [dbo].[ModificaMarcaje]    Fecha de la secuencia de comandos: 01/28/2010 11:49:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	Inserta un marcaje
-- =============================================
CREATE PROCEDURE [dbo].[ModificaMarcaje]
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

/****** Objeto:  StoredProcedure [dbo].[ObtenerMarcajeXIDMAR]    Fecha de la secuencia de comandos: 01/28/2010 11:50:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 30/5/2007
-- Description:	Devuelve un marcaje
-- =============================================
create PROCEDURE [dbo].[ObtenerMarcajeXIDMAR]
	@IDMAR  int
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
/****** Objeto:  StoredProcedure [dbo].[ObtenerElementosXIdType]    Fecha de la secuencia de comandos: 01/28/2010 11:50:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	obtiene el xml de configuración
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerElementosXIdType]
	@IDTYPE  int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DATA, BDATA
	FROM AppData
	WHERE IDTYPE=@IDTYPE
	ORDER BY IDELEM
END
GO
/****** Objeto:  StoredProcedure [dbo].[EliminarElementoXIdTypeXIdelem]    Fecha de la secuencia de comandos: 01/28/2010 11:49:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 21/7/2006
-- Description:	elimina el xml de configuración
-- =============================================
CREATE PROCEDURE [dbo].[EliminarElementoXIdTypeXIdelem]
	@IDTYPE  int, 
	@IDELEM  int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE
	FROM AppData
	WHERE IDTYPE=@IDTYPE and IDELEM=@IDELEM;
END
GO
/****** Objeto:  StoredProcedure [dbo].[GuardarElemento]    Fecha de la secuencia de comandos: 01/28/2010 11:49:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 21/7/2006
-- Description:	guarda el xml de configuración
-- =============================================
CREATE PROCEDURE [dbo].[SaveElement]
	@IDTYPE  int, 
	@IDELEM  int,
	@NAME varchar(150),
	@BDATA varbinary(max)
	
AS
BEGIN

	UPDATE AppData SET NAME = @NAME, BDATA = @BDATA
	WHERE IDTYPE = @IDTYPE AND IDELEM = @IDELEM

	IF(@@ROWCOUNT=0)
	BEGIN
		INSERT INTO AppData (IDTYPE, IDELEM, NAME, BDATA)
		VALUES (@IDTYPE,@IDELEM,@NAME,@BDATA);
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[ObtenerMarcajesAccesos]    Fecha de la secuencia de comandos: 01/28/2010 11:50:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 19/01/2010
-- Description:	Devuelve los marcajes entre las fechas especificadas
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerMarcajesAccesos]

	@FECHAMIN		datetime,
	@FECHAMAX		datetime,
	@ISOK			bit,
	@TIPOMARCAJE	smallint
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IDMAR, IDPER, IDINC, IDTER, IDLEC, IDZONA, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, [USER], ACCESO 
	FROM NMarcajesAccesos M1  
	WHERE  FECHA >= @FECHAMIN and FECHA <= @FECHAMAX AND 
		dbo.TipoMarcaje(@ISOK, @TIPOMARCAJE, TIPO) = 1
  ORDER BY FECHA, IDMAR
END
GO
/****** Objeto:  StoredProcedure [dbo].[ObtenerAccesosPersona]    Fecha de la secuencia de comandos: 01/28/2010 11:50:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 19/01/2010
-- Description:	Devuelve los marcajes entre las fechas y la persona especificadas
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerAccesosPersona]
	@IDPERSONA		int,
	@FECHAMIN		datetime,
	@FECHAMAX		datetime,
	@ISOK			bit,
	@TIPOMARCAJE	smallint
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IDMAR, IDPER, IDINC, IDTER, IDLEC, IDZONA, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, [USER], ACCESO 
	FROM NMarcajesAccesos M1  
	WHERE IDPER = @IDPERSONA AND FECHA >= @FECHAMIN and FECHA <= @FECHAMAX  AND
 		dbo.TipoMarcaje(@ISOK, @TIPOMARCAJE, TIPO) = 1
 	ORDER BY FECHA, IDMAR
END
GO
/****** Objeto:  StoredProcedure [dbo].[ObtenerAccesosPersonaPosterior]    Fecha de la secuencia de comandos: 01/28/2010 11:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 19/01/2010
-- Description:	Devuelve los marcajes posteriores a la fecha y de la persona especificada
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerAccesosPersonaPosterior]
	@IDPERSONA		int,
	@FECHA			datetime,
	@ISOK			bit,
	@TIPOMARCAJE	smallint
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IDMAR, IDPER, IDINC, IDTER, IDLEC, IDZONA, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, [USER], ACCESO 
	FROM NMarcajesAccesos M1  
	WHERE IDPER = @IDPERSONA AND FECHA > @FECHA AND ESTADO = 0 AND 
		dbo.TipoMarcaje(@ISOK, @TIPOMARCAJE, TIPO) = 1
	ORDER BY  IDPER, FECHA DESC
END
GO
/****** Objeto:  StoredProcedure [dbo].[ObtenerUltimosAccesosCorrectosZona]    Fecha de la secuencia de comandos: 01/28/2010 11:50:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 20/01/2010
-- Description:	Devuelve los últimos marcajes correctos para la zona y entre las fechas especificadas
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerUltimosAccesosCorrectosZona]
	@IDZONA			int,
	@FECHAMIN		datetime,
	@FECHAMAX		datetime,
	@ISOK			bit,
	@TIPOMARCAJE	smallint
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IDMAR, IDPER, IDINC, IDTER, IDLEC, IDZONA, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, [USER], ACCESO 
	FROM NMarcajesAccesos M1 
	WHERE M1.IDZONA = @IDZONA AND M1.ESTADO = 0 AND 
		M1.IDMAR = (SELECT TOP 1 M2.IDMAR 
					FROM NMarcajesAccesos M2 
					WHERE M1.IDPER = M2.IDPER AND 
						M1.TIPO & 1024 = M2.TIPO & 1024 AND 
						M2.ESTADO = 0 AND 
						M2.FECHA <= @FECHAMAX 
					ORDER BY M2.FECHA DESC ) AND M1.FECHA>= @FECHAMIN AND
		dbo.TipoMarcaje(@ISOK, @TIPOMARCAJE, TIPO) = 1
  ORDER BY IDMAR

END
GO
/****** Objeto:  StoredProcedure [dbo].[ObtenerUltimoAccesoCorrectoPersona]    Fecha de la secuencia de comandos: 01/28/2010 11:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 20/01/2010
-- Description:	Devuelve los últimos marcajes correctos para la persona y entre las fechas especificadas
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerUltimoAccesoCorrectoPersona]
	@IDPERSONA		int,
	@FECHAMIN		datetime,
	@FECHAMAX		datetime,
	@ISOK			bit,
	@TIPOMARCAJE	smallint
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 1 IDMAR, IDPER, IDINC, IDTER, IDLEC, IDZONA, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, [USER], ACCESO 
	FROM NMarcajesAccesos M1 
	WHERE M1.IDPER = @IDPERSONA AND M1.ESTADO = 0 AND 
		M1.FECHA >= @FECHAMIN  AND
		M1.FECHA <= @FECHAMAX AND
		dbo.TipoMarcaje(@ISOK, @TIPOMARCAJE, TIPO) = 1
   ORDER BY FECHA DESC, IDMAR DESC
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[UltimosMarcajes]    Fecha de la secuencia de comandos: 01/28/2010 11:51:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[UltimosMarcajes]
(
	@FECHA datetime = GETDATE
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT  M2.IDPER, MAX(IDMAR) as IDMAR
	 FROM NMarcajesAccesos M2 
	WHERE  M2.ESTADO = 0 
	  AND M2.FECHA <= @FECHA
	GROUP BY M2.IDPER
)
GO
/****** Objeto:  StoredProcedure [dbo].[EliminarMarcajeAccesos]    Fecha de la secuencia de comandos: 01/28/2010 11:49:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 18/4/2007
-- Description:	Elimina el marcaje de acceso id
-- =============================================
CREATE PROCEDURE [dbo].[EliminarMarcajeAccesos]
	@IDMAR  int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE
	FROM NMarcajesAccesos
	WHERE IDMAR = @IDMAR;
END
GO
/****** Objeto:  StoredProcedure [dbo].[GuardarMarcajeAccesos]    Fecha de la secuencia de comandos: 01/28/2010 11:49:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 18/4/2007
-- Description: guarda un marcaje de acceso de una persona
-- =============================================
CREATE PROCEDURE [dbo].[GuardarMarcajeAccesos]
	@IDPER  int, 
	@IDINC  int, 
	@IDTER  int, 
	@IDLEC  int, 
	@IDZONA int, 
	@FECHA  datetime, 
	@ORIGEN int,
	@TIPO	int,
	@ESTADO	int,
	@TARJETAUSER varchar(50) = NULL,
	@IPUSER  varchar(15),
	@USUARIO  varchar(20),
	@ACCESO  bit
AS
BEGIN
	SET NOCOUNT ON;

INSERT INTO NMarcajesAccesos 
(IDPER, IDINC, IDTER, IDLEC, IDZONA, FECHA, ORIGEN, TIPO, ESTADO, TAR, IP, [USER], ACCESO) VALUES 
(@IDPER, @IDINC, @IDTER, @IDLEC, @IDZONA, @FECHA, @ORIGEN, @TIPO, @ESTADO, @TARJETAUSER, @IPUSER, @USUARIO, @ACCESO);




END
GO
/****** Objeto:  StoredProcedure [dbo].[ObtenerMarcajesXPersonaYFecha_v2]    Fecha de la secuencia de comandos: 01/28/2010 11:50:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 30/5/2006
-- Description:	Devuelve los marcajes entre las fechas especificadas para 1 usuario
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerMarcajesXPersonaYFecha_v2]
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
/****** Objeto:  StoredProcedure [dbo].[ObtenerAccesosZonas]    Fecha de la secuencia de comandos: 01/28/2010 11:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 18/4/2006
-- Description:	Devuelve los marcajes entre las fechas especificadas para 1 zona
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerAccesosZonas]
	@IDZONA  int, 
	@FECHAINI  datetime,
	@FECHAFIN  datetime
AS
BEGIN
	SET NOCOUNT ON;
IF(@FECHAINI IS NULL)
BEGIN
	SELECT M1.IDMAR, 
		   M1.IDPER, 
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
		   [USER], 
		   ACCESO 
	  FROM NMarcajesAccesos M1  INNER JOIN dbo.UltimosMarcajes(@FECHAFIN) as U ON U.IDMAR = M1.IDMAR
	 WHERE M1.IDZONA >= @IDZONA 
	   AND M1.IDZONA <= @IDZONA 
	   AND COALESCE(M1.ESTADO, M1.ESTADO) = 0 
	   AND M1.FECHA <= @FECHAFIN 
	
END
ELSE
BEGIN
	SELECT M1.IDMAR, 
		   M1.IDPER, 
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
		   [USER], 
		   ACCESO 
	  FROM NMarcajesAccesos M1  INNER JOIN dbo.UltimosMarcajes(@FECHAFIN) as U ON U.IDMAR = M1.IDMAR
	 WHERE M1.IDZONA >= @IDZONA 
	   AND M1.IDZONA <= @IDZONA 
	   AND COALESCE(M1.ESTADO, M1.ESTADO) = 0 
	   AND M1.FECHA BETWEEN @FECHAINI AND @FECHAFIN 
END
END
GO

/****** Objeto:  StoredProcedure [dbo].[ObtenerPresencia]    Fecha de la secuencia de comandos: 01/28/2010 11:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 17/06/2010
-- Description:	Devuelve la presencia para la fecha indicada o inferior
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerPresencia]
	@FECHA		datetime
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IDZONA, P1.FECHA, EMPLEADOS, VISITAS 
    FROM PresenciaAccesos as P1, 
    		(SELECT MAX(FECHA) as FECHA 
            FROM PresenciaAccesos 
            WHERE FECHA < @FECHA) as P2 
    WHERE P1.FECHA = P2.FECHA

END
GO

/****** Objeto:  StoredProcedure [dbo].[EliminarPresenciaDesde]    Fecha de la secuencia de comandos: 01/28/2010 11:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 17/06/2010
-- Description:	Elimina la presencia para la fecha indicada o superior
-- =============================================
CREATE PROCEDURE [dbo].[EliminarPresenciaDesde]
	@FECHA		datetime
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM PresenciaAccesos WHERE FECHA >= @FECHA;

END
GO


/****** Objeto:  StoredProcedure [[dbo].[GuardarPresencia]    Fecha de la secuencia de comandos: 01/28/2010 11:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JLL
-- Create date: 17/06/2010
-- Description:	Guarda la presencia para la fecha indicada o inferior
-- =============================================
CREATE PROCEDURE [dbo].[GuardarPresencia]
	@IDZONA		Int,
	@FECHA		datetime,
    @EMPLEADOS	varbinary(8000),
    @VISITAS	varbinary(8000) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO 
    PresenciaAccesos 
    	(IDZONA, FECHA, EMPLEADOS, VISITAS) 
    values 
    	(@IDZONA, @FECHA, @EMPLEADOS, @VISITAS);

END
GO

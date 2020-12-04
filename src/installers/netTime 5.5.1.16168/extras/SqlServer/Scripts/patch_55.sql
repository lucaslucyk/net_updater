/* ------------------------------------------------------------

   DESCRIPTION:  Modifica la tabla AppData y los storeds asociados

    procedures:
        [dbo].[ObtenerElementoXIdTypeXIdelem], [dbo].[ObtenerElementosXIdType], [dbo].[SaveElement]

    tables:
        [dbo].[AppData]


   ------------------------------------------------------------ */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[AppData] ADD	[BDATA] [varbinary](max) NULL
GO
SET ANSI_PADDING OFF
GO
   
   
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ObtenerElementoXIdTypeXIdelem]
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ObtenerElementosXIdType]
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

CREATE PROCEDURE [dbo].[SaveElement]
	@IDTYPE  int, 
	@IDELEM  int,
	@NAME varchar(200),
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

/****** Objeto:  StoredProcedure [dbo].[SaveAppData]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TYPE dbo.DataElement
AS TABLE (
	[IDTYPE] [int] NOT NULL,
	[IDELEM] [int] NOT NULL,
	[BDATA] [varbinary](max) NULL
);

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveAppData]
	@elements AS dbo.DataElement READONLY
AS
BEGIN
Set transaction isolation level read uncommitted
BEGIN TRAN tranSaveAppData
MERGE AppData AS TARGET
USING @elements AS SOURCE
On 
  (TARGET.IDTYPE = SOURCE.IDTYPE AND TARGET.IDELEM = SOURCE.IDELEM)
When Matched Then
	UPDATE SET BDATA=SOURCE.BDATA
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IDTYPE, IDELEM, BDATA) 
	VALUES ( SOURCE.IDTYPE, SOURCE.IDELEM, SOURCE.BDATA);
COMMIT TRAN tranSaveAppData
END
GO
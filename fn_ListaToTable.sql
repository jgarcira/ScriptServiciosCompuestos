SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
======================================================
Objetivo : Store Procedure Convierte un Varchar a Table
Creado por : IG-Jhon Garc�a
D�a Creaci�n : 2014-03-16
Ultima Modificaci�n: 
Modific. Por : 
D�a Modifica : <Fecha modificaci�n,,formato yyyy-mm-dd>
------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[fn_ListaToTable] ( @StringInput VARCHAR(MAX) )
RETURNS @OutputTable TABLE ( [ValorRetornado] VARCHAR(10) )
AS
BEGIN
    DECLARE @String VARCHAR(10)
    WHILE LEN(@StringInput) > 0
    BEGIN
        SET @String = LEFT(@StringInput, ISNULL(NULLIF(CHARINDEX(',', @StringInput) - 1, -1), LEN(@StringInput)))
        SET @StringInput = SUBSTRING(@StringInput, ISNULL(NULLIF(CHARINDEX(',', @StringInput), 0), LEN(@StringInput)) + 1, LEN(@StringInput))
        INSERT INTO @OutputTable ( [ValorRetornado] )
        VALUES ( @String )
    END   
    RETURN
END
GO

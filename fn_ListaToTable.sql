SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
======================================================
Objetivo : Funcion Table-Valued Convierte un Varchar a Table
Creado por : IG-Jhon García
Día Creación : 2014-03-16
Ultima Modificación: 
Modific. Por : 
Día Modifica : <Fecha modificación,,formato yyyy-mm-dd>
------------------------------------------------------------------------------------------------*/

ALTER FUNCTION [dbo].[fn_ListaToTable] ( @StringInput VARCHAR(MAX) )
RETURNS @OutputTable TABLE ( [IdServicio] VARCHAR(50), [IdEstablecimiento] VARCHAR(50), [IdTipoCategoria] VARCHAR(50))
AS
BEGIN
   DECLARE @NameValuePair   VARCHAR(100), @idServicio VARCHAR(50), @idEstablecimiento VARCHAR(50), @idTipoCategoria VARCHAR(50)
	
	WHILE LEN(@StringInput) > 0
	BEGIN
		SET @NameValuePair = LEFT(@StringInput, 
								  ISNULL(NULLIF(CHARINDEX(',', @StringInput) - 1, -1),
								  LEN(@StringInput)))
		SET @StringInput = SUBSTRING(@StringInput,
										ISNULL(NULLIF(CHARINDEX(',', @StringInput), 0),
										LEN(@StringInput)) + 1, LEN(@StringInput))
	
		SET @idServicio = dbo.fnstrSplitLinea (@NameValuePair,'|',1)

		SET @idEstablecimiento = dbo.fnstrSplitLinea (@NameValuePair,'|',2)

		SET @idTipoCategoria = dbo.fnstrSplitLinea (@NameValuePair,'|',3)
		INSERT INTO @OutputTable ( [IdServicio], [IdEstablecimiento], [IdTipoCategoria] )
		VALUES ( @idServicio, @idEstablecimiento, @idTipoCategoria )
	END
    RETURN
END



GO



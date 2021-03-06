USE [Coltur_Viajes_Dllo_Dllo]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ListaBaseReferencia]    Script Date: 22/03/2015 10:35:38 a.m. ******/
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

ALTER FUNCTION [dbo].[fn_ListaBaseReferencia] ( @StringInput VARCHAR(MAX) )
RETURNS  @ListaBaseReferencia  TABLE ([BaseRef] VARCHAR(50))
AS
BEGIN
   DECLARE @NameValuePair   VARCHAR(100), @valorBaseRef VARCHAR(50), @idEstablecimiento VARCHAR(50), @idTipoCategoria VARCHAR(50)
	
	WHILE LEN(@StringInput) > 0
	BEGIN
		SET @NameValuePair = LEFT(@StringInput, 
								  ISNULL(NULLIF(CHARINDEX('-', @StringInput) - 1, -1),
								  LEN(@StringInput)))
		SET @StringInput = SUBSTRING(@StringInput,
										ISNULL(NULLIF(CHARINDEX('-', @StringInput), 0),
										LEN(@StringInput)) + 1, LEN(@StringInput))
	
		INSERT INTO @ListaBaseReferencia ( [BaseRef])
		VALUES ( @NameValuePair)
	END
    RETURN
END
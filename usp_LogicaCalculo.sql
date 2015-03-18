USE [Coltur_Viajes_Dllo_Dllo]
GO
/****** Object:  StoredProcedure [Maestras].[usp_LogicaCalculo]    Script Date: 17/03/2015 05:55:21 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
======================================================
Objetivo : Store Procedure que realiza los costos de Servicios Compuestos
Creado por : IG-Jhon García
Día Creación : 2014-03-10
Ultima Modificación: 
Modific. Por : 
Día Modifica : <Fecha modificación,,formato yyyy-mm-dd>
------------------------------------------------------------------------------------------------*/
ALTER PROCEDURE [Maestras].[usp_LogicaCalculo]
	@fecha DATETIME = NULL
	,@baseReferencia VARCHAR(MAX) = NULL
	,@tipoPax BIT= NULL
	,@idsServicioEstablecimiento VARCHAR(MAX)= NULL

	
AS
BEGIN
	SET NOCOUNT ON;

	/*  */
	DECLARE @OutputTable TABLE (ValorRetornado VARCHAR(10))
	INSERT INTO @OutputTable
	SELECT ValorRetornado AS IdServicio
	FROM [dbo].[fn_ListaToTable]  (@idsServicio)

	SELECT * FROM @OutputTable
	SET NOCOUNT OFF;
END



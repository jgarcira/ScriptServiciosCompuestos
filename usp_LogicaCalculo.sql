USE [Coltur_Viajes_Dllo_Dllo]
GO
/****** Object:  StoredProcedure [Maestras].[usp_LogicaCalculo]    Script Date: 22/03/2015 10:39:46 a.m. ******/
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
	,@componentesServicio VARCHAR(MAX)= NULL
AS
BEGIN
SET FMTONLY OFF
	SET NOCOUNT ON;
	DECLARE @CategoriaHabitacion INT = 90001
			, @CategoriaFrecuenciaTrenes INT = 90002
			, @CategoriaRangoAlojamiento INT = 90003
			, @CategoriaRangoPersona INT = 90004
			, @CategoriaUnidadTransporte INT = 90005

	CREATE TABLE #TablaResultados ([IdServicio] INT, [IdEstablecimiento] INT, [BaseReferencia] INT, [ValorCalculadoRef] DECIMAL(12,2), [CodigoCategoriaHabitacion] INT NULL, [CategoriaHabitacion] VARCHAR(255))


	/* Se llama la función para convertir el parametro @componentesServicio a una Tabla */
	DECLARE  @ComponentesServiciosTable  TABLE ( Id int IDENTITY (1, 1) Primary key NOT NULL , [IdServicio] VARCHAR(50), [IdEstablecimiento] VARCHAR(50), [IdTipoCategoria] VARCHAR(50))
	INSERT INTO @ComponentesServiciosTable
	SELECT [IdServicio], [IdEstablecimiento], [IdTipoCategoria] FROM [dbo].[fn_ListaToTable]  (@componentesServicio)

	/* Se hace un While para comenza a buscar los servicios afines con los filtros */
	DECLARE @RowCnt INT
	DECLARE @MaxRows INT
	
	SET @MaxRows = (SELECT count(*) FROM @ComponentesServiciosTable)
	SET @RowCnt = 1		
	WHILE @RowCnt <= @MaxRows
	BEGIN
		
		DECLARE  @idServicio INT, @idEstablecimient INT, @idTipoCategoriaHabitacion INT, @idTarifario INT
		SET @idServicio = (SELECT [IdServicio] FROM @ComponentesServiciosTable WHERE Id = @RowCnt)
		SET @idEstablecimient = (SELECT [IdEstablecimiento] FROM @ComponentesServiciosTable WHERE Id = @RowCnt)
		SET @idTipoCategoriaHabitacion = (SELECT [IdTipoCategoria] FROM @ComponentesServiciosTable WHERE Id = @RowCnt)
		/* Se busca el Tarifario para hacer los calculos que se deben hacer. */
		SET @idTarifario = ISNULL((SELECT dbo.fn_BuscarTarifario(@fecha,@idEstablecimient,@idServicio)),0)
		--PRINT 'Id Servicio: ' + CONVERT(VARCHAR,@idServicio) + ' Id Tarifario: ' + CONVERT(VARCHAR,@idTarifario) 
		if(@idTarifario != 0)
			BEGIN
				DECLARE @codigoTipoIngreso INT, @aplicacionIGV INT, @valorIGV DECIMAL(12,2), @afectoIGV BIT, @IGVNacional BIT, @IGVExtranjero BIT, @afectoRecargo DECIMAL(12,2)
				SELECT    @codigoTipoIngreso = CodigoTipoIngresoCosto
						, @aplicacionIGV = CodigoAplicacionIGV
						, @valorIGV = PorcentajeCalculoIGV
						, @afectoIGV = FlagAfectoIGV
						, @IGVNacional = FlagAfectoIGVNacional
						, @IGVExtranjero = FlagAfectoIGVExtranjero
						, @afectoRecargo =PorcentajeAfectoRecargo
				FROM         Maestras.TbTarifarios
				WHERE IdTarifario = @idTarifario
				INSERT INTO #TablaResultados ([IdServicio],[IdEstablecimiento],[BaseReferencia],[ValorCalculadoRef])
				SELECT [IdServicio],@idEstablecimient, [BaseReferencia], [ValorCalculadoRef] FROM [dbo].[fn_CalcularComponente] (@fecha,@baseReferencia,@tipoPax,@idServicio,@idTarifario,@codigoTipoIngreso,@aplicacionIGV,@valorIGV,@afectoIGV,@IGVNacional,@IGVExtranjero,@afectoRecargo,@idTipoCategoriaHabitacion)
				--PRINT 'INGRESO ' + CONVERT(VARCHAR,@idTarifario) + ' @codigoTipoIngreso   '+ CONVERT(VARCHAR,@aplicacionIGV) + ' @aplicacionIGV ' + CONVERT(VARCHAR,@aplicacionIGV) + ' @valorIGV ' + CONVERT(VARCHAR,@valorIGV)	+ ' @afectoIGV ' + CONVERT(VARCHAR,@afectoIGV) + ' @IGVNacional ' + CONVERT(VARCHAR,@IGVNacional) + ' @IGVExtranjero ' + CONVERT(VARCHAR,@IGVExtranjero) + ' @afectoRecargo ' + CONVERT(VARCHAR,@afectoRecargo)
				--PRINT 'SELECT [IdServicio],'+CONVERT(VARCHAR,@idEstablecimient)+', [BaseReferencia], [ValorCalculadoRef] FROM [dbo].[fn_CalcularComponente] ('+CONVERT(VARCHAR,@fecha)+','+CONVERT(VARCHAR,@baseReferencia)+','+CONVERT(VARCHAR,@tipoPax)+','+CONVERT(VARCHAR,@idServicio)+','+CONVERT(VARCHAR,@idTarifario)+','+CONVERT(VARCHAR,@codigoTipoIngreso)+','+CONVERT(VARCHAR,@aplicacionIGV)+','+CONVERT(VARCHAR,@valorIGV)+','+CONVERT(VARCHAR,@afectoIGV)+','+CONVERT(VARCHAR,@IGVNacional)+','+CONVERT(VARCHAR,@IGVExtranjero)+','+CONVERT(VARCHAR,@afectoRecargo)+','+CONVERT(VARCHAR,@idTipoCategoriaHabitacion)+')'
			END
		--ELSE
		--	BEGIN
		--		--INSERT INTO #TablaResultados ([IdServicio],[IdEstablecimiento],[BaseReferencia],[ValorCalculadoRef])
		--		--SELECT @idServicio,@idEstablecimient,1, 0 
		--	END
		SET @RowCnt = @RowCnt + 1
	END

	SELECT [IdServicio],[IdEstablecimiento],[BaseReferencia], [ValorCalculadoRef], [CodigoCategoriaHabitacion], [CategoriaHabitacion] FROM			#TablaResultados
	--DECLARE @cols NVARCHAR(MAX), @query  NVARCHAR(MAX);
	--select @cols = STUFF((SELECT ',' + QUOTENAME(BaseReferencia) 
 --                   from  #TablaResultados
 --                   group by BaseReferencia
 --                   order by BaseReferencia
 --           FOR XML PATH(''), TYPE
 --           ).value('.', 'NVARCHAR(MAX)') 
 --       ,1,1,'')
	
	--	set @query = N'	SELECT * from 
	--			   (SELECT * FROM  #TablaResultados ) x
	--				pivot 
	--				(
	--					max([ValorCalculadoRef])
	--					for BaseReferencia in (' + @cols + N')
	--				) p '

	--	exec sp_executesql @query
	DROP TABLE #TablaResultados
	

	SET NOCOUNT OFF;
END








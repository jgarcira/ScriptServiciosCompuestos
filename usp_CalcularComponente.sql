USE [Coltur_Viajes_Dllo_Dllo]
GO
/****** Object:  StoredProcedure [dbo].[usp_CalcularComponente]    Script Date: 22/03/2015 10:40:14 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
======================================================
Objetivo : Store Procedure para los calcular los Componentes de Servicio
Creado por : IG-Jhon García
Día Creación : 2014-03-16
Ultima Modificación: 
Modific. Por : 
Día Modifica : <Fecha modificación,,formato yyyy-mm-dd>
------------------------------------------------------------------------------------------------*/

ALTER PROC [dbo].[usp_CalcularComponente] ( 
	-- Parametros Principales
	@fecha DATETIME 
	, @baseReferencia VARCHAR(MAX) 
	, @tipoPax BIT
	, @idServicio INT
	-- Parametros de valores de Tarifio
	, @IdTarifario INT
	, @codigoTipoIngreso INT
	, @aplicacionIGV INT
	, @valorIGV DECIMAL(12,2)
	, @afectoIGV BIT
	, @IGVNacional BIT
	, @IGVExtranjero BIT
	, @afectoRecargo DECIMAL(12,2)

	-- Parametro Si el Codigo de Tipo de Categoría de Habitacion
	, @idTipoCategoriaHabitacion INT
 )

AS
BEGIN
	SET NOCOUNT ON;


	DECLARE @CategoriaHabitacion INT = 90001
			, @CategoriaFrecuenciaTrenes INT = 90002
			, @CategoriaRangoAlojamiento INT = 90003
			, @CategoriaRangoPersona INT = 90004
			, @CategoriaUnidadTransporte INT = 90005

   -- DECLARE @TablaResultados TABLE ( [IdServicio] INT, [BaseReferencia] INT, [ValorCalculadoRef] DECIMAL(12,2));
   CREATE TABLE #TablaResultados ([IdServicio] INT, [BaseReferencia] INT, [ValorCalculadoRef] DECIMAL(12,2))
   IF (@codigoTipoIngreso = @CategoriaHabitacion)
				BEGIN
					/* Se optine los valores de los Costos Simpe y Doble por categoria de habitación  */
					
					DECLARE @costoSimple DECIMAL(12,2), @costoDoble DECIMAL(12,2)
					DECLARE @valorCostoSimple DECIMAL(12,2), @valorCostoDoble DECIMAL(12,2)
					DECLARE @CategoriaHabitacionTable TABLE ( [CostoNeto] DECIMAL(12,2), CodigoArgumento INT)
					
					IF(@tipoPax = 1)
						BEGIN
								INSERT INTO @CategoriaHabitacionTable
								SELECT TOP 2 CostoExtranjero1 AS CostoNeto, CodigoArgumento FROM Maestras.TbTarifariosCostos 
								WHERE CodigoTipoCosto = @CategoriaHabitacion   
									AND CodigoTarifario = @IdTarifario
									AND ACTIVO = 1 
									AND (CodigoArgumento = @idTipoCategoriaHabitacion OR @idTipoCategoriaHabitacion IS NULL)
								ORDER BY CodigoTipoCosto desc,  CodigoArgumento
						END
					ELSE
						BEGIN
								INSERT INTO @CategoriaHabitacionTable
								SELECT TOP 2 CostoNacional1 AS CostoNeto, CodigoArgumento FROM Maestras.TbTarifariosCostos 
								WHERE CodigoTipoCosto = @CategoriaHabitacion   
									AND CodigoTarifario = @IdTarifario
									AND ACTIVO = 1 
									AND (CodigoArgumento = @idTipoCategoriaHabitacion OR @idTipoCategoriaHabitacion IS NULL)
								ORDER BY CodigoTipoCosto desc,  CodigoArgumento
						END
				
					SET @valorCostoSimple = (SELECT [CostoNeto] FROM @CategoriaHabitacionTable WHERE [CodigoArgumento] = 90501)
					SET @valorCostoDoble = (SELECT [CostoNeto] FROM @CategoriaHabitacionTable WHERE [CodigoArgumento] = 90502)

					/* 
						Costo simple: Se obtiene del tarifario el "Costo neto por persona" y la informacion de "Afecto a IGV" 
						Costo doble: Se obtiene del tarifario el "Costo neto por persona" y la informacion de "Afecto a IGV"
					*/

					IF(@IGVExtranjero = 1)
						BEGIN
							SET	@costoSimple = @valorCostoSimple * (1+(@valorIGV/100)+ @afectoRecargo)
							SET	@costoDoble = @valorCostoSimple * (1+(@valorIGV/100)+ @afectoRecargo)
						END
					ELSE
						BEGIN
							SET	@costoSimple = @valorCostoSimple
							SET	@costoDoble = @valorCostoSimple
						END

					
					/* 
						Se realiza el While para la Base referencia
					*/
					DECLARE @RowCnt INT, @MaxRows INT
					DECLARE @ListaBaseReferencia  TABLE ( Id int IDENTITY (1, 1) Primary key NOT NULL , [BaseRef] VARCHAR(50))

					INSERT INTO @ListaBaseReferencia
					SELECT [BaseRef] FROM [dbo].[fn_ListaBaseReferencia]  (@baseReferencia)

					SET @MaxRows = (SELECT count(*) FROM @ListaBaseReferencia)
					SET @RowCnt = 1		
					WHILE @RowCnt <= @MaxRows
					BEGIN
						DECLARE  @parametroBaseRef INT, @resultadoCalculo DECIMAL(12,2)
						SET @parametroBaseRef = (SELECT CONVERT(INT,[BaseRef]) FROM @ListaBaseReferencia WHERE Id = @RowCnt)
						IF(@parametroBaseRef = 1)
							BEGIN
								SET @resultadoCalculo =	@costoSimple
							END
						ELSE
							BEGIN
								SET @resultadoCalculo =	@costoDoble
							END

						INSERT INTO #TablaResultados ([IdServicio], [BaseReferencia], [ValorCalculadoRef])
							VALUES (@idServicio, @parametroBaseRef, @resultadoCalculo)	

							SET @RowCnt = @RowCnt + 1
					END
				END
	
	--SELECT *  FROM (
	--SELECT * FROM @TablaResultados 
	--) AS TempPV
	--PIVOT
	--(MAX(TempPV.[ValorCalculadoRef])
	--	FOR [BaseReferencia] IN ([2],[13],[24],[25])) AS PVT 


		--declare @columnas varchar(max)
		--set @columnas = ''
		--select @columnas =  coalesce(@columnas + '[' + cast([BaseReferencia] as varchar(12)) + '],', '')
		--	FROM (select distinct [BaseReferencia] from @TablaResultados) as DTM
		--	set @columnas = left(@columnas,LEN(@columnas)-1)
		--	DECLARE @SQLString nvarchar(500);
		--	set @SQLString = N'
		--	SELECT *
		--	FROM
		--	(SELECT * FROM @TablaResultados ) AS TempPV
		--	PIVOT
		--	(
		--	MAX(TempPV.[ValorCalculadoRef])
		--	FOR [BaseReferencia] IN (' + @columnas + ')
		--	) AS PivotTable;'
			
			DECLARE @cols NVARCHAR(MAX), @query  NVARCHAR(MAX);
			select @cols = STUFF((SELECT ',' + QUOTENAME([BaseReferencia]) 
                    from #TablaResultados
                    group by [BaseReferencia], [IdServicio]
                    order by [IdServicio]
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
		
		set @query = N'	SELECT * from 
				   (SELECT * FROM  #TablaResultados ) x
					pivot 
					(
						max([ValorCalculadoRef])
						for BaseReferencia in (' + @cols + N')
					) p '
		exec sp_executesql @query
	SET NOCOUNT OFF;

END


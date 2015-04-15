USE [Coltur_Dllo]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CalcularCategoriaRangoPersonas]    Script Date: 15/04/2015 04:28:51 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
======================================================
Objetivo : Funcion Table-Valued Categoria Personas
Creado por : IG-Jhon García
Día Creación : 2014-03-16
Ultima Modificación: 
Modific. Por : 
Día Modifica : <Fecha modificación,,formato yyyy-mm-dd>
------------------------------------------------------------------------------------------------*/

ALTER FUNCTION [dbo].[fn_CalcularCategoriaRangoPersonas] ( 
	-- Parametros Principales
	@fecha DATETIME 
	, @baseReferencia VARCHAR(MAX) 
	, @tipoPax BIT
	, @idServicio INT
	-- Parametros de valores de Tarifio
	, @IdTarifario INT
	, @valorIGV DECIMAL(12,2)
	, @IGVNacional BIT
	, @IGVExtranjero BIT
	, @afectoRecargo DECIMAL(12,2)

)
RETURNS @OutputTableRangoPersonas TABLE ([IdServicio] INT, [BaseReferencia] INT, [ValorCalculadoRef] DECIMAL(18,2))
AS
BEGIN
	/* Variables de la función	*/
		DECLARE @CategoriaTarifario INT = 90004, @numeroPasajerosBus SMALLINT, @flagPlus BIT, @maxPaxGuiar INT, @paxGrupo INT,  @porcentajeFechaEspecial DECIMAL (12,2) = 0 
	
	/* Se declaran variables de Políticas */
		DECLARE @politicasLiberadosPersonas INT = 90103		-- Liberados - Personas	
			,@politicasFechasEspeciales INT = 90104			-- Calendario de Fechas Especiales y Feriados			
	
	/* Declaración variables para el While de Base referencia */	
		DECLARE @RowCnt INT, @MaxRows INT
		DECLARE @ListaBaseReferencia  TABLE ( Id int IDENTITY (1, 1) Primary key NOT NULL , [BaseRef] VARCHAR(50))	
	
	/* Se declara variables de Liberados de Personas */
		DECLARE @cantidadParaLiberar INT, @cantidadItemLiberados INT, @cantidadMaximoLiberar INT
		DECLARE @RangoPersonasTable TABLE ([DESDE] INT, [HASTA] INT, [TarifaGrupal] DECIMAL(18,2), [TarifaPersonaAdicional] DECIMAL(18,2), [CostoNetoGrupal] DECIMAL(18,2), [CostoNetoPersona]  DECIMAL(18,2))

	/* Se consulta valores A+ - Maximo Pax a guiar - Pax por grupo */
		SELECT @flagPlus = [FlagA], @maxPaxGuiar = [PaxMaximoGuia], @paxGrupo = [PaxGrupo] FROM [Maestras].[TbTarifarios] WHERE [IdTarifario] = @IdTarifario

	/* General o Internaciona - Nacional*/
		DECLARE @tarifaGeneralInterNal bit = 0	
		SET @tarifaGeneralInterNal = ISNULL((SELECT TOP 1 FlagTarifaInternacional FROM [Maestras].[TbServicios] WHERE IdServicio = @idServicio),0)
		IF(@tarifaGeneralInterNal = 0)
		BEGIN
			INSERT INTO @RangoPersonasTable ([DESDE],[HASTA],[TarifaGrupal],[TarifaPersonaAdicional],[CostoNetoGrupal],[CostoNetoPersona])
			SELECT Desde, Hasta, TarifaExtranjero1, TarifaExtranjero2 ,CostoExtranjero1, CostoExtranjero2  FROM Maestras.TbTarifariosCostos 
				WHERE CodigoTipoCosto = @CategoriaTarifario AND CodigoTarifario = @IdTarifario ORDER BY NumeroOrden
		END
		ELSE
		BEGIN
			IF(@tipoPax = 1)
			BEGIN
				INSERT INTO @RangoPersonasTable ([DESDE],[HASTA],[TarifaGrupal],[TarifaPersonaAdicional],[CostoNetoGrupal],[CostoNetoPersona])
				SELECT Desde, Hasta, TarifaExtranjero1, TarifaExtranjero2 ,CostoExtranjero1, CostoExtranjero2  FROM Maestras.TbTarifariosCostos 
					WHERE CodigoTipoCosto = @CategoriaTarifario AND CodigoTarifario = @IdTarifario ORDER BY NumeroOrden
			END
			ELSE
				BEGIN
					INSERT INTO @RangoPersonasTable ([DESDE],[HASTA],[TarifaGrupal],[TarifaPersonaAdicional],[CostoNetoGrupal],[CostoNetoPersona])
					SELECT Desde, Hasta, TarifaNacional1, TarifaNacional2 ,CostoNacional1, CostoNacional2  FROM Maestras.TbTarifariosCostos 
						WHERE CodigoTipoCosto = @CategoriaTarifario AND CodigoTarifario = @IdTarifario ORDER BY NumeroOrden
			END
		END
			
	/* Se consulta los parametros a liberar Liberados - Personas  */ 
		SELECT TOP 1 @cantidadParaLiberar=  Cantidad1, @cantidadItemLiberados = Cantidad2, @cantidadMaximoLiberar = Cantidad3   FROM [Maestras].[TbTarifariosPoliticas] 
			WHERE CodigoTipoPolitica = @politicasLiberadosPersonas AND  CodigoTarifario = @IdTarifario AND Activo = 1

	/* Se consulta porcentaje de Fecha especiales  */ 
		SELECT TOP 1 @porcentajeFechaEspecial = Porcentaje FROM [Maestras].[TbTarifariosPoliticas] 
			WHERE CodigoTarifario = @IdTarifario AND CodigoTipoPolitica = @politicasFechasEspeciales  AND @fecha BETWEEN FechaDesde AND FechaHasta

	/* Se consulta el número de pasajeros de un Bus*/
		SET @numeroPasajerosBus = (SELECT [Valor] FROM [Maestras].[Config] WHERE [CodConfig] = 10503)

	/* Se realiza el While para la Base referencia   */

		INSERT INTO @ListaBaseReferencia
		SELECT [BaseRef] FROM [dbo].[fn_ListaBaseReferencia]  (@baseReferencia)
		SET @MaxRows = (SELECT count(*) FROM @ListaBaseReferencia)
		SET @RowCnt = 1		
		WHILE @RowCnt <= @MaxRows
		BEGIN
			/* Declara variables dentro del While */
			DECLARE  @parametroBaseRef INT,  @resultadoCalculo DECIMAL(18,2) = 0, @resultadoInsertar DECIMAL(18,2),  @costoNetoGrupal  DECIMAL(18,2), @acumuladoCostoNetoGrupal  DECIMAL(18,2) = 0
			SET @parametroBaseRef = (SELECT CONVERT(INT,[BaseRef]) FROM @ListaBaseReferencia WHERE Id = @RowCnt)

			IF(@parametroBaseRef = 1)
				BEGIN
					SET @costoNetoGrupal = (SELECT TOP 1 [CostoNetoGrupal]  FROM @RangoPersonasTable WHERE @parametroBaseRef BETWEEN DESDE AND Hasta)
					SET @resultadoInsertar = ISNULL(@costoNetoGrupal,0) * (1+(@valorIGV/100.0)+ @afectoRecargo)/@parametroBaseRef
				END
			ELSE
				BEGIN
					IF(@parametroBaseRef > @maxPaxGuiar)
						BEGIN
							DECLARE @cociente INT = 0, @residuo INT = 0, @totalGuias INT = 0, @paxsporGrupo INT = 0, @paxsobran INT = 0, @rowIWhile INT = 0, @valorAcumulado DECIMAL(18,2) = 0
							SET @cociente = (@parametroBaseRef/@maxPaxGuiar)
							SET @residuo = (@parametroBaseRef%@maxPaxGuiar)
							IF (@residuo > 0)
								SET @totalGuias = @cociente + 1
							ELSE
								SET @totalGuias = @cociente
							
							SET @paxsporGrupo = (@parametroBaseRef / @totalGuias)
							SET @paxsobran =  (@parametroBaseRef % @totalGuias)

							SET @rowIWhile = 1
							
							/* Calculos de guias */ 
							WHILE @rowIWhile <= @totalGuias
								BEGIN
									DECLARE @sumCostoNeto  DECIMAL(18,2) = 0
									IF (@rowIWhile = @totalGuias)
										BEGIN 
											DECLARE @paxsXGrupoAdicion INT
											SET @paxsXGrupoAdicion = (@paxsporGrupo + @paxsobran)
											SET @costoNetoGrupal = (SELECT TOP 1 [CostoNetoGrupal]  FROM @RangoPersonasTable WHERE @paxsXGrupoAdicion BETWEEN DESDE AND HASTA)
										END
									ELSE
										BEGIN
											SET @costoNetoGrupal = (SELECT TOP 1 [CostoNetoGrupal]  FROM @RangoPersonasTable WHERE @paxsporGrupo BETWEEN DESDE AND HASTA)
										END
									
									SET @sumCostoNeto = ISNULL(@costoNetoGrupal,0) * (1+(@valorIGV/100.0)+ @afectoRecargo)
									SET @acumuladoCostoNetoGrupal = @acumuladoCostoNetoGrupal + @sumCostoNeto
									SET @RowIWhile = @RowIWhile + 1
								END
						END
				END

				SET @resultadoCalculo = (SELECT [dbo].[fn_CalcularFechasEspeciales] (@acumuladoCostoNetoGrupal,@porcentajeFechaEspecial))		

				INSERT INTO @OutputTableRangoPersonas ([IdServicio], [BaseReferencia], [ValorCalculadoRef])
					VALUES (@idServicio, @parametroBaseRef, ISNULL(@resultadoCalculo,0))	

			SET @RowCnt = @RowCnt + 1
		END
		
    RETURN
END







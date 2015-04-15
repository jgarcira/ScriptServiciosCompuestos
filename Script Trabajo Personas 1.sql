SET NOCOUNT ON;

DECLARE
	-- Parametros Principales
	 @fecha DATE =N'2015/04/05'
	,@baseReferencia VARCHAR(MAX) = '1-10-15-16-25-26-27'
	,@tipoPax BIT= 1
	, @idServicio INT = 1353
	-- Parametros de valores de Tarifio
	, @IdTarifario INT = 435
	, @valorIGV DECIMAL(12,2) = 18.00
	, @IGVNacional BIT = 1
	, @IGVExtranjero BIT = 1
	, @afectoRecargo DECIMAL(12,2) = 0.08 
	 
	/* Variables de la función	*/
		DECLARE @CategoriaTarifario INT = 90004, @numeroPasajerosBus SMALLINT, @flagPlus BIT, @maxPaxGuiar INT, @paxGrupo INT,  @porcentajeFechaEspecial DECIMAL (12,2) = 0, @politicaColtur INT= 0, @paramNoCupoBus INT = 0, @paramNoGuia INT = 0  
	
	/* Se declaran variables de Políticas */
		DECLARE @politicasLiberadosPersonas INT = 90103		-- Liberados - Personas	
			,@politicasFechasEspeciales INT = 90104			-- Calendario de Fechas Especiales y Feriados			
	
	/* Declaración variables para el While de Base referencia */	
		DECLARE @RowCnt INT, @MaxRows INT
		DECLARE @ListaBaseReferencia  TABLE ( Id int IDENTITY (1, 1) Primary key NOT NULL , [BaseRef] VARCHAR(50))	
	
	/* Se declara variables de Liberados de Personas */
		DECLARE @cantidadParaLiberar INT, @cantidadItemLiberados INT, @cantidadMaximoLiberar INT
		DECLARE @RangoPersonasTable TABLE ([DESDE] INT, [HASTA] INT, [TarifaGrupal] DECIMAL(18,2), [TarifaPersonaAdicional] DECIMAL(18,2), [CostoNetoGrupal] DECIMAL(18,2), [CostoNetoPersona]  DECIMAL(18,2))

	/* Se consulta valores A+ - Maximo Pax a guiar - Pax por grupo - Política COLTUR */
		SELECT @flagPlus = [FlagA], @maxPaxGuiar = [PaxMaximoGuia], @paxGrupo = [PaxGrupo], @politicaColtur = [CodigoPoliticaTransporte] FROM [Maestras].[TbTarifarios] WHERE [IdTarifario] = @IdTarifario
		PRINT 'Max Grupo ' + convert(VARCHAR,@maxPaxGuiar) + ' Pax Grupo ' + convert(VARCHAR,@paxGrupo) + ' Politica Coltur ' + convert(varchar,@politicaColtur)
		
		IF( @flagPlus = 0)
			BEGIN
				SET @paramNoGuia = 1	
				SET @paramNoCupoBus = ISNULL((SELECT dbo.fn_CantidadMaximaTransportePasajeros(@politicaColtur,@fecha)),0)  -- Se consulta el número de pasajeros de un Bus	
			END
		ELSE IF((@politicaColtur = NULL OR @politicaColtur = 0) AND @maxPaxGuiar = NULL)
			BEGIN
				/* Si el servicio no tiene asociada una política de transporte y el máximo de pax a guiar esta vacío, el número de guías será 1. */
				SET @paramNoGuia = 1
			END
		ELSE IF(@politicaColtur = NULL)
			BEGIN
				/* Si el servicio no tiene asociada una política de transporte pero el máximo de pax a guiar contiene un valor, el número de guías se calcula con el valor de máximo de pax a guiar. */
				SET @paramNoCupoBus = @maxPaxGuiar
			END
		ELSE
			BEGIN
				SET @paramNoCupoBus = ISNULL((SELECT dbo.fn_CantidadMaximaTransportePasajeros(@politicaColtur,@fecha)),0)  -- Se consulta el número de pasajeros de un Bus
			END

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
		SELECT TOP 1 @cantidadParaLiberar =  Cantidad1, @cantidadItemLiberados = Cantidad2, @cantidadMaximoLiberar = Cantidad3   FROM [Maestras].[TbTarifariosPoliticas] 
			WHERE CodigoTipoPolitica = @politicasLiberadosPersonas AND  CodigoTarifario = @IdTarifario AND Activo = 1

	/* Se consulta porcentaje de Fecha especiales  */ 
		SELECT TOP 1 @porcentajeFechaEspecial = Porcentaje FROM [Maestras].[TbTarifariosPoliticas] 
			WHERE CodigoTarifario = @IdTarifario AND CodigoTipoPolitica = @politicasFechasEspeciales  AND @fecha BETWEEN FechaDesde AND FechaHasta


	/* Se realiza el While para la Base referencia   */

		INSERT INTO @ListaBaseReferencia
		SELECT [BaseRef] FROM [dbo].[fn_ListaBaseReferencia]  (@baseReferencia)

		SET @MaxRows = (SELECT count(*) FROM @ListaBaseReferencia)
		SET @RowCnt = 1		
		WHILE @RowCnt <= @MaxRows
		BEGIN
			/* Declara variables dentro del While */
			DECLARE  @parametroBaseRef INT -- Parámetro para identificar la Base Referencia dentro del cliclo While
			, @resultadoCalculo DECIMAL(18,2) = 0
			, @resultadoInsertar DECIMAL(18,2) = 0
			, @costoNetoGrupal  DECIMAL(18,2) = 0
			, @costoNetoPersonal  DECIMAL(18,2) = 0
			, @acumuladoCostoNetoGrupal   DECIMAL(18,2) = 0 -- Parámetro para acumular todos los costos netos dentro de While
			, @resultadoResta INT = 0 -- Parámetro para restar Base Ref y Pax Grupo, para calcular el Costo Neto por Persona.
			DECLARE @paramHasta INT = 0, @paramCostGrupalHasta DECIMAL(18,2) = 0, @paramCostoNetoPersonal DECIMAL(18,2) = 0
			SET @parametroBaseRef = (SELECT CONVERT(INT,[BaseRef]) FROM @ListaBaseReferencia WHERE Id = @RowCnt)

			IF(@parametroBaseRef = 1)
				BEGIN
					SET @costoNetoGrupal = (SELECT TOP 1 [CostoNetoGrupal]  FROM @RangoPersonasTable WHERE @parametroBaseRef BETWEEN DESDE AND Hasta)
					SET @acumuladoCostoNetoGrupal = ISNULL(@costoNetoGrupal,0) * (1+(@valorIGV/100.0)+ @afectoRecargo)
				END
			ELSE
				BEGIN
					IF(@paramNoGuia = 1)
						BEGIN
							SET @resultadoResta = @parametroBaseRef - @paxGrupo
							/* Si el servicio no tiene asociada una política de transporte y el máximo de pax a guiar esta vacío, el número de guías será 1. */
							SET @costoNetoGrupal = (SELECT TOP 1 [CostoNetoGrupal]  FROM @RangoPersonasTable WHERE @parametroBaseRef BETWEEN DESDE AND HASTA)
							SET @costoNetoPersonal = (SELECT TOP 1 [CostoNetoPersona]  FROM @RangoPersonasTable WHERE @parametroBaseRef BETWEEN DESDE AND HASTA)
							IF (@costoNetoGrupal IS NULL)
								BEGIN
									SET @paramHasta = 0
									SET @paramCostGrupalHasta = 0
									SET @paramCostoNetoPersonal = 0
									SELECT TOP 1  @paramHasta = [HASTA], @paramCostGrupalHasta = [CostoNetoGrupal], @paramCostoNetoPersonal = [CostoNetoPersona] 
										FROM @RangoPersonasTable ORDER BY [HASTA] DESC
									SET @resultadoResta = @parametroBaseRef - @paramHasta
									SET @acumuladoCostoNetoGrupal =  (ISNULL(@paramCostGrupalHasta,0) * (1+(@valorIGV/100.0)+ @afectoRecargo)) +  ((ISNULL(@paramCostoNetoPersonal,0) * (1+(@valorIGV/100.0)+ @afectoRecargo))* @resultadoResta )
								END
							ELSE
								BEGIN
									IF(@parametroBaseRef > @paxGrupo)
										BEGIN
											SET @acumuladoCostoNetoGrupal =  ((ISNULL(@costoNetoPersonal,0) * (1+(@valorIGV/100.0)+ @afectoRecargo))* @resultadoResta )
										END
											SET @acumuladoCostoNetoGrupal = (ISNULL(@costoNetoGrupal,0) * (1+(@valorIGV/100.0)+ @afectoRecargo)) + @acumuladoCostoNetoGrupal
							END
							
							IF(@flagPlus = 0)
								BEGIN
									IF(@parametroBaseRef > @paramNoCupoBus )	
										SET @acumuladoCostoNetoGrupal = -1
								END
														
						END
					ELSE
						BEGIN
							IF(@parametroBaseRef > @paramNoCupoBus)
								BEGIN
									/* Si la base Referencia es mayor al Número de Pax por Bus o al Máximo pasajeros a Guiar  */
									DECLARE @cociente INT = 0, @residuo INT = 0, @totalGuias INT = 0, @paxsporGrupo INT = 0
									DECLARE @paxsobran INT = 0, @rowIWhile INT = 0, @valorAcumulado DECIMAL(18,2) = 0
									SET @cociente = (CONVERT(DECIMAL,@parametroBaseRef)/CONVERT(DECIMAL,@paramNoCupoBus))
									SET @residuo = (@parametroBaseRef%@paramNoCupoBus)
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
											DECLARE @sumCostoNeto  DECIMAL(18,2) = 0, @sumCostoPorPersonaNeto  DECIMAL(18,2) = 0, @paxCalculoGrupo INT = 0
											IF (@rowIWhile = @totalGuias)
												BEGIN 
													SET @paxCalculoGrupo = (@paxsporGrupo + @paxsobran)
												END
											ELSE
												BEGIN
													SET @paxCalculoGrupo = @paxsporGrupo
												END

										SET @costoNetoGrupal = (SELECT TOP 1 [CostoNetoGrupal]  FROM @RangoPersonasTable WHERE @paxCalculoGrupo BETWEEN DESDE AND HASTA)
										SET @costoNetoPersonal = (SELECT TOP 1 [CostoNetoPersona]  FROM @RangoPersonasTable WHERE @paxCalculoGrupo BETWEEN DESDE AND HASTA)

										SET @sumCostoNeto = ISNULL(@costoNetoGrupal,0) * (1+(@valorIGV/100.0)+ @afectoRecargo)

										PRINT '@costoNetoGrupal ' +  CONVERT(VARCHAR, @costoNetoGrupal) + ' @sumCostoNeto ' +  CONVERT(VARCHAR, @sumCostoNeto)

										IF(@paxCalculoGrupo > @paxGrupo )
											BEGIN
												SET @sumCostoPorPersonaNeto = ISNULL(@costoNetoPersonal,0) * (1+(@valorIGV/100.0)+ @afectoRecargo)
												SET @acumuladoCostoNetoGrupal = @acumuladoCostoNetoGrupal + @sumCostoNeto + @sumCostoPorPersonaNeto 
											END
										ELSE
											BEGIN
											   SET @acumuladoCostoNetoGrupal = @acumuladoCostoNetoGrupal + @sumCostoNeto 
											END
										PRINT @acumuladoCostoNetoGrupal	
											SET @RowIWhile = @RowIWhile + 1
										END
								END
							ELSE
								BEGIN
									SET @costoNetoGrupal = (SELECT TOP 1 [CostoNetoGrupal]  FROM @RangoPersonasTable WHERE @parametroBaseRef BETWEEN DESDE AND HASTA)
									SET @costoNetoPersonal = (SELECT TOP 1 [CostoNetoPersona]  FROM @RangoPersonasTable WHERE @parametroBaseRef BETWEEN DESDE AND HASTA)

									IF (@costoNetoGrupal IS NULL)
										BEGIN
											SET @paramHasta = 0
											SET @paramCostGrupalHasta = 0
											SET @paramCostoNetoPersonal = 0
											SELECT TOP 1  @paramHasta = [HASTA], @paramCostGrupalHasta = [CostoNetoGrupal], @paramCostoNetoPersonal = [CostoNetoPersona] 
												FROM @RangoPersonasTable ORDER BY [HASTA] DESC
											SET @resultadoResta = @parametroBaseRef - @paramHasta
											SET @acumuladoCostoNetoGrupal =  (ISNULL(@paramCostGrupalHasta,0) * (1+(@valorIGV/100.0)+ @afectoRecargo)) +  ((ISNULL(@paramCostoNetoPersonal,0) * (1+(@valorIGV/100.0)+ @afectoRecargo))* @resultadoResta )
										END
									ELSE
										BEGIN
											IF(@parametroBaseRef > @paxGrupo)
												BEGIN
													SET @resultadoResta = @parametroBaseRef - @paxGrupo
													SET @acumuladoCostoNetoGrupal =  (ISNULL(@costoNetoGrupal,0) * (1+(@valorIGV/100.0)+ @afectoRecargo)) +  ((ISNULL(@costoNetoPersonal,0) * (1+(@valorIGV/100.0)+ @afectoRecargo))* @resultadoResta )
												END
											ELSE
												BEGIN
													SET @acumuladoCostoNetoGrupal =  (ISNULL(@costoNetoGrupal,0) * (1+(@valorIGV/100.0)+ @afectoRecargo))
												END
										END

								END
						END

				END
	
		IF(@acumuladoCostoNetoGrupal = -1)
			SET @acumuladoCostoNetoGrupal = NULL
		ELSE
			SET @acumuladoCostoNetoGrupal = @acumuladoCostoNetoGrupal / @parametroBaseRef



			SELECT @parametroBaseRef  '@parametroBaseRef',@paramNoCupoBus  '@paramNoCupoBus', @totalGuias  '@totalGuias', @paxsporGrupo '@paxsporGrupo', @paxsobran '@paxsobran',   @acumuladoCostoNetoGrupal '@acumuladoCostoNetoGrupal', @paramNoGuia '@paramNoGuia',  @cociente '@cociente'

		SET @resultadoCalculo = (SELECT [dbo].[fn_CalcularFechasEspeciales] (@acumuladoCostoNetoGrupal,@porcentajeFechaEspecial))		
		SET @RowCnt = @RowCnt + 1
		END

		--SELECT @flagPlus AS '@flagPlus', @maxPaxGuiar AS '@maxPaxGuiar', @paxGrupo AS '@paxGrupo', @politicaColtur AS '@politicaColtur', @paramNoCupoBus AS '@paramNoCupoBus'
	--		, @cantidadParaLiberar AS '@cantidadParaLiberar', @cantidadItemLiberados AS '@cantidadItemLiberados', @cantidadMaximoLiberar AS '@cantidadMaximoLiberar', @porcentajeFechaEspecial AS '@porcentajeFechaEspecial', @paramNoGuia AS '@paramNoGuia', @paramNoCupoBus AS '@paramNoCupoBus'
	SELECT * FROM @RangoPersonasTable

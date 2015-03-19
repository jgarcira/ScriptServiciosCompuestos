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

CREATE PROC [dbo].[usp_CalcularComponente] ( 
	-- Parametros Principales
	@fecha DATETIME 
	, @baseReferencia VARCHAR(MAX) 
	, @tipoPax BIT

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
	DECLARE @CategoriaHabitacion INT = 90001
			, @CategoriaFrecuenciaTrenes INT = 90002
			, @CategoriaRangoAlojamiento INT = 90003
			, @CategoriaRangoPersona INT = 90004
			, @CategoriaUnidadTransporte INT = 90005
   
   IF (@codigoTipoIngreso = @CategoriaHabitacion)
				BEGIN
					
					SELECT TOP 2 CostoExtranjero1 AS CostoNeto FROM Maestras.TbTarifariosCostos 
						WHERE CodigoTipoCosto = @CategoriaHabitacion   
							AND CodigoTarifario = 30
							AND ACTIVO = 1 
							AND (CodigoArgumento = @idTipoCategoriaHabitacion OR @idTipoCategoriaHabitacion IS NULL)
					ORDER BY CodigoTipoCosto desc,  CodigoArgumento


				END
END
GO



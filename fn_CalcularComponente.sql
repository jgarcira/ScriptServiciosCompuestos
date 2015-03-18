SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
======================================================
Objetivo : Funcion Table-Valued para los calcular los Componentes de Servicio
Creado por : IG-Jhon García
Día Creación : 2014-03-16
Ultima Modificación: 
Modific. Por : 
Día Modifica : <Fecha modificación,,formato yyyy-mm-dd>
------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[fn_CalcularComponente] ( 
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
RETURNS @OutputTable TABLE ( [IdServicio] VARCHAR(50), [IdEstablecimiento] VARCHAR(50), [IdTipoCategoria] VARCHAR(50))
AS
BEGIN
	DECLARE @CategoriaHabitacion INT = 90001
			, @CategoriaFrecuenciaTrenes INT = 90002
			, @CategoriaRangoAlojamiento INT = 90003
			, @CategoriaRangoPersona INT = 90004
			, @CategoriaUnidadTransporte INT = 90005
   
   IF (@codigoTipoIngreso = @CategoriaHabitacion)
				BEGIN
					PRINT 'CategoriaHabitacion' 
				END
				ELSE IF (@codigoTipoIngreso = @CategoriaHabitacion)
				BEGIN
					PRINT 'CategoriaHabitacion' 
				END
				ELSE IF (@codigoTipoIngreso = @CategoriaFrecuenciaTrenes)
				BEGIN
					PRINT 'CategoriaFrecuenciaTrenes' 
				END
				ELSE IF (@codigoTipoIngreso = @CategoriaRangoAlojamiento)
				BEGIN
					PRINT 'CategoriaRangoAlojamiento' 
				END
				ELSE IF (@codigoTipoIngreso = @CategoriaRangoPersona)
				BEGIN
					PRINT 'CategoriaRangoPersona' 
				END
				ELSE IF (@codigoTipoIngreso = @CategoriaUnidadTransporte)
				BEGIN
					PRINT 'CategoriaUnidadTransporte' 
				END

    RETURN
END



GO



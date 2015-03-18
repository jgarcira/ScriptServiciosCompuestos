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
	SET NOCOUNT ON;

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
		SET @idTarifario = (SELECT dbo.fn_BuscarTarifario(@fecha,@idEstablecimient,@idServicio))
		
		if(@idTarifario IS NOT NULL)
			BEGIN
				
				DECLARE @codigoTipoIngreso INT
				, @aplicacionIGV INT
				, @valorIGV DECIMAL(12,2)
				, @afectoIGV BIT
				, @IGVNacional BIT
				, @IGVExtranjero BIT
				, @afectoRecargo DECIMAL(12,2)

				SELECT    @codigoTipoIngreso = CodigoTipoIngresoCosto
						, @aplicacionIGV = CodigoAplicacionIGV
						, @valorIGV = PorcentajeCalculoIGV
						, @afectoIGV = FlagAfectoIGV
						, @IGVNacional = FlagAfectoIGVNacional
						, @IGVExtranjero = FlagAfectoIGVExtranjero
						, @afectoRecargo =PorcentajeAfectoRecargo
				FROM         Maestras.TbTarifarios
				WHERE IdTarifario = @idTarifario


			END




		SET @RowCnt = @RowCnt + 1
	END
	SET NOCOUNT OFF;
END





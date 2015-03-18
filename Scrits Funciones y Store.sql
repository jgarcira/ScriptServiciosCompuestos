SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
======================================================
Objetivo :  Función para consultar 
			del tarifario la información de la seccion de "Afecto (para cotizar)" 
Creado por : IG-Jhon García
Día Creación : 2015-03-16
Requerimiento : SERV-CU007 Administrar servicios
Ultima Modific. Por : 
Día Modifica : 
------------------------------------------------------------------------------------------------*/
CREATE FUNCTION dbo.fn_Consultar_Afecto_Tarifas
(	
	@idTarifario INT
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT CodigoAplicacionIGV AS AplicaIGV  
		, PorcentajeCalculoIGV AS CalculoIGV
		, PorcentajeCalculoRecargo AS RecargoServicio
		, PorcentajeCalculoComision AS Comision
		, FlagAfectoIGV AS AfectoIGV
		, FlagAfectoIGVNacional AS AfectoIGVNacional
		, FlagAfectoIGVExtranjero AS AfectoIGVExtranjero
		, PorcentajeAfectoRecargo AS AfectoRecargo
		FROM         Maestras.TbTarifarios
			WHERE IdTarifario =  @idTarifario
)
GO


/*
======================================================
Objetivo : Store Procedure Convierte un Varchar a Table
Creado por : IG-Jhon García
Día Creación : 2014-03-16
Ultima Modificación: 
Modific. Por : 
Día Modifica : <Fecha modificación,,formato yyyy-mm-dd>
------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[fn_ListaToTable] ( @StringInput VARCHAR(8000) )
RETURNS @OutputTable TABLE ( [ValorRetornado] VARCHAR(10) )
AS
BEGIN
    DECLARE @String VARCHAR(10)
    WHILE LEN(@StringInput) > 0
    BEGIN
        SET @String = LEFT(@StringInput, ISNULL(NULLIF(CHARINDEX(',', @StringInput) - 1, -1), LEN(@StringInput)))
        SET @StringInput = SUBSTRING(@StringInput, ISNULL(NULLIF(CHARINDEX(',', @StringInput), 0), LEN(@StringInput)) + 1, LEN(@StringInput))
        INSERT INTO @OutputTable ( [ValorRetornado] )
        VALUES ( @String )
    END   
    RETURN
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
======================================================
Objetivo :  Función devolver un Id de Tarifario según los filtros de entrada
Creado por : IG-Jhon García
Día Creación : 2015-03-16
Requerimiento : SERV-CU007 Administrar servicios
Ultima Modific. Por : 
Día Modifica : 
------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[fn_BuscarTarifario] 
(
 @FechaBusqueda DATE 
 , @idEstablecimiento INT
 , @CodigoServicio INT
)
RETURNS INT
AS
BEGIN
	DECLARE @Result int
	IF EXISTS (SELECT T.IdTarifario FROM Maestras.TbServiciosProveedorSedes SPS INNER JOIN  Maestras.TbTarifarios T ON SPS.IdServicioProveedorSede = T.CodigoServicioProveedorSede WHERE SPS.CodigoServicio =  @CodigoServicio AND SPS.CodigoProveedorSede = @idEstablecimiento AND @FechaBusqueda BETWEEN T.FechaInicioVigencia AND T.FechaFinVigencia )
			BEGIN
			 SET @Result =(	SELECT T.IdTarifario
				--, T.FechaInicioVigencia, T.FechaFinVigencia,  SPS.CodigoServicio, SPS.CodigoProveedorSede 
				FROM Maestras.TbServiciosProveedorSedes SPS 
					INNER JOIN  Maestras.TbTarifarios T 
						ON SPS.IdServicioProveedorSede = T.CodigoServicioProveedorSede
				WHERE SPS.CodigoServicio =  @CodigoServicio 
					AND SPS.CodigoProveedorSede = @idEstablecimiento 
					AND @FechaBusqueda BETWEEN T.FechaInicioVigencia AND T.FechaFinVigencia)
			END
			ELSE 
			BEGIN
				 SET @Result =(SELECT TOP 1 IdTarifario FROM (
					SELECT    T.IdTarifario,T.FechaInicioVigencia, T.FechaFinVigencia AS Fecha , DATEDIFF(dd, T.FechaFinVigencia, @FechaBusqueda ) AS FechaAprox FROM Maestras.TbServiciosProveedorSedes SPS 
							INNER JOIN  Maestras.TbTarifarios T 
								ON SPS.IdServicioProveedorSede = T.CodigoServicioProveedorSede
								WHERE SPS.CodigoServicio =  @CodigoServicio 
							AND SPS.CodigoProveedorSede = @idEstablecimiento 
							AND	 (T.FechaFinVigencia  < @FechaBusqueda)
					UNION ALL
					SELECT  T.IdTarifario,T.FechaInicioVigencia, T.FechaFinVigencia AS Fecha, DATEDIFF(dd, @FechaBusqueda,T.FechaInicioVigencia ) AS FechaAprox FROM Maestras.TbServiciosProveedorSedes SPS 
							INNER JOIN  Maestras.TbTarifarios T 
								ON SPS.IdServicioProveedorSede = T.CodigoServicioProveedorSede
									WHERE SPS.CodigoServicio =  @CodigoServicio 
							AND SPS.CodigoProveedorSede = @idEstablecimiento 
							AND	 (T.FechaInicioVigencia > @FechaBusqueda)
						) AS tEMPORAL
						ORDER BY FechaAprox)
			END
	RETURN @Result
END
GO
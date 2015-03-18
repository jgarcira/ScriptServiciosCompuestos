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
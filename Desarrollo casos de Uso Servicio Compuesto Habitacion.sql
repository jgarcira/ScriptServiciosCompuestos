/* DESARROLLO DEL CASO DE USO */


-- Buscar un Tarifario que este en la Fecha
DECLARE @FechaBusqueda DATE, @idEstablecimiento INT = 8, @CodigoServicio INT = 1202
SET @FechaBusqueda = '2013-07-11'

IF EXISTS (SELECT T.IdTarifario FROM Maestras.TbServiciosProveedorSedes SPS INNER JOIN  Maestras.TbTarifarios T ON SPS.IdServicioProveedorSede = T.CodigoServicioProveedorSede WHERE SPS.CodigoServicio =  @CodigoServicio AND SPS.CodigoProveedorSede = @idEstablecimiento AND 	@FechaBusqueda BETWEEN T.FechaInicioVigencia AND T.FechaFinVigencia )
BEGIN
	
	SELECT T.IdTarifario
	--, T.FechaInicioVigencia, T.FechaFinVigencia,  SPS.CodigoServicio, SPS.CodigoProveedorSede 
	FROM Maestras.TbServiciosProveedorSedes SPS 
		INNER JOIN  Maestras.TbTarifarios T 
			ON SPS.IdServicioProveedorSede = T.CodigoServicioProveedorSede
	WHERE SPS.CodigoServicio =  @CodigoServicio 
		AND SPS.CodigoProveedorSede = @idEstablecimiento 
		AND @FechaBusqueda BETWEEN T.FechaInicioVigencia AND T.FechaFinVigencia
END
ELSE 
BEGIN

	SELECT TOP 1 IdTarifario FROM (
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
			ORDER BY FechaAprox
END
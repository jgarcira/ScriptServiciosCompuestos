/*comment*/
DECLARE @idTarifario INT, @paxExtranjer BIT

SELECT     IdTarifarioCostos, CodigoTarifario, CodigoTipoCosto, NumeroOrden, CodigoArgumento2, CodigoArgumento, Flag, Desde, Hasta, TarifaExtranjero1, 
                      SuplementoExtranjero1, TarifaExtranjero2, CostoExtranjero1, SuplementoExtranjero2, CostoExtranjero2, TarifaNacional1, SuplementoNacional1, TarifaNacional2, 
                      CostoNacional1, SuplementoNacional2, CostoNacional2, Activo, UsuarioRegistro, FechaRegistro, UsuarioModifica, FechaModifica
FROM         Maestras.TbTarifariosCostos
  WHERE [CodigoTarifario] = 31  AND ACTIVO = 1
  GO
SELECT     IdTarifario, CodigoServicioProveedorSede, FechaInicioVigencia, FechaFinVigencia, Observacion, HoraCheckIn, HoraCheckOut, CodigoIdioma, CodigoMoneda, 
                      CodigoFormaPago, TipoCambio, CodigoTipoIngresoCosto, CodigoPoliticaTransporte, CodigoAplicacionIGV, PorcentajeCalculoIGV, PorcentajeCalculoRecargo, 
                      PorcentajeCalculoComision, FlagAfectoIGV, FlagAfectoIGVNacional, FlagAfectoIGVExtranjero, FlagEnvioVoucher, FlagPrecioVentaTarifa, PorcentajeAfectoRecargo, 
                      CodigoEstadoClonacion, Activo, UsuarioRegistro, FechaRegistro, UsuarioModifica, FechaModifica, CodigoDescripcionTarifario, FlagA, PaxMaximoGuia, 
                      PaxGrupo
FROM         Maestras.TbTarifarios
WHERE CodigoTipoIngresoCosto = 90001
ORDER BY FechaInicioVigencia
GO
  SELECT * FROM MAESTRAS.TbTarifarios where IdTarifario = 30
   SELECT * FROM MAESTRAS.TbServiciosProveedorSedes where IdServicioProveedorSede = 17
    SELECT * FROM MAESTRAS.TDETALLE WHERE NOMBRE LIKE 'No %'

	 SELECT * FROM MAESTRAS.TMAESTRO WHERE CODTABLA = 900
  SELECT * FROM MAESTRAS.TDETALLE WHERE CODTABLA = 900



/* DESARROLLO DEL CASO DE USO */


-- Buscar un Tarifario que este en la Fecha
DECLARE @FechaBusqueda DATE, @idEstablecimiento INT = 8, @CodigoServicio INT = 1202
SET @FechaBusqueda = '2013-05-11'

IF EXISTS (SELECT T.IdTarifario FROM Maestras.TbServiciosProveedorSedes SPS INNER JOIN  Maestras.TbTarifarios T ON SPS.IdServicioProveedorSede = T.CodigoServicioProveedorSede WHERE SPS.CodigoServicio =  @CodigoServicio AND SPS.CodigoProveedorSede = @idEstablecimiento AND
		@FechaBusqueda BETWEEN T.FechaInicioVigencia AND T.FechaFinVigencia )
BEGIN
	
	SELECT T.IdTarifario, T.FechaInicioVigencia, T.FechaFinVigencia,  SPS.CodigoServicio, SPS.CodigoProveedorSede 
	FROM Maestras.TbServiciosProveedorSedes SPS 
		INNER JOIN  Maestras.TbTarifarios T 
			ON SPS.IdServicioProveedorSede = T.CodigoServicioProveedorSede
	WHERE SPS.CodigoServicio =  @CodigoServicio 
		AND SPS.CodigoProveedorSede = @idEstablecimiento 
		AND @FechaBusqueda BETWEEN T.FechaInicioVigencia AND T.FechaFinVigencia
END
ELSE 
BEGIN
	PRINT 'No Existe'
END

SELECT * FROM Maestras.TbServiciosProveedorSedes WHERE CodigoServicio = 1202 AND CodigoProveedorSede = 8
SELECT * FROM Maestras.TbTarifarios WHERE CodigoServicioProveedorSede IN (24,27)

DECLARE @FechaBusqueda DATE, @idEstablecimiento INT = 8, @CodigoServicio INT = 1202
SET @FechaBusqueda = '2013-05-11'

DECLARE @FechaInicioAprox DATE,  @FechaFinAprox DATE

 SELECT  T.IdTarifario, T.FechaFinVigencia AS Fecha,  DATEDIFF(dd,@FechaBusqueda, T.FechaInicioVigencia ) AS FechaAprox FROM Maestras.TbServiciosProveedorSedes SPS 
		INNER JOIN  Maestras.TbTarifarios T 
			ON SPS.IdServicioProveedorSede = T.CodigoServicioProveedorSede
			WHERE SPS.CodigoServicio =  @CodigoServicio 
		AND SPS.CodigoProveedorSede = @idEstablecimiento 
		AND	 (CONVERT(DATE,T.FechaInicioVigencia)  > @FechaBusqueda)
UNION ALL
 SELECT  T.IdTarifario, T.FechaFinVigencia AS Fecha,  DATEDIFF(dd, T.FechaFinVigencia , @FechaBusqueda) AS FechaAprox FROM Maestras.TbServiciosProveedorSedes SPS 
		INNER JOIN  Maestras.TbTarifarios T 
			ON SPS.IdServicioProveedorSede = T.CodigoServicioProveedorSede
			WHERE SPS.CodigoServicio =  @CodigoServicio 
		AND SPS.CodigoProveedorSede = @idEstablecimiento 
		AND	 (T.FechaFinVigencia  < @FechaBusqueda)

SELECT @FechaBusqueda, @FechaInicioAprox,@FechaFinAprox, DATEDIFF(dd, @FechaFinAprox , @FechaBusqueda) AS FechaAprox1, DATEDIFF(dd, @FechaBusqueda, @FechaInicioAprox) AS FechaAprox2




SELECT * FROM  MAESTRAS.TbTarifarios 
WHERE CodigoTipoIngresoCosto = 90001
ORDER 



SELECT T.IdTarifario, T.FechaInicioVigencia, T.FechaFinVigencia,  SPS.CodigoServicio, SPS.CodigoProveedorSede 
	FROM Maestras.TbServiciosProveedorSedes SPS 
		INNER JOIN  Maestras.TbTarifarios T 
			ON SPS.IdServicioProveedorSede = T.CodigoServicioProveedorSede
WHERE YEAR(T.FechaInicioVigencia) = 2013
		ORDER BY T.FechaInicioVigencia DESC



DECLARE @FechaBusqueda DATE, @idEstablecimiento INT = 8, @CodigoServicio INT = 1202
SET @FechaBusqueda = '2013-02-11'

SELECT 
*
FROM
(
SELECT    T.IdTarifario,T.FechaInicioVigencia, T.FechaFinVigencia AS Fecha , DATEDIFF(dd,@FechaBusqueda, T.FechaFinVigencia ) AS FechaAprox FROM Maestras.TbServiciosProveedorSedes SPS 
		INNER JOIN  Maestras.TbTarifarios T 
			ON SPS.IdServicioProveedorSede = T.CodigoServicioProveedorSede
			WHERE SPS.CodigoServicio =  @CodigoServicio 
		AND SPS.CodigoProveedorSede = @idEstablecimiento 
		AND	 (T.FechaFinVigencia  > @FechaBusqueda)
--ORDER BY T.FechaInicioVigencia
UNION ALL
		SELECT  T.IdTarifario,T.FechaInicioVigencia, T.FechaFinVigencia AS Fecha, DATEDIFF(dd, T.FechaInicioVigencia, @FechaBusqueda ) AS FechaAprox FROM Maestras.TbServiciosProveedorSedes SPS 
		INNER JOIN  Maestras.TbTarifarios T 
			ON SPS.IdServicioProveedorSede = T.CodigoServicioProveedorSede
				WHERE SPS.CodigoServicio =  @CodigoServicio 
		AND SPS.CodigoProveedorSede = @idEstablecimiento 
		AND	 (CONVERT(DATE,T.FechaInicioVigencia)  < @FechaBusqueda)) AS TEMPORAL
ORDER BY FechaAprox 
GO


DECLARE @FechaBusqueda DATE, @idEstablecimiento INT = 8, @CodigoServicio INT = 1202
SET @FechaBusqueda = '2013-07-11'
SELECT TOP 1 * FROM (
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


http://stackoverflow.com/questions/11102358/how-to-pass-an-array-into-a-sql-server-stored-procedure
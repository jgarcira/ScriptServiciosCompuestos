
DECLARE @idTarifario INT, @paxExtranjer BIT

SELECT     IdTarifarioCostos, CodigoTarifario, CodigoTipoCosto, NumeroOrden, CodigoArgumento2, CodigoArgumento, Flag, Desde, Hasta, TarifaExtranjero1, 
                      SuplementoExtranjero1, TarifaExtranjero2, CostoExtranjero1, SuplementoExtranjero2, CostoExtranjero2, TarifaNacional1, SuplementoNacional1, TarifaNacional2, 
                      CostoNacional1, SuplementoNacional2, CostoNacional2, Activo, UsuarioRegistro, FechaRegistro, UsuarioModifica, FechaModifica
FROM         Maestras.TbTarifariosCostos
  WHERE [CodigoTarifario] = 31  AND ACTIVO = 1
  SELECT
GO     IdTarifario, CodigoServicioProveedorSede, FechaInicioVigencia, FechaFinVigencia, Observacion, HoraCheckIn, HoraCheckOut, CodigoIdioma, CodigoMoneda, 
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

Usage #5 : Convert a Comma-Delimited List to a Table
http://www.sql-server-helper.com/tips/tip-of-the-day.aspx?tkey=4AB06421-E859-4B5F-A948-0C9640F3108D&tkw=uses-of-the-substring-string-function

DECLARE @ListofIDs TABLE(IDs VARCHAR(100));
INSERT INTO @ListofIDs
VALUES('a'),('10'),('20'),('c'),('30'),('d');
SELECT IDs FROM @ListofIDs;
GO


DECLARE @StringInput  VARCHAR(100) =  '1,2,3,5,4,6,7,98,234'
DECLARE @StringValue  VARCHAR(100)
DECLARE @OutputTable TABLE (
    [StringValue]     VARCHAR(100)
)

WHILE LEN(@StringInput) > 0
BEGIN
    SET @StringValue = LEFT(@StringInput, 
                            ISNULL(NULLIF(CHARINDEX(',', @StringInput) - 1, -1),
                            LEN(@StringInput)))
    SET @StringInput = SUBSTRING(@StringInput,
                                 ISNULL(NULLIF(CHARINDEX(',', @StringInput), 0),
                                 LEN(@StringInput)) + 1, LEN(@StringInput))

    INSERT INTO @OutputTable ( [StringValue] )
    VALUES ( @StringValue )
END


SELECT ValorRetornado AS IdServicio FROM [dbo].[fn_ListaToTable]  ('1,2,3,5,4,6,7,98,234')

SELECT * FROM @OutputTable


DECLARE @str VARCHAR(MAX)
SET @str = '11111,22222,33333'
USE Coltur_Viajes_Dllo_Dllo

-------------------------------------

DECLARE @str varchar(100), @delimiter varchar(10)
SET @str = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15'
SET @delimiter = ','
;WITH cte AS
(
    SELECT 0 a, 1 b
    UNION ALL
    SELECT b, CHARINDEX(@delimiter, @str, b) + LEN(@delimiter)
    FROM CTE
    WHERE b > a
)
SELECT SUBSTRING(@str, a,
CASE WHEN b > LEN(@delimiter) 
    THEN b - a - LEN(@delimiter) 
    ELSE LEN(@str) - a + 1 END) value      
FROM cte WHERE a > 0


-----------

DECLARE @test varchar(max);
set @test = '21|2';
set @test = Replace(@test, '|', '.');
print @test
--SELECT ParseName(@test, 4) --returns Peter
--SELECT ParseName(@test, 3) --returns Parker
SELECT ParseName(@test, 1) AS IdServicio --returns Marvel
SELECT ParseName(@test, 2) AS IdEstablecimiento--returns Spiderman


---------------

DECLARE @DataSource TABLE
(
    [ID] TINYINT IDENTITY(1,1)
   ,[Value] NVARCHAR(128)
)   

DECLARE @Value NVARCHAR(MAX) = '1|3,2|5,6|4,4|2'

DECLARE @XML xml = N'<r><![CDATA[' + REPLACE(@Value, ',', ']]></r><r><![CDATA[') + ']]></r>'

INSERT INTO @DataSource ([Value])
SELECT RTRIM(LTRIM(T.c.value('.', 'NVARCHAR(128)')))
FROM @xml.nodes('//r') T(c)

SELECT [ID] 
      ,[Value]
FROM @DataSource



	    SET @String = LEFT(@StringInput, ISNULL(NULLIF(CHARINDEX(',', @StringInput) - 1, -1), LEN(@StringInput)))
        SET @StringInput = SUBSTRING(@StringInput, ISNULL(NULLIF(CHARINDEX(',', @StringInput), 0), LEN(@StringInput)) + 1, LEN(@StringInput))
        INSERT INTO @OutputTable ( [ValorRetornado] )
        VALUES ( @String )
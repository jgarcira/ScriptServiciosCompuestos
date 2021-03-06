
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
SET @FechaBusqueda = '2014-01-01'
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
SET @str = '21|2|3023,74|58,85|25|9052,65|85,15|74|4,45|85|257'
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
set @test = Replace(@test, '|', '.')
print @test
--SELECT ParseName(@test, 4) --returns Peter
--SELECT ParseName(@test, 3) --returns Parker

SELECT ParseName(@test, 3) AS IdServicio --returns Marvel 
SELECT ParseName(@test, 2) AS IdEstablecimiento --returns Spiderman
SELECT ParseName(@test, 1) AS CategoriaHabitacion--returns Spiderman

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



		--------------------------------------------


DECLARE @NameValuePairs  VARCHAR(MAX) = 'Color|White|1;BackColor|DarkBlue|2;Font|Arial|2;12|43'
DECLARE @NameValuePair   VARCHAR(100)
DECLARE @Name            VARCHAR(50)
DECLARE @Value           VARCHAR(50)
DECLARE @Cat           VARCHAR(50)
DECLARE @Property TABLE (
    [Name]               VARCHAR(50),
    [Value]              VARCHAR(50),
	[Cat]				 VARCHAR(50)
)

WHILE LEN(@NameValuePairs) > 0
BEGIN
    SET @NameValuePair = LEFT(@NameValuePairs, 
                              ISNULL(NULLIF(CHARINDEX(';', @NameValuePairs) - 1, -1),
                              LEN(@NameValuePairs)))
    SET @NameValuePairs = SUBSTRING(@NameValuePairs,
                                    ISNULL(NULLIF(CHARINDEX(';', @NameValuePairs), 0),
                                    LEN(@NameValuePairs)) + 1, LEN(@NameValuePairs))
	
    SET @Name = SUBSTRING(@NameValuePair, 1, CHARINDEX('|', @NameValuePair) - 1)

    SET @Value = SUBSTRING(@NameValuePair,LEN(@Name)+2, CHARINDEX('|', @NameValuePair, LEN(@Name)-1)   )

	SET @Cat = @NameValuePair + ' - '  +  CONVERT(VARCHAR,CHARINDEX('|', @NameValuePair, LEN(@Name)))
	--SET @Cat = ISNULL(SUBSTRING(@NameValuePair,LEN(@NameValuePair), CHARINDEX('|', @NameValuePair) + 1),'')
	--SET @Cat =  @NameValuePair + ' '+ CONVERT(VARCHAR,LEN(@Name)+2)
    INSERT INTO @Property ( [Name], [Value], [Cat] )
    VALUES ( @Name, @Value, @Cat )
END

SELECT * FROM @Property

---------------------------

 SELECT * FROM MAESTRAS.TDETALLE WHERE CodTabla = 900
SELECT     IdTarifario, CodigoTipoIngresoCosto, CodigoAplicacionIGV, PorcentajeCalculoIGV, FlagAfectoIGV, FlagAfectoIGVNacional, FlagAfectoIGVExtranjero, PorcentajeAfectoRecargo
FROM         Maestras.TbTarifarios
WHERE IdTarifario = 40

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
				WHERE IdTarifario = 40

				SELECT @codigoTipoIngreso,@aplicacionIGV,@valorIGV,@afectoIGV

				SELECT  CASE 22978
				
				  WHEN 22978 THEN 1
				  WHEN 23218 THEN 1
				  WHEN 23219 THEN 1
				  ELSE 0
				END 


-------------------------
-- Tarifario habitacion 31 30 32 75
SELECT * FROM Maestras.TbTarifarios WHERE CodigoTipoIngresoCosto = 90001
SELECT * FROM Maestras.TbTarifariosCostos WHERE CodigoTarifario IN (SELECT IdTarifario FROM Maestras.TbTarifarios WHERE CodigoTipoIngresoCosto = 90001)
SELECT * FROM Maestras.TbTarifariosCostos WHERE CodigoTarifario = 87 AND ACTIVO = 1

SELECT * FROM Maestras.TbTarifarios WHERE CodigoServicioProveedorSede = 170

SELECT *  FROM Maestras.TbServiciosProveedorSedes WHERE IdServicioProveedorSede = 170
SELECT * FROM Maestras.TbServicios WHERE IdServicio = 1209

SELECT * FROM MAESTRAS.TDETALLE WHERE CODTabla = 123
SELECT * FROM MAESTRAS.TDETALLE WHERE CODTabla = 905

DECLARE @codigoCatHabitacion INT = 123018
SELECT * FROM Maestras.TbTarifariosCostos WHERE CodigoTarifario = 87 
					AND ACTIVO = 1
					AND (CodigoArgumento2 = @codigoCatHabitacion OR @codigoCatHabitacion IS NULL)    



SELECT  Maestras.TbTarifarios.IdTarifario, Maestras.TbTarifarios.CodigoServicioProveedorSede, Maestras.TbTarifarios.FechaInicioVigencia, 
                      Maestras.TbTarifarios.FechaFinVigencia, Maestras.TbServiciosProveedorSedes.CodigoProveedorSede, Maestras.TbServiciosProveedorSedes.CodigoServicio, 
                      Maestras.TbTarifarios.FechaRegistro
FROM         Maestras.TbTarifarios INNER JOIN
                      Maestras.TbServiciosProveedorSedes ON Maestras.TbTarifarios.CodigoServicioProveedorSede = Maestras.TbServiciosProveedorSedes.IdServicioProveedorSede
WHERE  Maestras.TbServiciosProveedorSedes.CodigoProveedorSede = 18 AND 
	Maestras.TbServiciosProveedorSedes.CodigoServicio = 1284
ORDER BY Maestras.TbTarifarios.IdTarifario DESC					  
					  
	'1284|18'			

DECLARE @fecha DATE, @idEstablecimiento INT = 18, @idServicio INT = 1284, @idTarifario INT
SET @fecha = '2015-03-18'
SET @idTarifario = (SELECT dbo.fn_BuscarTarifario(@fecha,@idEstablecimiento,@idServicio))
SELECT @idTarifario



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
		
		
		
		USE [Coltur_Viajes_Dllo_Dllo]
GO

DECLARE	@return_value int

EXEC	@return_value = [Maestras].[usp_LogicaCalculo]
		@fecha = N'2015-03-18',
		@baseReferencia = NULL,
		@tipoPax = NULL,
		@componentesServicio = N'1284|18'

SELECT	'Return Value' = @return_value

GO
			
SELECT DISTINCT     T.IdTarifario, TC.CodigoTipoCosto, T.FechaInicioVigencia, T.FechaFinVigencia, T.CodigoServicioProveedorSede, 
                      Maestras.TbServiciosProveedorSedes.CodigoServicio
FROM         Maestras.TbTarifariosCostos AS TC INNER JOIN
                      Maestras.TbTarifarios AS T ON TC.CodigoTarifario = T.IdTarifario INNER JOIN
                      Maestras.TbServiciosProveedorSedes ON T.CodigoServicioProveedorSede = Maestras.TbServiciosProveedorSedes.IdServicioProveedorSede
WHERE TC.CodigoTipoCosto = 90001
ORDER BY T.FechaInicioVigencia DESC


ORDER BY Maestras.TbTarifarios.IdTarifario DESC					  



SELECT 90001


SELECT     IdTarifario, CodigoServicioProveedorSede, FechaInicioVigencia, FechaFinVigencia, Observacion, HoraCheckIn, HoraCheckOut, CodigoIdioma, CodigoMoneda, 
                      CodigoFormaPago, TipoCambio, CodigoTipoIngresoCosto, CodigoPoliticaTransporte, CodigoAplicacionIGV, PorcentajeCalculoIGV, PorcentajeCalculoRecargo, 
                      PorcentajeCalculoComision, FlagAfectoIGV, FlagAfectoIGVNacional, FlagAfectoIGVExtranjero, FlagEnvioVoucher, FlagPrecioVentaTarifa, PorcentajeAfectoRecargo, 
                      CodigoEstadoClonacion, Activo, UsuarioRegistro, FechaRegistro, UsuarioModifica, FechaModifica, CodigoDescripcionTarifario, FlagA, PaxMaximoGuia, 
                      PaxGrupo
FROM         Maestras.TbTarifarios
WHERE     (IdTarifario IN
                          (SELECT DISTINCT TOP (100) PERCENT T.IdTarifario
                            FROM          Maestras.TbTarifariosCostos AS TC INNER JOIN
                                                   Maestras.TbTarifarios AS T ON TC.CodigoTarifario = T.IdTarifario INNER JOIN
                                                   Maestras.TbServiciosProveedorSedes ON T.CodigoServicioProveedorSede = Maestras.TbServiciosProveedorSedes.IdServicioProveedorSede
                            WHERE      (TC.CodigoTipoCosto = 90001) AND (T.FechaInicioVigencia > '2015-01-01')))
ORDER BY FechaInicioVigencia DESC

SELECT * FROM Maestras.TbTarifariosCostos WHERE CodigoTipoCosto = 90001 ORDER BY FechaRegistro DESC
SELECT * FROM Maestras.TbTarifarios WHERE IdTarifario = 370

DECLARE @idTipoCategoriaHabitacion INT = NULL

SELECT TOP 2 CostoExtranjero1 AS CostoNeto FROM Maestras.TbTarifariosCostos 
WHERE CodigoTipoCosto = 90001   
		AND CodigoTarifario = 30
		AND ACTIVO = 1 
		AND (CodigoArgumento = @idTipoCategoriaHabitacion OR @idTipoCategoriaHabitacion IS NULL)
ORDER BY CodigoTipoCosto desc,  CodigoArgumento


SELECT CostoExtranjero1,CostoNacional1, * FROM Maestras.TbTarifariosCostos WHERE CodigoTipoCosto = 90001 

 and (CostoExtranjero1 IS NOT NULL 
OR CostoNacional1 IS NOT NULL  )
ORDER BY FechaRegistro DESC



ELSE IF (@codigoTipoIngreso = @CategoriaHabitacion)
				BEGIN
					return 'CategoriaHabitacion' 
				END
				ELSE IF (@codigoTipoIngreso = @CategoriaFrecuenciaTrenes)
				BEGIN
					SELECT 'CategoriaFrecuenciaTrenes' 
				END
				ELSE IF (@codigoTipoIngreso = @CategoriaRangoAlojamiento)
				BEGIN
					SELECT 'CategoriaRangoAlojamiento' 
				END
				ELSE IF (@codigoTipoIngreso = @CategoriaRangoPersona)
				BEGIN
					SELECT 'CategoriaRangoPersona' 
				END
				ELSE IF (@codigoTipoIngreso = @CategoriaUnidadTransporte)
				BEGIN
					SELECT 'CategoriaUnidadTransporte' 
				END

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT * FROM [Maestras].[TbTarifariosCostos] WHERE [CodigoTipoCosto] = 90001  AND [CodigoTarifario] = 404 ORDER BY [FechaRegistro] DESC

SELECT * FROM Maestras.TbTarifarios WHERE IdTarifario = 404
SELECT * FROM   Maestras.TbServiciosProveedorSedes  WHERE IdServicioProveedorSede= 381

DECLARE @idTipoCategoriaHabitacion INT = NULL
	SELECT TOP 2  CostoExtranjero1 AS CostoNeto, CodigoArgumento, * FROM Maestras.TbTarifariosCostos 
								WHERE CodigoTipoCosto = 90001   
									AND CodigoTarifario = 371
									AND ACTIVO = 1 
									AND (CodigoArgumento = @idTipoCategoriaHabitacion OR @idTipoCategoriaHabitacion IS NULL)
								ORDER BY CodigoTipoCosto desc



								---------------


								----------------

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_CalcularComponente]
		@fecha = N'2015-01-01',
		@baseReferencia = N'2,13,24,25',
		@tipoPax = 0,
		@idServicio = 1284,
		@IdTarifario = 371,
		@codigoTipoIngreso = 90001,
		@aplicacionIGV = NULL,
		@valorIGV = 18,
		@afectoIGV = NULL,
		@IGVNacional = 1,
		@IGVExtranjero = 1,
		@afectoRecargo = 0,
		@idTipoCategoriaHabitacion = 0

SELECT	'Return Value' = @return_value

GO
---------------------

SELECT *  FROM (
	SELECT * FROM @TablaResultados 
	) AS TempPV
	PIVOT
	(MAX(TempPV.[ValorCalculadoRef])
		FOR [BaseReferencia] IN ([2],[13],[24],[25])) AS PVT 


		-----------------

		SELECT * FROM [dbo].[fn_CalcularComponente] ('2015-01-01','2,13,24,25',0,1284,371,90001,NULL,18,NULL,1,1,0,0)
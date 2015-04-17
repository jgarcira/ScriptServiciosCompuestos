USE [Coltur_Dllo]
GO

SELECT [dbo].[fn_BuscarTarifario] (
   N'2015/07/06'
  ,7
  ,1249)
GO


EXEC [Maestras].[usp_LogicaCalculo] N'2015/04/06','1',1,' 1353|336,1029|7,1249|7,1256|10,1259|7,1259|6,1284|18'
-- 1353|336,1029|7,1249|7,1256|10,1259|7,1259|6,
SELECT * FROM [Maestras].[TbProveedorSedes] WHERE [Nombre] LIKE '%HOTEL LOS GIRASOLES%'


EXEC [Maestras].[usp_LogicaCalculo] N'2015/04/06','1-14-15-16-25-26-27',1,'1353|336,1029|7,1249|7,1256|10,1259|7,1259|6'

SELECT * FROM [Maestras].[TbProveedorSedes] WHERE [IdProveedorSede] = '10'
USE [Coltur_Dllo]
GO

SELECT [dbo].[fn_BuscarTarifario] (
   N'2015/04/06'
  ,6
  ,1259)
GO
SELECT * FROM [Maestras].[TbTarifarios] WHERE [IdTarifario] = 165

SELECT [IdServicio], [IdEstablecimiento], [IdTipoCategoria] FROM [dbo].[fn_ListaToTable]  ('1249|7,1256|10,1259|7,1259|6')

SELECT [BaseRef] FROM [dbo].[fn_ListaBaseReferencia]  ('1-14-15-16-25-26-27')


SELECT * FROM [Maestras].[TbTarifariosCostos] WHERE [CodigoTipoCosto]  = 90004 AND [CodigoTarifario] = 355
SELECT * FROM [Maestras].[TbTarifarios] WHERE [IdTarifario] = 355
SELECT * FROM  [Maestras].[TbServiciosProveedorSedes] WHERE [IdServicioProveedorSede]= 340
SELECT * FROM [Maestras].[TbProveedorSedes] WHERE [IdProveedorSede] = 1541


SELECT * FROM  [Maestras].[TbServiciosProveedorSedes] ORDER BY 1 DESC-- WHERE CODIGOSERVICIO = 1249
SELECT * FROM [Maestras].[TbTarifarios] WHERE [IdTarifario] = 182
SELECT * FROM [Maestras].[TbTarifariosCostos] WHERE CodigoTarifario = 182



DECLARE  @ComponentesServiciosTable  TABLE ( Id int IDENTITY (1, 1) Primary key NOT NULL , [IdServicio] VARCHAR(50), [IdEstablecimiento] VARCHAR(50), [IdTipoCategoria] VARCHAR(50))
DECLARE @componentesServicio VARCHAR(MAX), @paramGuiaCusco INT, @paramGuiaMachu INT
 ,@paramContador INT
SET @paramGuiaCusco = (SELECT [Valor] FROM [Maestras].[Config] WHERE [CodConfig] = 10411)
SET @paramGuiaMachu = (SELECT [Valor] FROM [Maestras].[Config] WHERE [CodConfig] = 10412)
SET @componentesServicio = ' 1353|336,1029|7,1249|7,1256|10,1259|7,1259|6,1284|18'
	INSERT INTO @ComponentesServiciosTable
	SELECT [IdServicio], [IdEstablecimiento], [IdTipoCategoria] FROM [dbo].[fn_ListaToTable]  (@componentesServicio)

SELECT @paramGuiaCusco, @paramGuiaMachu
SELECT * FROM @ComponentesServiciosTable
;WITH ServicioEspecial AS
(
	SELECT TOP 1 [IdServicio] FROM @ComponentesServiciosTable WHERE  [IdServicio] = @paramGuiaCusco 
	UNION ALL 
	SELECT TOP 1 [IdServicio] FROM @ComponentesServiciosTable WHERE [IdServicio] = @paramGuiaMachu
)
(SELECT @paramContador = COUNT( [IdServicio]) FROM ServicioEspecial)
IF (@paramContador = 2 )
	PRINT 'EXISTE'
ELSE 
	PRINT 'NO EXISTE'

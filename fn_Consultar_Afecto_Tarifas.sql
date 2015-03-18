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
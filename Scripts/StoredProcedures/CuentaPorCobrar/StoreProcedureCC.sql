USE [Uricao]
---------------------------------------AGREGAR------------------------------------------------------------------------
GO
/****** Object:  Table [dbo].[Banco]    Script Date: 11/17/2012 08:09:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AgregarCuenta]
@idUsuario bigint
AS
BEGIN

	SET NOCOUNT ON;

    -- Insert statements for procedure here
    --QUITAR LUEGO EL ID DE LA CUENTA
	Insert CuentaPorCobrar values('Activa',@idUsuario);
	
END



GO
/****** Object:  Table [dbo].[Banco]    Script Date: 11/17/2012 08:09:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AgregarAbono]
@fecha dateTime,
@factura bigint,
@cuenta bigint,
@monto real
AS

BEGIN

	SET NOCOUNT ON;

    -- Insert statements for procedure herea
    --QUITAR LUEGO EL ID DEl ABONO 
    
   --Abono (IdAbono , fechaAbono , montoAbono , deuda, fkIdFactura , fkIdCuentaPP , fkIdCuentaPC )
    Insert Abono values(@fecha,@monto,(( SELECT min(A.deuda)
										 FROM FACTURA F, ABONO A
									     WHERE F.IdFactura=@factura and A.fkIdFactura=@factura) - @monto),@factura,NULL,@cuenta);
	
END



GO
/****** Object:  Table [dbo].[Banco]    Script Date: 11/17/2012 08:09:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AgregarPrimerAbono]
@fecha dateTime,
@factura bigint,
@cuenta bigint,
@monto real
AS

BEGIN

	SET NOCOUNT ON;

    -- Insert statements for procedure herea
    --QUITAR LUEGO EL ID DEl ABONO 
    
   --Abono (IdAbono , fechaAbono , montoAbono , deuda, fkIdFactura , fkIdCuentaPP , fkIdCuentaPC )
    Insert Abono values(@fecha,@monto,(( SELECT F.totalFactura
										 FROM FACTURA F
									     WHERE F.IdFactura=@factura) - @monto),@factura,NULL,@cuenta);
	
END

---------------------------------------MODIFICAR------------------------------------------------------------------------
GO
/****** Object:  Table [dbo].[Banco]    Script Date: 11/17/2012 08:09:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ModificarEstadoCuenta]
@estado NVARCHAR(50),
@idCuenta bigint
AS
BEGIN

	SET NOCOUNT ON;

    -- Insert statements for procedure here
    --QUITAR LUEGO EL ID DE LA CUENTA
	UPDATE CuentaPorCobrar SET estadoCuentaPC = @estado WHERE idCuentaPC = @idCuenta; 
	
END







--------------------------------------CONSULTAS------------------------------------------------------------------------
GO
/****** Object:  Table [dbo].[Banco]    Script Date: 11/17/2012 08:09:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SelectCuentas]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM CuentaPorCobrar;
END



GO
/****** Object:  Table [dbo].[Banco]    Script Date: 11/17/2012 08:09:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[CantidadAbonos]
@idFactura bigint	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT COUNT(Abono.IdAbono) 
	FROM Abono , Factura 
	WHERE Factura.IdFactura = @idFactura
	AND   Factura.IdFactura = Abono.fkIdFactura;
END


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[BuscarUsuarioCedula]
@cedula NVARCHAR(20),
@tipo   NVARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT u.tipoidUser,u.cedulaUser, u.nombreUser1, u.nombreUser2, u.apellidoUser1, u.apellidoUser2, c.estadoCuentaPC, C.idCuentaPC
	FROM Usuario u, CuentaPorCobrar C
	where u.cedulaUser = @cedula 
	and u.tipoidUser= @tipo
	and c.fkidUsuario= u.idUsuario;
	
END

exec dbo.BuscarUsuarioCedula '19720330','V';



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CargarFacturas]
@cedula nvarchar(50),
@tipoCedula nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT w.totalAbono, f.IdFactura ,f.fechaFactura, f.totalFactura
	FROM Usuario u 
	JOIN Factura f ON
	f.fkidUsuario = u.idUsuario
	LEFT JOIN (SELECT SUM(a.montoAbono) AS totalAbono, a.fkIdFactura AS idfactura
			   FROM Abono a 
			   GROUP BY a.fkIdFactura) w ON
	w.idfactura =  f.IdFactura				 
	WHERE  (f.cedulaRifFactura = @cedula)
	AND   (u.cedulaUser = @cedula)
	AND   (u.tipoidUser = @tipoCedula)
	AND   (f.pagadoFactura = 0);
		
END
--exec dbo.CargarFacturas '19729330','V';


--exec dbo.BuscarUsuarioCedula '19560012', 'V';
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[BuscarFacturaCedula]
@cedula NVARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT f.idFactura, f.fechaFactura, f.totalFactura
	FROM Usuario u, Factura f
	where u.cedulaUser = @cedula 
	and f.cedulaRifFactura =@cedula
	and u.idUsuario= f.fkidUsuario
	and f.pagadoFactura=0;
	
END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec dbo.BuscarFacturaCF '19720330','V','01/11/2012','20/12/2012';
CREATE PROCEDURE [dbo].[BuscarFacturaCF]
@cedula NVARCHAR(20),
@tipo NVARCHAR(20),
@fechaInicio DATE,
@fechaFin DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
   SELECT w.totalAbono, f.IdFactura ,f.fechaFactura, f.totalFactura
	FROM Factura f ,Usuario u, (SELECT SUM(a.montoAbono) AS totalAbono, a.fkIdFactura AS idfactura
								 FROM Abono a 
								 GROUP BY a.fkIdFactura) AS w
					 
	WHERE  (f.cedulaRifFactura =@cedula)
	AND   (u.cedulaUser = @cedula)
	AND   (u.tipoidUser = @tipo)
    AND   (f.tipoid = @tipo)
	AND	  (f.fkidUsuario = u.idUsuario)
	AND   (w.idfactura =  f.IdFactura)
	AND   (f.pagadoFactura = 0)
	AND (f.fechaFactura >= @fechaInicio)
	AND (f.fechaFactura <= @fechaFin);
    
    
    
END
--exec dbo.BuscarFacturaCf '11123456','E','2012/12/01','2012/12/20';


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec dbo.BuscarFacturaFecha '2012/11/01','2012/12/20';
CREATE PROCEDURE [dbo].[BuscarFacturaFecha]
@fechaInicio DATE,
@fechaFin DATE
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT u.tipoidUser ,u.cedulaUser,u.nombreUser1, u.nombreUser2, u.apellidoUser1, u.apellidoUser2,c.estadoCuentaPC
	FROM Usuario u, Factura f, CuentaPorCobrar c
	where u.cedulaUser = f.cedulaRifFactura
	and (f.fechaFactura >= @fechaInicio)
	and (f.fechaFactura <= @fechaFin)
	and f.pagadoFactura = 0
	and c.fkidUsuario = u.idUsuario
	and u.tipoidUser= f.tipoid;
	
END



GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[consultarAbono]
@fechaAbono dateTime,
@factura int,
@cuenta int,
@monto real
AS
BEGIN
SET NOCOUNT ON;
SELECT a.fkIdCuentaPC, a.deuda, a.fkIdFactura, a.fechaAbono ,a.montoAbono
FROM Abono a
WHERE a.fkIdCuentaPC = @cuenta
AND   a.fkIdFactura = @factura 
AND   a.fechaAbono = @fechaAbono
AND   a.montoAbono = @monto;

END

 

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[BuscarAbonos]
@idFactura INT
AS
BEGIN
SET NOCOUNT ON;
SELECT a.montoAbono, a.deuda, a.fechaAbono 
FROM Abono a
WHERE a.fkIdFactura=@idFactura;
END
--exec dbo.BuscarAbonos 1;

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ConsultarDetalleFacturaDos]
@idFactura INT
AS
BEGIN
SET NOCOUNT ON;
SELECT d.cantidadDetalle, d.montoDetalle,t.nombreTratamiento
FROM Detalle d, Tratamiento t
WHERE d.fkIdFactura=@idFactura 
and d.fkIdTratamiento=t.IdTratamiento;
END


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[consultarTotalesAbonoFactura]
@idCuenta bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT  SUM(f.totalFactura) totalFactura, SUM(w.totalAbono) totalAbono
	FROM Factura f ,Usuario u, CuentaPorCobrar c,(SELECT SUM(a.montoAbono) AS totalAbono, a.fkIdCuentaPC AS cuenta,a.fkIdFactura AS idfactura
								 FROM Abono a 
								 GROUP BY a.fkIdFactura, a.fkIdCuentaPC) AS w
					 
	WHERE  f.IdFactura = w.idfactura
	AND   c.idCuentaPC = @idCuenta
	AND   c.idCuentaPC = w.cuenta
	AND   c.fkidUsuario = u.idUsuario
	AND   f.fkidUsuario = u.idUsuario
	
END

GO
/**** Object:  Table [dbo].[Banco]    Script Date: 11/17/2012 08:09:09 ****/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ConsultarCuenta]
@idCuenta bigint        
AS
BEGIN
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements.
       SET NOCOUNT ON;

   -- Insert statements for procedure here
       SELECT idCuentaPC,estadoCuentaPC
       FROM CuentaPorCobrar 
       WHERE idCuentaPC = @idCuenta
      
END
--exec dbo.ConsultarDetalleFactura 1;



--exec dbo.BuscarUsuarioCedula 'V', '19560012';
--exec dbo.BuscarFacturaCF 'v-17973693','01/12/2012', '20/12/2012';
--exec dbo.BuscarFacturaFecha '01/11/2012', '20/12/2012';
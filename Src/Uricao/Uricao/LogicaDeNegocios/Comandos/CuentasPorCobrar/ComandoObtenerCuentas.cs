﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Uricao.Entidades.EEntidad;
using Uricao.Entidades.FabricasEntidad;
using Uricao.Entidades.ECuentasPorCobrar;
using Uricao.AccesoDeDatos.FabricaDAOS;
using Uricao.AccesoDeDatos.DAOS;
using Uricao.LogicaDeNegocios.Fabricas;

namespace Uricao.LogicaDeNegocios.Comandos.CuentasPorCobrar
{
    public class ComandoObtenerCuentas:Comando<List<Entidad>>
    {
        #region Atributos
        #endregion Atributos
        #region Constructor
        public ComandoObtenerCuentas(){
        }
        #endregion Constructor
        #region Metodos
        public override List<Entidad> Ejecutar()
        {
            //cuentaporpagar
            return FabricaDAO.CrearFabricaDeDAO(1).CrearDAOCuentasPorCobrar().consultarCuentaCobrarConStoredProcedure();
        }
        #endregion Metodos
    }
}
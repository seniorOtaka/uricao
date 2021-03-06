﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Presentacion/MasterPage/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="EditarProveedor.aspx.cs" Inherits="Uricao.Presentacion.PaginasWeb.PProveedores.EditarProveedor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


    <div class="superior">
    <h2>
      Proveedores
    </h2>
    <p>
      <%--Descripcion de accion (opcional)  --%>
    </p>
    </div>
    <div style="height:30px; text-align:center; font-family:Verdana;font-size: 1.5em;">
        <asp:Label ID="falla" runat="server" Text="Label" CssClass="falla" 
            Visible="False"></asp:Label>
        <asp:Label ID="Exito" runat="server" Text="Label" CssClass="Exito" 
            Visible="False"></asp:Label>
    </div>
    <div  style="float:left;">
        <fieldset style="width:700px; height:380px; margin-left:4%;">
        <legend>Editar Proveedor</legend>        
            <table style="margin:5% auto auto 26%;" border="0" cellspacing="0" cellpadding="0" align="center">
            <tr>
                <td>
                    <asp:Label ID="LabelNombre" runat="server" Text="Label">Nombre:</asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="TextBoxNombre" runat="server" Height="20px" Width="130px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="LabelRif" runat="server" Text="Label">Rif:</asp:Label>
                 </td>
                <td>
                    <asp:TextBox ID="TextBoxRif" runat="server" Height="20px" Width="130px"></asp:TextBox>
                 </td>
            </tr>

            <tr>
                <td>
                    <asp:Label ID="Label1" runat="server" Text="Label">Estado:</asp:Label>
                 </td>
                <td>
                    <asp:DropDownList ID="estadoNuevo" runat="server" Height="20px" Width="130px" 
                        onselectedindexchanged="estadoNuevo_SelectedIndexChanged">
                        <asp:ListItem Value="activado">activo</asp:ListItem>
                        <asp:ListItem Value="desactivado">desactivado</asp:ListItem>
                    </asp:DropDownList>
                 </td>
            </tr>
           
            <tr >
                <td colspan="2"  style="text-align:center;">
                <asp:Button ID="defaultButton" runat="server" Text="Editar" CssClass="button" onclick="defaultButton_Click" 
                        />
                </td>
            </tr>
            </table>          
        </fieldset>
    </div>
</asp:Content>



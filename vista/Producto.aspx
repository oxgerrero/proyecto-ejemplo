<%@ Page Title="" Language="C#" MasterPageFile="~/vista/clientes.master" AutoEventWireup="true" CodeFile="~/controlador/Producto.aspx.cs" Inherits="vista_Producto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
     <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
        .auto-style3 {
            text-align: center;
        }
        .auto-style4 {
             width: 22%;
         }
        .auto-style6 {
            width: 33%;
        }
        .auto-style7 {
            width: 36%;
        }
        .auto-style9 {
            width: 22%;
            height: 23px;
        }
        .auto-style10 {
            width: 33%;
            height: 23px;
        }
        .auto-style13 {
            font-size: large;
        }
         .auto-style17 {
             font-size: medium;
             font-weight: normal;
         }
         .auto-style18 {
             font-size: medium;
         }
        </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div>
            <br />
            <br />
            <table class="auto-style1">
                <tr>
                    <td class="auto-style4">
                        <h2>
                            &nbsp;</h2>
                    </td>
                    <td class="auto-style3" colspan="2">
                        <h1>
                        <asp:Label ID="L_NombreProducto" runat="server"></asp:Label>
                        </h1>
                    </td>
                    <td class="auto-style7">&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style4">
                        <asp:Image ID="I_Producto1" runat="server" Width="106%" Height="243px" />
                        </td>
                    <td>
                        <asp:Image ID="I_Producto2" runat="server" Width="78%" Height="248px" />
                    </td>
                    <td colspan="2">
                        &nbsp;&nbsp;<br />
                        <br />
                        <asp:Image ID="I_Producto3" runat="server" Width="52%" Height="275px" />
                        &nbsp;&nbsp;
                    </td>
                </tr>
                <tr>
                    <td class="auto-style9">
                        <asp:Button ID="B_comprar" runat="server" OnClick="B_comprar_Click" Text="Comprar" />
                    </td>
                    <td class="auto-style10">Precio: $<asp:Label ID="L_PrecioU" runat="server"></asp:Label>
                        <br />
                    </td>
                    <td colspan="2">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style4">
                        &nbsp;</td>
                    <td class="auto-style6">
                        Marca:&nbsp;&nbsp;&nbsp;
                        <asp:Label ID="Label1" runat="server"></asp:Label>
                    </td>
                    <td colspan="2">
                        Referencia:&nbsp;
                        <asp:Label ID="Label2" runat="server" CssClass="auto-style17"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4">
                        &nbsp;</td>
                    <td class="auto-style6">
                        Talla:&nbsp;&nbsp;&nbsp;
                        <asp:Label ID="Label3" runat="server"></asp:Label>
                    </td>
                    <td colspan="2">
                        Tipo de bicicleta:&nbsp;
                        <asp:Label ID="Label4" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4">
                        <asp:Button ID="B_Atras" runat="server" CssClass="auto-style13" OnClick="B_Atras_Click" Text="Atras" />
                    </td>
                    <td class="auto-style6">
                        Tipo de frenos:&nbsp;&nbsp;&nbsp;
                        <asp:Label ID="Label5" runat="server"></asp:Label>
                    </td>
                    <td colspan="2">
                        <p>
                            <span class="auto-style18">Numero de piñones:&nbsp;&nbsp; </span>
                            <asp:Label ID="Label6" runat="server" CssClass="auto-style17"></asp:Label>
                        </p>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4">
                        <a href="PQRS.aspx">
                            <asp:Label ID="L_pqrs" runat="server">Generar PQRS</asp:Label>
                        </a>
                    </td>
                    <td class="auto-style6">
                        &nbsp;</td>
                    <td colspan="2">
                        Color:&nbsp;
                        <asp:TextBox ID="TB_color" runat="server" ReadOnly="True" TextMode="Color" Enabled="False"></asp:TextBox>
                    </td>
                </tr>
            </table>
        </div>
</asp:Content>


<%@ Page Title="" Language="C#" MasterPageFile="~/vista/clientes.master" AutoEventWireup="true" CodeFile="~/controlador/subasta.aspx.cs" Inherits="vista_subasta" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
            <asp:DataList ID="DL_Productos" runat="server" BorderColor="Gray" DataSourceID="ODS_subastar" GridLines="Both" RepeatColumns="2" RepeatDirection="Horizontal" BorderWidth="5px" CellSpacing="5" DataKeyField="Id">
                <ItemTemplate>
                    Imagen :
                    <asp:Image ID="Image1" runat="server" Height="250px" ImageUrl='<%# Eval("Imagen1") %>' />
                    <br />
                    Referencia:
                    <asp:Label ID="ReferenciaLabel" runat="server" Text='<%# Eval("Referencia") %>' />
                    <br />
                    Marca:
                    <asp:Label ID="MarcaLabel" runat="server" Text='<%# Eval("Marca") %>' />
                    <br />
                    oferta mayor:
                    <asp:Label ID="Puja_altaLabel" runat="server" Text='<%# Eval("Puja_alta") %>' />
                    <br />
                    Fecha_inicio:
                    <asp:Label ID="Fecha_inicioLabel" runat="server" Text='<%# Eval("Fecha_inicio") %>' />
                    <br />
                    Fecha_fin:
                    <asp:Label ID="Fecha_finLabel" runat="server" Text='<%# Eval("Fecha_fin") %>' />
                    <br />
                    <asp:Button ID="B_subasatParticipar" runat="server" CommandArgument='<%# Eval("Id") %>' OnCommand="B_subasatParticipar_Command" Text="Participar" style="height: 26px" />
                    <br />
                </ItemTemplate>
</asp:DataList>
            <asp:ObjectDataSource ID="ODS_subastar" runat="server" SelectMethod="OB_datos_subastas" TypeName="catalogo"></asp:ObjectDataSource>
</asp:Content>


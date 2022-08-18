<%@ Page Title="" Language="C#" MasterPageFile="~/vista/plantilla.master" AutoEventWireup="true" CodeFile="~/controlador/inicio.aspx.cs" Inherits="vista_inicio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style1 {
            font-size: x-small;
        }
        </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
            <h2>
            Buscar por referencia:&nbsp;
            <asp:TextBox ID="TB_buscar" onkeypress="this.value=sololetras(this.value,1,30)" runat="server"></asp:TextBox>
            &nbsp;
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="TB_buscar" CssClass="auto-style1" ErrorMessage="caracteres invalidos" OnDataBinding="RegularExpressionValidator1_DataBinding" ValidationExpression="[a-zA-Z]+"></asp:RegularExpressionValidator>
                <asp:Button ID="B_buscar" runat="server" OnClick="B_buscar_Click1" Text="Buscar" />
            <br />
            </h2>
            <asp:DataList ID="DL_Productos" runat="server" BorderColor="Gray" DataSourceID="ODS_catalogo" GridLines="Both" RepeatColumns="2" RepeatDirection="Horizontal" BorderWidth="5px" CellSpacing="5">
                <ItemTemplate>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;<asp:Image ID="Image1" runat="server" ImageUrl="~/BD/sello-verificado-del-vector-41827520.jpg" Visible='<%# Eval("verificado") %>' Width="50px" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <br />
                    <asp:ImageButton ID="ImageButton1" runat="server" CommandName='<%# Eval("Image1") %>' CommandArgument='<%# Eval("Image1") %>' ImageUrl='<%# Eval("Image1") %>' OnCommand="ImageButton1_Command" Width="50%" />
                    <br />
                    <br />
                    Precio:
                    <asp:Label ID="PrecioLabel" runat="server" Text='<%# Eval("Precio") %>' />
                    <br />
                    Marca:
                    <asp:Label ID="MarcaLabel" runat="server" Text='<%# Eval("Marca") %>' />
                    <br />
                    Referencia:
                    <asp:Label ID="ReferenciaLabel" runat="server" Text='<%# Eval("Referencia") %>' />
                    <br />
                </ItemTemplate>
</asp:DataList>
            <asp:ObjectDataSource ID="ODS_catalogo" runat="server" SelectMethod="OB_productosV" TypeName="catalogo">
            </asp:ObjectDataSource>
    <p>
        &nbsp;</p>
</asp:Content>


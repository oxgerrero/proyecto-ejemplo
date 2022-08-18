<%@ Page Title="" Language="C#" MasterPageFile="~/vista/clientes.master" AutoEventWireup="true" CodeFile="~/controlador/catalogo.aspx.cs" Inherits="vista_catalogo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
        <style type="text/css">
        .auto-style1 {
            font-size: small;
        }
        .nuevoEstilo1 {
            background-color: #0066FF;
            font-family: Cambria;
        }
            .auto-style4 {
                font-size: small;
                font-weight: normal;
            }
        </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div>
            <h2>
            <asp:Label ID="L_mensaje" runat="server"></asp:Label>
            </h2>
            <h2>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <br />
            Buscar por referencia:&nbsp;
            <asp:TextBox ID="TB_buscar" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" AutoPostBack="False"></asp:TextBox>
            &nbsp;<asp:RegularExpressionValidator ID="REV_buscar" runat="server" ControlToValidate="TB_buscar" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_0-9]+" CssClass="auto-style4"></asp:RegularExpressionValidator>
            &nbsp;<asp:Button ID="B_buscar" runat="server" OnClick="B_buscar_Click" Text="Buscar" />
                <asp:Button ID="B_insertar" runat="server" OnClick="B_insertar_Click" Text="Insertar" />
            <br />
            </h2>
            <asp:DataList ID="DL_Productos" runat="server" BorderColor="Gray" DataSourceID="ODS_productos" GridLines="Both" RepeatColumns="2" RepeatDirection="Horizontal" BorderWidth="5px" CellSpacing="5">
                <ItemTemplate>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;<asp:Image ID="Image1" runat="server" ImageUrl="~/BD/sello-verificado-del-vector-41827520.jpg" Visible='<%# Eval("verificado") %>' Width="50px" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <br />
                    <asp:ImageButton ID="ImageButton1" runat="server" CommandArgument='<%# Eval("Image1") %>' CommandName='<%# Eval("Image1") %>' ImageUrl='<%# Eval("Image1") %>' OnCommand="ImageButton1_Command" Width="50%" />
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
            <asp:ObjectDataSource ID="ODS_productos" runat="server" SelectMethod="OB_productosV" TypeName="catalogo">
            </asp:ObjectDataSource>
        </div>
    </div>
</asp:Content>


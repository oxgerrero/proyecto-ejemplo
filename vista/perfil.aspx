<%@ Page Title="" Language="C#" MasterPageFile="~/vista/clientes.master" AutoEventWireup="true" CodeFile="~/controlador/perfil.aspx.cs" Inherits="vista_perfil" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style6 {
            width: 145px;
        }
        .auto-style7 {
            width: 459px;
        }
        .auto-style8 {
            width: 145px;
            height: 39px;
        }
        .auto-style9 {
            width: 459px;
            height: 39px;
        }
        .auto-style10 {
            height: 39px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table class="auto-style2">
        <tr>
            <td class="auto-style6">
                <p>
                    nombres:</p>
            </td>
            <td class="auto-style7">
                <asp:TextBox ID="TB_editarNombre" runat="server" Enabled="False"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="TB_editarNombref" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" Visible="False"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_editarNombre" runat="server" ControlToValidate="TB_editarNombref" ErrorMessage="*"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="REV_editarNombre" runat="server" ControlToValidate="TB_editarNombref" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z]+"></asp:RegularExpressionValidator>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style6">
                <p>
                    apellidos:</p>
            </td>
            <td class="auto-style7">
                <asp:TextBox ID="TB_editarApellido" runat="server" Enabled="False"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="TB_editarApellidof" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" Visible="False"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_editarNombre0" runat="server" ControlToValidate="TB_editarApellidof" ErrorMessage="*"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="REV_editarApellido" runat="server" ControlToValidate="TB_editarApellidof" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z]+"></asp:RegularExpressionValidator>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style6">
                <p>
                    email:</p>
            </td>
            <td class="auto-style7">
                <asp:TextBox ID="TB_editarEmail" runat="server" Enabled="False" TextMode="Email"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="TB_editarEmailf" runat="server" TextMode="Email" Visible="False"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_editarNombre1" runat="server" ControlToValidate="TB_editarEmailf" ErrorMessage="*"></asp:RequiredFieldValidator>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style6">telefono:</td>
            <td class="auto-style7">
                <asp:TextBox ID="TB_editarTelefono" runat="server" Enabled="False"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="TB_editarTelefonof" onkeypress="this.value=sololetras(this.value,5,10)" runat="server" Visible="False" TextMode="Number"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_editarNombre2" runat="server" ControlToValidate="TB_editarTelefonof" ErrorMessage="*"></asp:RequiredFieldValidator>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style8">usuario:</td>
            <td class="auto-style9">
                <asp:TextBox ID="TB_editarUsuario" runat="server" Enabled="False"></asp:TextBox>
            </td>
            <td class="auto-style10">
                <asp:TextBox ID="TB_editarUsuariof" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" EnableTheming="True" Visible="False"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_editarNombre3" runat="server" ControlToValidate="TB_editarUsuariof" ErrorMessage="*"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="REV_banco1" runat="server" ControlToValidate="TB_editarUsuariof" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z]+"></asp:RegularExpressionValidator>
            </td>
            <td class="auto-style10"></td>
        </tr>
        <tr>
            <td class="auto-style8">contraseña:</td>
            <td class="auto-style9">
                <asp:TextBox ID="TB_editarContraseña" runat="server" Enabled="False"></asp:TextBox>
            </td>
            <td class="auto-style10">
                <asp:TextBox ID="TB_editarContraseñaf" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" Visible="False"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_editarNombre4" runat="server" ControlToValidate="TB_editarContraseñaf" ErrorMessage="*" ValidationGroup="Editar_Guardar"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="REV_editarContraseña" runat="server" ControlToValidate="TB_editarContraseñaf" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z0_9]+"></asp:RegularExpressionValidator>
            </td>
            <td class="auto-style10"></td>
        </tr>
        <tr>
            <td class="auto-style6">&nbsp;</td>
            <td class="auto-style7">
                <asp:Button ID="B_editarInformacion" runat="server" OnClick="B_editarInformacion_Click" Text="Editar" />
&nbsp;<asp:Button ID="B_guardarinfoeditada" runat="server" OnClick="B_guardarinfoeditada_Click" Text="Guardar" ValidationGroup="Editar_Guardar" Visible="False" />
&nbsp;<asp:Button ID="B_cancelaredicion" runat="server" OnClick="B_cancelaredicion_Click" Text="Cancelar" Visible="False" />
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
    </table>
    <p>publicaciones del usuario</p>
    <p>&nbsp;<br />
                    <asp:DataList ID="DL_Productos" runat="server" BorderColor="Gray" DataSourceID="ODS_inventario_usuario" GridLines="Both" RepeatColumns="2" RepeatDirection="Horizontal" BorderWidth="5px" CellSpacing="5">
                <ItemTemplate>
                    <table class="auto-style2">
                        <tr>
                            <td class="auto-style5">
                                <asp:Label ID="MarcaLabel" runat="server" Text='<%# Eval("Marca") %>' />
                            </td>
                            <td>
                                <asp:Label ID="ReferenciaLabel" runat="server" Text='<%# Eval("Referencia") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td class="auto-style5">
                                <asp:ImageButton ID="IB_Productos" runat="server" CommandArgument='<%# Eval("Imagen1") %>' ImageUrl='<%# Eval("Imagen1") %>' OnCommand="IB_Productos_Command" Width="50%" />
                            </td>
                            <td>
                                <asp:Button ID="B_Editar" runat="server" CommandArgument='<%# Eval("Imagen1") %>' OnCommand="B_Editar_Command" Text="Editar" Width="78px" />
                                &nbsp;
                                <asp:Button ID="B_Subastar" runat="server" CommandArgument='<%# Eval("Id") %>' OnCommand="B_Subastar_Command" Text="subastar" Width="78px" />
                            </td>
                        </tr>
                    </table>
                    <br />
                    Precio:
                    <asp:Label ID="PrecioLabel" runat="server" Text='<%# Eval("Precio") %>' />
                </ItemTemplate>
</asp:DataList>
    
<asp:ObjectDataSource ID="ODS_inventario_usuario" runat="server" SelectMethod="OB_datos_usuario" TypeName="catalogo">
    <SelectParameters>
        <asp:SessionParameter Name="datos" SessionField="perfil" Type="Object" />
    </SelectParameters>
</asp:ObjectDataSource>
            </p>
    
</asp:Content>


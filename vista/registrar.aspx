<%@ Page Title="" Language="C#" MasterPageFile="~/vista/plantilla.master" AutoEventWireup="true" CodeFile="~/controlador/registrar.aspx.cs" Inherits="vista_registrar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
        .auto-style2 {
            width: 208px;
        }
        .auto-style3 {
            text-align: center;
        }
        .auto-style4 {
            width: 397px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table class="auto-style1">
        <tr>
            <td class="auto-style2">Nombres</td>
            <td class="auto-style4">
                <asp:TextBox ID="TB_nombre" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" ValidateRequestMode="Disabled"></asp:TextBox>
&nbsp;<asp:RequiredFieldValidator ID="RFV_nombre" runat="server" ControlToValidate="TB_nombre" ErrorMessage="*" ValidationGroup="registro"></asp:RequiredFieldValidator>
&nbsp;<asp:RegularExpressionValidator ID="REV_nombre" runat="server" ControlToValidate="TB_nombre" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z]+"></asp:RegularExpressionValidator>
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style2">Apellidos</td>
            <td class="auto-style4">
                <asp:TextBox ID="TB_apellido" onkeypress="this.value=sololetras(this.value,2,30)" runat="server"></asp:TextBox>
&nbsp;<asp:RequiredFieldValidator ID="RFV_apellido" runat="server" ControlToValidate="TB_apellido" ErrorMessage="*" ValidationGroup="registro"></asp:RequiredFieldValidator>
&nbsp;<asp:RegularExpressionValidator ID="REV_apellido" runat="server" ControlToValidate="TB_apellido" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z]+"></asp:RegularExpressionValidator>
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style2">Email</td>
            <td class="auto-style4">
                <asp:TextBox ID="TB_email" runat="server" TextMode="Email"></asp:TextBox>
&nbsp;<asp:RequiredFieldValidator ID="RFV_email" runat="server" ControlToValidate="TB_email" ErrorMessage="*" ValidationGroup="registro"></asp:RequiredFieldValidator>
&nbsp;<asp:RegularExpressionValidator ID="REV_email" runat="server" ControlToValidate="TB_email" ErrorMessage="Caracteres invalidos" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style2">Telefono</td>
            <td class="auto-style4">
                <asp:TextBox ID="TB_telefono" onkeypress="this.value=sololetras(this.value,5,10)" runat="server" TextMode="Number"></asp:TextBox>
&nbsp;<asp:RequiredFieldValidator ID="RFV_telefono" runat="server" ControlToValidate="TB_telefono" ErrorMessage="*" ValidationGroup="registro"></asp:RequiredFieldValidator>
&nbsp;<asp:RegularExpressionValidator ID="REV_telefono" runat="server" ControlToValidate="TB_telefono" ErrorMessage="Caracteres invalidos" ValidationExpression="[0-9]+"></asp:RegularExpressionValidator>
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style2">Usuario</td>
            <td class="auto-style4">
                <asp:TextBox ID="TB_usuario" onkeypress="this.value=sololetras(this.value,2,30)" runat="server"></asp:TextBox>
&nbsp;<asp:RequiredFieldValidator ID="RFV_usuario" runat="server" ControlToValidate="TB_usuario" ErrorMessage="*" ValidationGroup="registro"></asp:RequiredFieldValidator>
&nbsp;<asp:RegularExpressionValidator ID="REV_usuario" runat="server" ControlToValidate="TB_usuario" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_1-9]+"></asp:RegularExpressionValidator>
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style2">Contraseña</td>
            <td class="auto-style4">
                <asp:TextBox ID="TB_contraseña" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" TextMode="Password"></asp:TextBox>
&nbsp;<asp:RequiredFieldValidator ID="RFV_contraseña" runat="server" ControlToValidate="TB_contraseña" ErrorMessage="*" ValidationGroup="registro"></asp:RequiredFieldValidator>
&nbsp;<asp:RegularExpressionValidator ID="REV_contraseña" runat="server" ControlToValidate="TB_contraseña" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_1-9]+"></asp:RegularExpressionValidator>
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style3" colspan="4">
                <asp:Literal ID="FT_User" runat="server" EnableViewState="False"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="auto-style3" colspan="2">
                <asp:Button ID="B_registrar" runat="server" OnClick="B_registrar_Click" Text="Registrar" ValidationGroup="registro" Width="157px" />
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
    </table>
</asp:Content>


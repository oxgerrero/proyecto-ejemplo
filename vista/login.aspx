<%@ Page Title="" Language="C#" MasterPageFile="~/vista/plantilla.master" AutoEventWireup="true" CodeFile="~/controlador/login.aspx.cs" Inherits="vista_login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
        .auto-style2 {
            width: 125px;
        }
        .auto-style3 {
            width: 243px;
        }
        .auto-style4 {
            width: 456px;
        }
        .auto-style5 {
            width: 456px;
            height: 31px;
        }
        .auto-style6 {
            height: 31px;
        }
        .auto-style7 {
            width: 456px;
            height: 47px;
        }
        .auto-style8 {
            width: 125px;
            height: 47px;
        }
        .auto-style9 {
            width: 243px;
            height: 47px;
        }
        .auto-style10 {
            height: 47px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table class="auto-style1">
        <tr>
            <td class="auto-style4">&nbsp;</td>
            <td class="auto-style2">&nbsp;</td>
            <td class="auto-style3">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style7"></td>
            <td class="auto-style8">Usuario</td>
            <td class="auto-style9">
                <asp:TextBox ID="TB_usuario" onkeypress="this.value=sololetras(this.value,2,30)" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_usuario" runat="server" ControlToValidate="TB_usuario" ErrorMessage="*" ValidationGroup="login"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="REV_usuario" runat="server" ControlToValidate="TB_usuario" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_0-9]+"></asp:RegularExpressionValidator>
            </td>
            <td class="auto-style10"></td>
        </tr>
        <tr>
            <td class="auto-style4">&nbsp;</td>
            <td class="auto-style2">Contraseña</td>
            <td class="auto-style3">
                <asp:TextBox ID="TB_contraseña" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_contraseña" runat="server" ControlToValidate="TB_contraseña" ErrorMessage="*" ValidationGroup="login"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="REV_contraseña" runat="server" ControlToValidate="TB_contraseña" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_0-9]+"></asp:RegularExpressionValidator>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style5"></td>
            <td class="auto-style6" colspan="2">
                <a href="recuperacion.aspx">olvido su contraseña</a>
            </td>
            <td class="auto-style6"></td>
        </tr>
        <tr>
            <td class="auto-style4">&nbsp;</td>
            <td class="auto-style2">
                <asp:Button ID="B_registrar" runat="server" Text="Registrarse" OnClick="B_registrar_Click" />
            </td>
            <td class="auto-style3">
                <asp:Button ID="B_login" runat="server" Text="Ingresar" ValidationGroup="login" OnClick="B_login_Click" />
            </td>
            <td>&nbsp;</td>
        </tr>
    </table>
</asp:Content>


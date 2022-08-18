<%@ Page Title="" Language="C#" MasterPageFile="~/vista/clientes.master" AutoEventWireup="true" CodeFile="~/controlador/PQRS.aspx.cs" Inherits="vista_PQRS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style6 {
            width: 235px;
        }
        .auto-style7 {
            width: 470px;
        }
        .auto-style8 {
            width: 241px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table class="auto-style2">
        <tr>
            <td class="auto-style6">&nbsp;</td>
            <td>&nbsp;</td>
            <td class="auto-style7">&nbsp;</td>
            <td class="auto-style8">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style6">&nbsp;</td>
            <td colspan="2" rowspan="2">&nbsp;Escriba la descripcion detallada de su PQRS<br />
&nbsp;
                <asp:TextBox ID="TB_pqrs" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" Height="157px" Width="403px"></asp:TextBox>
                <asp:RegularExpressionValidator ID="REV_pqrs" runat="server" ControlToValidate="TB_pqrs" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_0-9\s]+"></asp:RegularExpressionValidator>
                <br />
                <asp:Button ID="B_pqrs" runat="server" OnClick="B_pqrs_Click" Text="Enviar" />
            </td>
            <td class="auto-style8">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style6">&nbsp;</td>
            <td class="auto-style8">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style6">&nbsp;</td>
            <td>&nbsp;</td>
            <td class="auto-style7">&nbsp;</td>
            <td class="auto-style8">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style6">&nbsp;</td>
            <td>&nbsp;</td>
            <td class="auto-style7">&nbsp;</td>
            <td class="auto-style8">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
    </table>
</asp:Content>


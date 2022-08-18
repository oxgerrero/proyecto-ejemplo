<%@ Page Language="C#" AutoEventWireup="true" CodeFile="~/controlador/pago.aspx.cs" Inherits="vista_pago" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style type="text/css">
        body{
            cursor:url(http://localhost:58812/BD/imagen.png), auto;
            background-image: linear-gradient(to top, #30cfd0 0%, #330867 100%);
        }
        .auto-style7 {
            text-align: center;
            width: 84px;
        }
        .auto-style3 {
            text-align: center;
        }
        .auto-style1 {
            width: 100%;
        }
        .auto-style9 {
            width: 394px;
            text-align: center;
        }
        .auto-style11 {
            text-align: center;
            width: 327px;
        }
        .auto-style12 {
            text-align: center;
            width: 327px;
            height: 64px;
        }
        .auto-style13 {
            text-align: center;
            width: 84px;
            height: 64px;
        }
    </style>
</head>
<body>
    
    <form id="form1" runat="server">
        <div>
            <asp:Panel ID="Panel1" runat="server">
                <table class="auto-style1">
                    <tr>
                        <td class="auto-style11">ingrese su numero de cuenta</td>
                        <td class="auto-style7">
                            <asp:TextBox ID="TB_numeroCuenta" onkeypress="this.value=sololetras(this.value,5,30)" runat="server" TextMode="Number"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TB_numeroCuenta" ErrorMessage="*" ValidationGroup="banco"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style12">ingrese el banco al cual pertenece</td>
                        <td class="auto-style13">
                            <asp:TextBox ID="TB_banco" onkeypress="this.value=sololetras(this.value,2,30)" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TB_banco" ErrorMessage="*" ValidationGroup="banco"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="REV_banco" runat="server" ControlToValidate="TB_banco" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z]+"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style3" colspan="2">
                            <asp:Button ID="Button1" runat="server" Text="Continuar" OnClick="Button1_Click" ValidationGroup="banco" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
        <asp:Panel ID="Panel2" runat="server" Visible="False">
            <table class="auto-style1">
                <tr>
                    <td class="auto-style9">ingrese el codigo de verificacion</td>
                    <td class="auto-style7">
                        <asp:TextBox ID="TB_codigo" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" TextMode="Number"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="TB_codigo" ErrorMessage="*" ValidationGroup="codigo"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style9">&nbsp;</td>
                    <td class="auto-style7">&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style3" colspan="2">
                        <asp:Button ID="Button2" runat="server" Text="Confirmar" OnClick="Button2_Click" ValidationGroup="codigo" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </form>
</body>
</html>

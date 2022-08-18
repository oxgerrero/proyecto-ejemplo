<%@ Page Title="" Language="C#" MasterPageFile="~/vista/plantilla.master" AutoEventWireup="true" CodeFile="~/controlador/recuperacion.aspx.cs" Inherits="vista_recuperacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table class="auto-style1">
                <tr>
                    <td class="auto-style4">&nbsp;</td>
                    <td class="auto-style2">&nbsp;</td>
                    <td class="auto-style3">&nbsp;</td>
                    <td class="auto-style5">&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style4">&nbsp;</td>
                    <td class="auto-style2">&nbsp;</td>
                    <td class="auto-style3">user<asp:TextBox ID="TB_user" onkeypress="this.value=sololetras(this.value,2,30)" runat="server"></asp:TextBox>
                    &nbsp;<asp:RequiredFieldValidator ID="RFV_Rusuario" runat="server" ControlToValidate="TB_user" ErrorMessage="*" ValidationGroup="Rusuario"></asp:RequiredFieldValidator>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td class="auto-style5">&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style4">&nbsp;</td>
                    <td class="auto-style2">&nbsp;</td>
                    <td class="auto-style3">
                        <asp:Button ID="B_recuperar" runat="server" OnClick="B_recuperar_Click" Text="Recuperar" ValidationGroup="Rusuario" />
                    </td>
                    <td class="auto-style5">&nbsp;</td>
                    
                </tr>
                <tr>
                    <td class="auto-style4">&nbsp;</td>
                    <td class="auto-style2">&nbsp;</td>
                    <td class="auto-style3">&nbsp;</td>
                    <td class="auto-style5">&nbsp;</td>
                </tr>
            </table>
</asp:Content>


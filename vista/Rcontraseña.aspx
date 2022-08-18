<%@ Page Title="" Language="C#" MasterPageFile="~/vista/plantilla.master" AutoEventWireup="true" CodeFile="~/controlador/Rcontraseña.aspx.cs" Inherits="vista_Rcontraseña" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <table class="auto-style1">
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>Nueva contraseña<asp:TextBox ID="TB_Ncontraseña" onkeypress="this.value=sololetras(this.value,2,30)" runat="server"></asp:TextBox>
                &nbsp;<asp:RequiredFieldValidator ID="RFV_Rcontraseña" runat="server" ControlToValidate="TB_Ncontraseña" ErrorMessage="*" ValidationGroup="Rcontraseña"></asp:RequiredFieldValidator>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>
                </td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="B_confirmar" runat="server" OnClick="B_confirmar_Click" Text="Confirmar" ValidationGroup="Rcontraseña" />
                </td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
</asp:Content>


<%@ Page Title="" Language="C#" MasterPageFile="~/vista/clientes.master" AutoEventWireup="true" CodeFile="~/controlador/editar.aspx.cs" Inherits="vista_editar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style4 {
            text-align: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
            <table class="auto-style1">
                <tr>
                    <td>
                        <h2>
                            &nbsp;</h2>
                    </td>
                    <td class="auto-style3" colspan="3">
                        <h1>
                        <asp:Label ID="L_NombreProducto" runat="server"></asp:Label>
                        </h1>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <asp:Image ID="I_Producto3" runat="server" Width="50%" />
                        </td>
                    <td class="auto-style15">
                        <asp:Image ID="I_Producto1" runat="server" Width="50%" />
                    </td>
                    <td>
                        <asp:Image ID="I_Producto2" runat="server" Width="50%" />
                        </td>
                    <td colspan="2">
                        &nbsp;&nbsp;<br />
                        <br />
                        &nbsp;&nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;</td>
                    <td class="auto-style4" colspan="2">
                        Marca:<asp:TextBox ID="TB_editarMarca" onkeypress="this.value=sololetras(this.value,2,30)" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_editarMarca" runat="server" ControlToValidate="TB_editarMarca" ErrorMessage="*" ValidationGroup="Editar_Publicacion"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="REV_editarMarca" runat="server" ControlToValidate="TB_editarMarca" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z]+" ValidationGroup="Editar_Publicacion"></asp:RegularExpressionValidator>
                    </td>
                    <td colspan="2">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td rowspan="3">
                        &nbsp;</td>
                    <td class="auto-style4" colspan="2">
                        Talla:<asp:DropDownList ID="DDL_talla" runat="server" DataSourceID="ODS_talla" DataTextField="Descripcion" DataValueField="Descripcion" OnDataBound="DDL_talla_DataBound">
                        </asp:DropDownList>
                        <asp:ObjectDataSource ID="ODS_talla" runat="server" SelectMethod="ddl_talla" TypeName="bicicletas"></asp:ObjectDataSource>
                <asp:RequiredFieldValidator ID="RFV_editarTalla" runat="server" ControlToValidate="DDL_talla" ErrorMessage="*" ValidationGroup="Editar_Publicacion"></asp:RequiredFieldValidator>
                    </td>
                    <td colspan="2" rowspan="3">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style4" colspan="2">
                        Referencia:<asp:TextBox ID="TB_editarReferencia" onkeypress="this.value=sololetras(this.value,2,30)" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_editarReferencia" runat="server" ControlToValidate="TB_editarReferencia" ErrorMessage="*" ValidationGroup="Editar_Publicacion"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="REV_editarReferencia" runat="server" ControlToValidate="TB_editarReferencia" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_0-9]+" ValidationGroup="Editar_Publicacion"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4" colspan="2">
                        Tipo de bicicleta:<asp:DropDownList ID="DDL_Tbicla" runat="server" DataSourceID="ODS_ETipo" DataTextField="Descripcion" DataValueField="Descripcion" OnDataBound="DDL_Tbicla_DataBound">
                        </asp:DropDownList>
                        <asp:ObjectDataSource ID="ODS_ETipo" runat="server" SelectMethod="ddl_tipoBicicletas" TypeName="bicicletas"></asp:ObjectDataSource>
                <asp:RequiredFieldValidator ID="RFV_editarTBicla" runat="server" ControlToValidate="DDL_Tbicla" ErrorMessage="*" ValidationGroup="Editar_Publicacion"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td rowspan="2">
                        <asp:Button ID="B_Atras" runat="server" CssClass="auto-style13" OnClick="B_Atras_Click" Text="Atras" />
                    </td>
                    <td class="auto-style4" colspan="2">
                        Tipo de frenos:&nbsp;&nbsp;&nbsp;
                        <asp:DropDownList ID="DDL_frenos" runat="server" DataSourceID="ODS_frenos" DataTextField="Descripcion" DataValueField="Descripcion" OnDataBound="DDL_frenos_DataBound">
                        </asp:DropDownList>
                        <asp:ObjectDataSource ID="ODS_frenos" runat="server" SelectMethod="ddl_tipoFrenos" TypeName="bicicletas"></asp:ObjectDataSource>
                <asp:RequiredFieldValidator ID="RFV_editarFrenos" runat="server" ControlToValidate="DDL_frenos" ErrorMessage="*" ValidationGroup="Editar_Publicacion"></asp:RequiredFieldValidator>
                        </td>
                    <td colspan="2" rowspan="2">
                        <p>
                            &nbsp;</p>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4" colspan="2">
                            <span class="auto-style18">Numero de piñones:&nbsp;&nbsp; <asp:DropDownList ID="DDL_piniones" runat="server" DataSourceID="ODS_piniones" DataTextField="Descripcion" DataValueField="Descripcion" OnDataBound="DDL_piniones_DataBound">
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="ODS_piniones" runat="server" SelectMethod="ddl_tipoPiniones" TypeName="bicicletas"></asp:ObjectDataSource>
                <asp:RequiredFieldValidator ID="RFV_editarPiniones" runat="server" ControlToValidate="DDL_piniones" ErrorMessage="*" ValidationGroup="Editar_Publicacion"></asp:RequiredFieldValidator>
                            </span>
                    </td>
                </tr>
                <tr>
                    <td rowspan="5">
                        &nbsp;</td>
                    <td class="auto-style4" colspan="2">
                        Precio: $<asp:TextBox ID="TB_editarPrecio" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" TextMode="Number"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_editarPrecio" runat="server" ControlToValidate="TB_editarPrecio" ErrorMessage="*" ValidationGroup="Editar_Publicacion"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="REV_editarPrecio" runat="server" ControlToValidate="TB_editarPrecio" ErrorMessage="Caracteres invalidos" ValidationExpression="[0-9]+" ValidationGroup="Editar_Publicacion"></asp:RegularExpressionValidator>
                    </td>
                    <td colspan="2" rowspan="5">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style4" colspan="2">
                        Año :<asp:TextBox ID="TB_editarAnio" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" TextMode="Date" ></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_editarAnio" runat="server" ControlToValidate="TB_editarAnio" ErrorMessage="*" ValidationGroup="Editar_Publicacion"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4" colspan="2">
                        Fecha de revicion:<asp:TextBox ID="TB_editarFechaR"  runat="server" TextMode="Date"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_editarFrevicion" runat="server" ControlToValidate="TB_editarFechaR" ErrorMessage="*" ValidationGroup="Editar_Publicacion"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4" colspan="2">
                        Color:&nbsp;
                        <asp:TextBox ID="TB_editarColor" runat="server" ReadOnly="True" TextMode="Color" Enabled="False"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_editarColor" runat="server" ControlToValidate="TB_editarColor" ErrorMessage="*" ValidationGroup="Editar_Publicacion"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4" colspan="2">
                        Ciudad<asp:TextBox ID="TB_editarCiudad" onkeypress="this.value=sololetras(this.value,2,30)" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_editarCiudad" runat="server" ControlToValidate="TB_editarCiudad" ErrorMessage="*" ValidationGroup="Editar_Publicacion"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="REV_editarCiudad" runat="server" ControlToValidate="TB_editarCiudad" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z]+" ValidationGroup="Editar_Publicacion"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;</td>
                    <td class="auto-style4" colspan="2">
                        <asp:Button ID="B_guardar" runat="server" OnClick="B_guardar_Click" Text="Guardar" ValidationGroup="Editar_Publicacion" />
                    </td>
                    <td colspan="2">
                        &nbsp;</td>
                </tr>
            </table>
        </asp:Content>


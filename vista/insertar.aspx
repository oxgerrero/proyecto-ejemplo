<%@ Page EnableEventValidation="false" validateRequest="false" Title="" Language="C#" MasterPageFile="~/vista/clientes.master" AutoEventWireup="true" CodeFile="~/controlador/insertar.aspx.cs" Inherits="vista_insertar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
    <style type="text/css">
        .auto-style2 {
            width: 100%;
        }
        .auto-style3 {
            width: 100%;
            text-align: center;
        }
        .auto-style4 {
            width: 330px;
            text-align: center;
            height: 4px;
        }
        .auto-style5 {
            width: 330px;
            text-align: right;
        }
        .auto-style6 {
            width: 330px;
            text-align: right;
            height: 4px;
        }
        .auto-style7 {
            text-align: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table class="auto-style2">
        <tr>
            <td colspan="2">
                <h1 class="auto-style3">Ingreso de productos</h1>
            </td>
        </tr>
        <tr>
            <td class="auto-style7"><strong>*imagen 1:&nbsp;&nbsp;&nbsp;</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:FileUpload ID="FU_imagenes0" runat="server" onchange="showimagepreview(this)"/>
                <asp:RequiredFieldValidator ID="RFV_imagen0" runat="server" ControlToValidate="FU_imagenes0" ErrorMessage="*" ValidationGroup="producto"></asp:RequiredFieldValidator>
            </td>
            <td class="auto-style7">
                <img id="I_temp1" alt="" style="width:200px" />
            </td>
        </tr>
        <tr>
            <td class="auto-style3"><strong>*imagen 2:&nbsp;&nbsp;&nbsp;</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:FileUpload ID="FU_imagenes1" runat="server" onchange="showimagepreview(this)"/>
                <asp:RequiredFieldValidator ID="RFV_imagen1" runat="server" ControlToValidate="FU_imagenes1" ErrorMessage="*" ValidationGroup="producto"></asp:RequiredFieldValidator>
            </td>
            <td class="auto-style3">
                &nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style3"><strong>*imagen 3:&nbsp;&nbsp;&nbsp;</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:FileUpload ID="FU_imagenes2" runat="server" onchange="showimagepreview(this)"/>
                <asp:RequiredFieldValidator ID="RFV_imagen2" runat="server" ControlToValidate="FU_imagenes2" ErrorMessage="*" ValidationGroup="producto"></asp:RequiredFieldValidator>
            </td>
            <td class="auto-style3">
                &nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style5">Precio:&nbsp;&nbsp; &nbsp;</td>
            <td class="auto-style3">
            <asp:TextBox ID="TB_precio" onkeypress="this.value=sololetras(this.value,5,9)" runat="server" TextMode="Number" MaxLength="9"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RFV_precio" runat="server" ControlToValidate="TB_precio" ErrorMessage="*" ValidationGroup="producto"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="REV_marca0" runat="server" ControlToValidate="TB_precio" ErrorMessage="Caracteres invalidos" ValidationExpression="[0-9]+" ValidationGroup="producto"></asp:RegularExpressionValidator>
                    </td>
        </tr>
        <tr>
            <td class="auto-style6">Marca:</td>
            <td class="auto-style4">
            <asp:TextBox ID="TB_marca" onkeypress="this.value=sololetras(this.value,2,30)" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RFV_marca" runat="server" ControlToValidate="TB_marca" ErrorMessage="*" ValidationGroup="producto"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="REV_marca" runat="server" ControlToValidate="TB_marca" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z]+" ValidationGroup="producto"></asp:RegularExpressionValidator>
                    </td>
        </tr>
        <tr>
            <td class="auto-style5">Referencia:</td>
            <td class="auto-style3">
            <asp:TextBox ID="TB_referencia" onkeypress="this.value=sololetras(this.value,2,30)" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RFV_referencia" runat="server" ControlToValidate="TB_referencia" ErrorMessage="*" ValidationGroup="producto"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="REV_referencia" runat="server" ControlToValidate="TB_referencia" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z0_9]+" ValidationGroup="producto"></asp:RegularExpressionValidator>
                    </td>
        </tr>
        <tr>
            <td class="auto-style5">Año:</td>
            <td class="auto-style3">
            <asp:TextBox ID="TB_anio" runat="server" TextMode="Date"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RFV_anio" runat="server" ControlToValidate="TB_anio" ErrorMessage="*" ValidationGroup="producto"></asp:RequiredFieldValidator>
                    </td>
        </tr>
        <tr>
            <td class="auto-style5">Talla:</td>
            <td class="auto-style3">
                <asp:DropDownList ID="DDL_talla" runat="server" DataSourceID="ODS_Talla" DataTextField="Descripcion" DataValueField="Descripcion">
                </asp:DropDownList>
                <asp:ObjectDataSource ID="ODS_Talla" runat="server" SelectMethod="talla" TypeName="bicicletas"></asp:ObjectDataSource>
            <asp:RequiredFieldValidator ID="RFV_talla" runat="server" ControlToValidate="DDL_talla" ErrorMessage="*" ValidationGroup="producto"></asp:RequiredFieldValidator>
                    </td>
        </tr>
        <tr>
            <td class="auto-style5">Tipo:</td>
            <td class="auto-style3">
                <asp:DropDownList ID="DDL_TBicla" runat="server" DataSourceID="ODS_TBicla" DataTextField="Descripcion" DataValueField="Descripcion">
                    <asp:ListItem Selected="True">seleccione</asp:ListItem>
                </asp:DropDownList>
                <asp:ObjectDataSource ID="ODS_TBicla" runat="server" SelectMethod="tipoBicicletas" TypeName="bicicletas"></asp:ObjectDataSource>
            <asp:RequiredFieldValidator ID="RFV_TBicla" runat="server" ControlToValidate="DDL_TBicla" ErrorMessage="*" ValidationGroup="producto"></asp:RequiredFieldValidator>
                    </td>
        </tr>
        <tr>
            <td class="auto-style5">Frenos:</td>
            <td class="auto-style3">
                <asp:DropDownList ID="DDL_TFrenos" runat="server" DataSourceID="ODS_TFrenos" DataTextField="Descripcion" DataValueField="Descripcion">
                </asp:DropDownList>
                <asp:ObjectDataSource ID="ODS_TFrenos" runat="server" SelectMethod="tipoFrenos" TypeName="bicicletas"></asp:ObjectDataSource>
            <asp:RequiredFieldValidator ID="RFV_frenos" runat="server" ControlToValidate="DDL_TFrenos" ErrorMessage="*" ValidationGroup="producto"></asp:RequiredFieldValidator>
                    </td>
        </tr>
        <tr>
            <td class="auto-style5">Piñones</td>
            <td class="auto-style3">
                <asp:DropDownList ID="DDL_piniones" runat="server" DataSourceID="ODS_piniones" DataTextField="Descripcion" DataValueField="Descripcion">
                </asp:DropDownList>
                <asp:ObjectDataSource ID="ODS_piniones" runat="server" SelectMethod="tipoPiniones" TypeName="bicicletas"></asp:ObjectDataSource>
            <asp:RequiredFieldValidator ID="RFV_pinon" runat="server" ControlToValidate="DDL_piniones" ErrorMessage="*" ValidationGroup="producto"></asp:RequiredFieldValidator>
                    </td>
        </tr>
        <tr>
            <td class="auto-style5">Color:</td>
            <td class="auto-style3">
            <asp:TextBox ID="TB_color" runat="server" TextMode="Color"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RFV_color" runat="server" ControlToValidate="TB_color" ErrorMessage="*" ValidationGroup="producto"></asp:RequiredFieldValidator>
                    </td>
        </tr>
        <tr>
            <td class="auto-style5">Fecha de revicion:</td>
            <td class="auto-style3">
            <asp:TextBox ID="TB_fechaRevicion" runat="server" TextMode="Date"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RFV_fechaRevicion" runat="server" ControlToValidate="TB_fechaRevicion" ErrorMessage="*" ValidationGroup="producto"></asp:RequiredFieldValidator>
                    </td>
        </tr>
        <tr>
            <td class="auto-style5">Ciudad:</td>
            <td class="auto-style3">
            <asp:TextBox ID="TB_ciudad" onkeypress="this.value=sololetras(this.value,2,30)" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RFV_ciudad" runat="server" ControlToValidate="TB_ciudad" ErrorMessage="*" ValidationGroup="producto"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="REV_ciudad" runat="server" ControlToValidate="TB_ciudad" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z]+" ValidationGroup="producto"></asp:RegularExpressionValidator>
                    </td>
        </tr>
        <tr>
            <td class="auto-style3" colspan="2">
            <asp:Button ID="B_guardar" runat="server" OnClick="B_guardar_Click" Text="Guardar" ValidationGroup="producto" />
                    </td>
        </tr>
        <tr>
             <td class="auto-style2" colspan="2">
                        <asp:Button ID="B_Atras" runat="server" OnClick="B_Atras_Click" Text="Atras" />
                    </td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
    </table>
    <script type="text/javascript">
        function showimagepreview(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    document.getElementsByTagName("img")[0].setAttribute("src", e.target.result);
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</asp:Content>

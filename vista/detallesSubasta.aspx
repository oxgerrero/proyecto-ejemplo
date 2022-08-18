<%@ Page Title="" Language="C#" MasterPageFile="~/vista/clientes.master" AutoEventWireup="true" CodeFile="~/controlador/detallesSubasta.aspx.cs" Inherits="vista_detallesSubasta" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style4 {
            width: 588px;
        }
        .auto-style6 {
            width: 925px;
            height: 110px;
            text-align: center;
        }
        .auto-style7 {
            height: 110px;
        }
        .auto-style9 {
            width: 925px;
        }
        .auto-style10 {
            text-align: center;
        }
        .auto-style11 {
            height: 110px;
            text-align: center;
        }
        .auto-style13 {
            height: 110px;
            width: 125px;
        }
        .auto-style14 {
            text-align: left;
        }
        .auto-style15 {
            width: 899px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
            <table class="auto-style1">
                <tr>
                    <td class="auto-style4" colspan="2">
                        <h2>
                            &nbsp;</h2>
                    </td>
                    <td class="auto-style3" colspan="2">
                        <h1>
                        <asp:Label ID="L_NombreProducto" runat="server"></asp:Label>
                        </h1>
                    </td>
                    <td class="auto-style7">&nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style15" rowspan="3">
                        <div class="auto-style14">
                            <strong>Listado de Ofertas<br />
                            </strong>
                        </div>
                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="ODS_historicoSubasta" CellPadding="4" ForeColor="#333333" GridLines="None">
                            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                            <Columns>
                                <asp:BoundField DataField="NombreComprador" HeaderText="NombreComprador" SortExpression="NombreComprador" />
                                <asp:BoundField DataField="Valor" HeaderText="Valor" SortExpression="Valor" />
                            </Columns>
                            <EditRowStyle BackColor="#999999" />
                            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                            <SortedAscendingCellStyle BackColor="#E9E7E2" />
                            <SortedAscendingHeaderStyle BackColor="#506C8C" />
                            <SortedDescendingCellStyle BackColor="#FFFDF8" />
                            <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                        </asp:GridView>
                        <asp:ObjectDataSource ID="ODS_historicoSubasta" runat="server" SelectMethod="OB_datos_historico" TypeName="catalogo">
                            <SelectParameters>
                                <asp:SessionParameter Name="id" SessionField="idSubasta" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                    <td class="auto-style6">
                        <asp:Image ID="I_Producto1" runat="server" Width="84%" />
                    </td>
                    <td class="auto-style11">
                        <asp:Image ID="I_Producto2" runat="server" Width="66%" />
                    </td>
                    <td colspan="2" class="auto-style10">
                        &nbsp;&nbsp;<br />
                        <br />
                        <asp:Image ID="I_Producto3" runat="server" Width="131%" />
                        &nbsp;&nbsp;
                    </td>
                </tr>
                <tr>
                    <td class="auto-style9">
                        <asp:TextBox ID="TB_oferta" onkeypress="this.value=sololetras(this.value,5,11)" runat="server" TextMode="Number"></asp:TextBox>
                        <asp:Button ID="B_pujar" runat="server" OnClick="B_comprar_Click" Text="Ofertar" />
                    </td>
                    <td>Precio: $<asp:Label ID="L_PrecioU" runat="server"></asp:Label>
                        <br />
                    </td>
                    <td colspan="2">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="auto-style9">
                        &nbsp;</td>
                    <td class="auto-style7">
                        Marca:&nbsp;&nbsp;&nbsp;
                        <asp:Label ID="Label1" runat="server"></asp:Label>
                    </td>
                    <td colspan="2">
                        Referencia:&nbsp;
                        <asp:Label ID="Label2" runat="server" CssClass="auto-style17"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4" colspan="2">
                        &nbsp;</td>
                    <td class="auto-style7">
                        Talla:&nbsp;&nbsp;&nbsp;
                        <asp:Label ID="Label3" runat="server"></asp:Label>
                    </td>
                    <td colspan="2">
                        Tipo de bicicleta:&nbsp;
                        <asp:Label ID="Label4" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4" colspan="2">
                        &nbsp;</td>
                    <td class="auto-style7">
                        Tipo de frenos:&nbsp;&nbsp;&nbsp;
                        <asp:Label ID="Label5" runat="server"></asp:Label>
                    </td>
                    <td colspan="2">
                        <p>
                            <span class="auto-style18">Numero de piñones:&nbsp;&nbsp; </span>
                            <asp:Label ID="Label6" runat="server" CssClass="auto-style17"></asp:Label>
                        </p>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4" colspan="2">
                        <asp:Button ID="B_Atras" runat="server" CssClass="auto-style13" OnClick="B_Atras_Click" Text="Atras" />
                    </td>
                    <td class="auto-style7">
                        &nbsp;</td>
                    <td colspan="2">
                        Color:&nbsp;
                        <asp:TextBox ID="TB_color" runat="server" ReadOnly="True" TextMode="Color" Enabled="False"></asp:TextBox>
                    </td>
                </tr>
            </table>
        </asp:Content>


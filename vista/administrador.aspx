<%@ Page Title="" Language="C#" MasterPageFile="~/vista/clientes.master" AutoEventWireup="true" CodeFile="~/controlador/administrador.aspx.cs" Inherits="vista_administrador" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style4 {
            width: 405px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    &nbsp;Usuarios&nbsp;&nbsp;
    <br />
    <asp:GridView ID="GV_usuarios" runat="server" AutoGenerateColumns="False" DataSourceID="ODS_usuarios_admin" DataKeyNames="Id,Id_rol" OnRowDataBound="GV_usuarios_RowDataBound" CellPadding="4" ForeColor="#333333" GridLines="None">
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
    <Columns>
        <asp:TemplateField HeaderText="Id" SortExpression="Id">
            <EditItemTemplate>
                <asp:Label ID="L_id" runat="server" Text='<%# Bind("Id") %>'></asp:Label>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label2" runat="server" Text='<%# Bind("Id") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Nombre" SortExpression="Nombre">
            <EditItemTemplate>
                <asp:Label ID="L_nombre" runat="server" Text='<%# Bind("Nombre") %>'></asp:Label>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label3" runat="server" Text='<%# Bind("Nombre") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Apellido" SortExpression="Apellido">
            <EditItemTemplate>
                <asp:Label ID="L_apellido" runat="server" Text='<%# Bind("Apellido") %>'></asp:Label>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label4" runat="server" Text='<%# Bind("Apellido") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Email" SortExpression="Email">
            <EditItemTemplate>
                <asp:Label ID="L_email" runat="server" Text='<%# Bind("Email") %>'></asp:Label>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label5" runat="server" Text='<%# Bind("Email") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Telefono" SortExpression="Telefono">
            <EditItemTemplate>
                <asp:Label ID="L_telefono" runat="server" Text='<%# Bind("Telefono") %>'></asp:Label>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label6" runat="server" Text='<%# Bind("Telefono") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Usuario" SortExpression="Usuario">
            <EditItemTemplate>
                <asp:Label ID="L_usuario" runat="server" Text='<%# Bind("Usuario") %>'></asp:Label>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label7" runat="server" Text='<%# Bind("Usuario") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Contraseña" SortExpression="Contraseña">
            <EditItemTemplate>
                <asp:Label ID="L_contraseña" runat="server" Text='<%# Bind("Contraseña") %>'></asp:Label>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label8" runat="server" Text='<%# Bind("Contraseña") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Activo" SortExpression="Activo">
            <EditItemTemplate>
                <asp:DropDownList ID="DropDownList1" runat="server" SelectedIndex='<%# Bind("Activo") %>'>
                    <asp:ListItem Selected="True" Value="0">inactivo</asp:ListItem>
                    <asp:ListItem Value="1">activo</asp:ListItem>
                </asp:DropDownList>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label1" runat="server" Text='<%# Bind("Activo") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Validado" SortExpression="Validado">
            <EditItemTemplate>
                <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Validado") %>' />
            </EditItemTemplate>
            <ItemTemplate>
                <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Validado") %>' Enabled="false" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField ShowHeader="False">
            <EditItemTemplate>
                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Actualizar"></asp:LinkButton>
                &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancelar"></asp:LinkButton>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:LinkButton ID="LB_Editar" runat="server" CausesValidation="False" CommandName="Edit" Text="Editar"></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
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
<asp:ObjectDataSource ID="ODS_usuarios_admin" runat="server" SelectMethod="datos_usuarios" TypeName="usuarios" DataObjectTypeName="Eusuarios" UpdateMethod="Ac_User"></asp:ObjectDataSource>
    <br />
    Publicaciones<br />
    <asp:GridView ID="GV_publicaciones" runat="server" AutoGenerateColumns="False" DataKeyNames="Id,Imagen1,Imagen2,Imagen3,Session,Modified_by,Color,IdVendedor,IdComprador,Correo" DataSourceID="ODS_publicaciones" OnRowDataBound="GV_publicaciones_RowDataBound" OnRowUpdating="GV_publicaciones_RowUpdating" CellPadding="4" ForeColor="#333333" GridLines="None">
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        <Columns>
            <asp:TemplateField HeaderText="Id" SortExpression="Id">
                <EditItemTemplate>
                    <asp:Label ID="L_id" runat="server" Text='<%# Bind("Id") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("Id") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Precio" SortExpression="Precio">
                <EditItemTemplate>
                    <asp:Label ID="L_precio" runat="server" Text='<%# Bind("Precio") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Precio") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="TipoBicicleta" SortExpression="TipoBicicleta">
                <EditItemTemplate>
                    <asp:Label ID="L_tipoBicla" runat="server" Text='<%# Bind("TipoBicicleta") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("TipoBicicleta") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Talla" SortExpression="Talla">
                <EditItemTemplate>
                    <asp:Label ID="L_talla" runat="server" Text='<%# Bind("Talla") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label5" runat="server" Text='<%# Bind("Talla") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="N_piñones" SortExpression="N_piñones">
                <EditItemTemplate>
                    <asp:Label ID="L_piniones" runat="server" Text='<%# Bind("N_piñones") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label6" runat="server" Text='<%# Bind("N_piñones") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Referencia" SortExpression="Referencia">
                <EditItemTemplate>
                    <asp:Label ID="L_referencia" runat="server" Text='<%# Bind("Referencia") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label7" runat="server" Text='<%# Bind("Referencia") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Marca" SortExpression="Marca">
                <EditItemTemplate>
                    <asp:Label ID="L_marca" runat="server" Text='<%# Bind("Marca") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label8" runat="server" Text='<%# Bind("Marca") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Anio" SortExpression="Anio">
                <EditItemTemplate>
                    <asp:Label ID="L_anio" runat="server" Text='<%# Bind("Anio", "{0:d}") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label9" runat="server" Text='<%# Bind("Anio", "{0:d}") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="TipoFrenos" SortExpression="TipoFrenos">
                <EditItemTemplate>
                    <asp:Label ID="L_tipoFrenos" runat="server" Text='<%# Bind("TipoFrenos") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label10" runat="server" Text='<%# Bind("TipoFrenos") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="FechaRevicion" SortExpression="FechaRevicion">
                <EditItemTemplate>
                    <asp:Label ID="L_fechaRevicion" runat="server" Text='<%# Bind("FechaRevicion", "{0:d}") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label11" runat="server" Text='<%# Bind("FechaRevicion", "{0:d}") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Ciudad" SortExpression="Ciudad">
                <EditItemTemplate>
                    <asp:Label ID="L_ciudad" runat="server" Text='<%# Bind("Ciudad") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label13" runat="server" Text='<%# Bind("Ciudad") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Estado" SortExpression="Estado">
                <EditItemTemplate>
                    <asp:DropDownList ID="DropDownList2" runat="server" SelectedIndex='<%# Bind("Estado") %>'>
                        <asp:ListItem Selected="True" Value="0">inactivo</asp:ListItem>
                        <asp:ListItem Value="1">activo</asp:ListItem>
                        <asp:ListItem Value="3">subasta</asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Estado") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ShowHeader="False">
                <EditItemTemplate>
                    <asp:LinkButton ID="LB_Editar" runat="server" CausesValidation="True" CommandName="Update" Text="Actualizar"></asp:LinkButton>
                    &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancelar"></asp:LinkButton>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:LinkButton ID="LB_editarl" runat="server" CausesValidation="False" CommandName="Edit" Text="Editar"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
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
    <asp:ObjectDataSource ID="ODS_publicaciones" runat="server" DataObjectTypeName="Ecatalogo" SelectMethod="Ob_datos_activos" TypeName="catalogo" UpdateMethod="Ac_publicacion"></asp:ObjectDataSource>
    <br />
    <br />
    <table class="auto-style2">
        <tr>
            <td class="auto-style4">Tipo de Bicicletas<asp:GridView ID="GV_tipoBiclas" runat="server" AutoGenerateColumns="False" DataSourceID="ODS_Bike" DataKeyNames="Id" CellPadding="4" ForeColor="#333333" GridLines="None">
                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                <Columns>
                    <asp:TemplateField HeaderText="Descripcion" SortExpression="Descripcion">
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox1" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" Text='<%# Bind("Descripcion") %>'></asp:TextBox>
                            &nbsp;<asp:RequiredFieldValidator ID="RFV_tbiclax" runat="server" ControlToValidate="TextBox1" ErrorMessage="*" ValidationGroup="tbiclax"></asp:RequiredFieldValidator>
                            &nbsp;<asp:RegularExpressionValidator ID="REV_Tbiclac" runat="server" ControlToValidate="TextBox1" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_0-9\s]+" ValidationGroup="tbiclax"></asp:RegularExpressionValidator>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("Descripcion") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="False">
                        <EditItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Actualizar" ValidationGroup="tbiclax"></asp:LinkButton>
                            &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancelar"></asp:LinkButton>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Edit" Text="Editar"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
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
                <asp:ObjectDataSource ID="ODS_Bike" runat="server" SelectMethod="OB_tiposB" TypeName="catalogo" DataObjectTypeName="ETbicicletas" UpdateMethod="Ac_tipoBiclas"></asp:ObjectDataSource>
            </td>
            <td aria-autocomplete="none" aria-checked="undefined">Registrar nuevo Tipo de Bicicleta<br />
                <asp:TextBox ID="TB_tipoB" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" ValidationGroup="tipoBicla"></asp:TextBox>
                <asp:RegularExpressionValidator ID="REV_Tbicla" runat="server" ControlToValidate="TB_tipoB" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_0-9\s]+" ValidationGroup="tipoBicla"></asp:RegularExpressionValidator>
                <asp:Button ID="B_tipoBicla" runat="server" OnClick="B_tipoBicla_Click" Text="Guardar" ValidationGroup="tipoBicla" />
            </td>
        </tr>
        <tr>
            <td class="auto-style4">Tipos de Piñones<asp:GridView ID="GV_piniones" runat="server" AutoGenerateColumns="False" DataSourceID="ODS_piniones" DataKeyNames="Id" CellPadding="4" ForeColor="#333333" GridLines="None">
                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                <Columns>
                    <asp:TemplateField HeaderText="Descripcion" SortExpression="Descripcion">
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox1" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" Text='<%# Bind("Descripcion") %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RFV_pinionex" runat="server" ErrorMessage="*" ValidationGroup="pinionx"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="REV_Tpinionesc" runat="server" ControlToValidate="TextBox1" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_0-9\s]+" ValidationGroup="pinionx"></asp:RegularExpressionValidator>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("Descripcion") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="False">
                        <EditItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Actualizar" ValidationGroup="pinionx"></asp:LinkButton>
                            &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancelar"></asp:LinkButton>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Edit" Text="Editar"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
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
                <asp:ObjectDataSource ID="ODS_piniones" runat="server" SelectMethod="OB_TiposPiniones" TypeName="catalogo" DataObjectTypeName="Epiniones" UpdateMethod="Ac_tipoPiniones"></asp:ObjectDataSource>
            </td>
            <td>Registrar nuevo Tipo de Piñones<br />
                <asp:TextBox ID="TB_tipoPinion" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" ValidationGroup="tipoPinion"></asp:TextBox>
                <asp:RegularExpressionValidator ID="REV_Tpiniones" runat="server" ControlToValidate="TB_tipoPinion" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_0-9\s]+" ValidationGroup="tipoPinion"></asp:RegularExpressionValidator>
                <asp:Button ID="B_tipoPinion" runat="server" OnClick="B_tipoPinion_Click" Text="Guardar" ValidationGroup="tipoPinion" />
            </td>
        </tr>
        <tr>
            <td class="auto-style4">Tipo de Frenos<asp:GridView ID="GV_frenos" runat="server" AutoGenerateColumns="False" datasourceid="ODS_frenos" DataKeyNames="Id" CellPadding="4" ForeColor="#333333" GridLines="None">
                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                <Columns>
                    <asp:TemplateField HeaderText="Descripcion" SortExpression="Descripcion">
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox1" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" Text='<%# Bind("Descripcion") %>'></asp:TextBox>
                            <asp:RegularExpressionValidator ID="REV_frenos" runat="server" ControlToValidate="TextBox1" ErrorMessage="*" ValidationGroup="frenosx"></asp:RegularExpressionValidator>
                            <asp:RegularExpressionValidator ID="REV_Tfrenosc" runat="server" ControlToValidate="TextBox1" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_0-9\s]+" ValidationGroup="frenosx"></asp:RegularExpressionValidator>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("Descripcion") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="False">
                        <EditItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Actualizar" ValidationGroup="frenosx"></asp:LinkButton>
                            &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancelar"></asp:LinkButton>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Edit" Text="Editar"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
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
                <asp:ObjectDataSource ID="ODS_frenos" runat="server" SelectMethod="OB_tiposF" TypeName="catalogo" DataObjectTypeName="Efrenos" UpdateMethod="Ac_tipofrenos"></asp:ObjectDataSource>
            </td>
            <td>Registrar nuevo Tipo de Frenos<br />
                <asp:TextBox ID="TB_tipoFrenos" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" ValidationGroup="tipoFrenos"></asp:TextBox>
                <asp:RegularExpressionValidator ID="REV_Tfrenos" runat="server" ControlToValidate="TB_tipoFrenos" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_0-9\s]+" ValidationGroup="tipoFrenos"></asp:RegularExpressionValidator>
                <asp:Button ID="B_tipoFrenos" runat="server" OnClick="B_tipoFrenos_Click" Text="Guardar" ValidationGroup="tipoFrenos" />
            </td>
        </tr>
        <tr>
            <td class="auto-style4">Tallas<asp:GridView ID="GV_tallas" runat="server" AutoGenerateColumns="False" datasourceid="ODS_tallas" CellPadding="4" ForeColor="#333333" GridLines="None">
                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                <Columns>
                    <asp:TemplateField HeaderText="Descripcion" SortExpression="Descripcion">
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox1" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" Text='<%# Bind("Descripcion") %>'></asp:TextBox>
                            <asp:RegularExpressionValidator ID="REV_tallas" runat="server" ControlToValidate="TextBox1" ErrorMessage="*" ValidationGroup="tallasx"></asp:RegularExpressionValidator>
                            <asp:RegularExpressionValidator ID="REV_Tallasc" runat="server" ControlToValidate="TextBox1" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_0-9\s]+" ValidationGroup="tallasx"></asp:RegularExpressionValidator>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("Descripcion") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="False">
                        <EditItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Actualizar" ValidationGroup="tallasx"></asp:LinkButton>
                            &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancelar"></asp:LinkButton>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Edit" Text="Editar"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
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
                <asp:ObjectDataSource ID="ODS_tallas" runat="server" SelectMethod="OB_TallasB" TypeName="catalogo" DataObjectTypeName="Etalla" UpdateMethod="Ac_tallas"></asp:ObjectDataSource>
            </td>
            <td>Registrar nuevo Tallas de marcos<br />
                <asp:TextBox ID="TB_tallas" onkeypress="this.value=sololetras(this.value,2,30)" runat="server" ValidationGroup="tallas"></asp:TextBox>
                <asp:RegularExpressionValidator ID="REV_Tallas" runat="server" ControlToValidate="TB_tallas" ErrorMessage="Caracteres invalidos" ValidationExpression="[a-zA-Z_0-9\s]+" ValidationGroup="tallas"></asp:RegularExpressionValidator>
                <asp:Button ID="B_tallas" runat="server" OnClick="B_tallas_Click" Text="Guardar" ValidationGroup="tallas" />
            </td>
        </tr>
    </table>
    <br />
    <br />
    <br />
    <br />
    <br />
</asp:Content>


<%@ Page Title="" Language="C#" MasterPageFile="~/vista/clientes.master" AutoEventWireup="true" CodeFile="~/controlador/desarrollador.aspx.cs" Inherits="vista_administrador" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="ODS_usuarios_admin" DataKeyNames="Id,Session">
    <Columns>
        <asp:TemplateField HeaderText="Nombre" SortExpression="Nombre">
            <EditItemTemplate>
                <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Nombre") %>' Width="110px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_nombre" runat="server" ControlToValidate="TextBox1" ErrorMessage="*" ValidationGroup="editar"></asp:RequiredFieldValidator>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label1" runat="server" Text='<%# Bind("Nombre") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Apellido" SortExpression="Apellido">
            <EditItemTemplate>
                <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Apellido") %>' Width="110px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_apellido" runat="server" ControlToValidate="TextBox2" ErrorMessage="*" ValidationGroup="editar"></asp:RequiredFieldValidator>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label2" runat="server" Text='<%# Bind("Apellido") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Email" SortExpression="Email">
            <EditItemTemplate>
                <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("Email") %>' TextMode="Email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_email" runat="server" ControlToValidate="TextBox3" ErrorMessage="*" ValidationGroup="editar"></asp:RequiredFieldValidator>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label3" runat="server" Text='<%# Bind("Email") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Telefono" SortExpression="Telefono">
            <EditItemTemplate>
                <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("Telefono") %>' TextMode="Number" Width="134px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_telefono" runat="server" ControlToValidate="TextBox4" ErrorMessage="*" ValidationGroup="editar"></asp:RequiredFieldValidator>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label4" runat="server" Text='<%# Bind("Telefono") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Usuario" SortExpression="Usuario">
            <EditItemTemplate>
                <asp:TextBox ID="TextBox5" runat="server" Text='<%# Bind("Usuario") %>' Width="156px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_user" runat="server" ControlToValidate="TextBox5" ErrorMessage="*" ValidationGroup="editar"></asp:RequiredFieldValidator>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label5" runat="server" Text='<%# Bind("Usuario") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Contraseña" SortExpression="Contraseña">
            <EditItemTemplate>
                <asp:TextBox ID="TextBox6" runat="server" Text='<%# Bind("Contraseña") %>' Width="130px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_pass" runat="server" ControlToValidate="TextBox6" ErrorMessage="*" ValidationGroup="editar"></asp:RequiredFieldValidator>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label6" runat="server" Text='<%# Bind("Contraseña") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Id_rol" SortExpression="Id_rol">
            <EditItemTemplate>
                <asp:TextBox ID="TextBox7" runat="server" Text='<%# Bind("Id_rol") %>' Width="26px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_idrol" runat="server" ControlToValidate="TextBox7" ErrorMessage="*" ValidationGroup="editar"></asp:RequiredFieldValidator>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label7" runat="server" Text='<%# Bind("Id_rol") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Activo" SortExpression="Activo">
            <EditItemTemplate>
                <asp:TextBox ID="TextBox8" runat="server" Text='<%# Bind("Activo") %>' Width="23px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_activo" runat="server" ControlToValidate="TextBox1" ErrorMessage="*" ValidationGroup="editar"></asp:RequiredFieldValidator>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label8" runat="server" Text='<%# Bind("Activo") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField ShowHeader="False">
            <EditItemTemplate>
                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Actualizar" ValidationGroup="editar"></asp:LinkButton>
                &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancelar"></asp:LinkButton>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Edit" Text="Editar"></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
<asp:ObjectDataSource ID="ODS_usuarios_admin" runat="server" SelectMethod="datos_usuarios" TypeName="usuarios" DataObjectTypeName="Eusuarios" UpdateMethod="Ac_User"></asp:ObjectDataSource>
    <br />
    <asp:Button ID="Button4" runat="server" OnClick="Button4_Click" Text="hilos" />
</asp:Content>


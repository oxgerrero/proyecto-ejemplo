<%@ Page Language="C#" AutoEventWireup="true" CodeFile="~/controlador/tarjeta.aspx.cs" Inherits="vista_tarjeta" %>

<%@ Register assembly="CrystalDecisions.Web, Version=13.0.4000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" namespace="CrystalDecisions.Web" tagprefix="CR" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style>
        body{
            cursor:url(http://localhost:58812/BD/imagen.png), auto;
            background-image: linear-gradient(to top, #30cfd0 0%, #330867 100%);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <CR:CrystalReportViewer ID="CrystalReportViewer1" runat="server" AutoDataBind="True" GroupTreeImagesFolderUrl="" Height="1202px" ReportSourceID="CRS_TarjetaPropiedad" ToolbarImagesFolderUrl="" ToolPanelWidth="200px" Width="1104px" DisplayToolbar="False" EnableDatabaseLogonPrompt="False" EnableParameterPrompt="False" />
        <CR:CrystalReportSource ID="CRS_TarjetaPropiedad" runat="server">
            <Report FileName="E:\bicicletas\reportes\tarjeta.rpt">
            </Report>
        </CR:CrystalReportSource>
        <div>
            <CR:CrystalReportViewer ID="CrystalReportViewer2" runat="server" AutoDataBind="True" DisplayToolbar="False" EnableDatabaseLogonPrompt="False" EnableParameterPrompt="False" GroupTreeImagesFolderUrl="" Height="1170px" ReportSourceID="CRS_factura" ToolbarImagesFolderUrl="" ToolPanelWidth="200px" Width="1104px" />
            <CR:CrystalReportSource ID="CRS_factura" runat="server">
                <Report FileName="E:\bicicletas\reportes\factura.rpt">
                </Report>
            </CR:CrystalReportSource>
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Regresar" />
        </div>
    </form>
</body>
</html>

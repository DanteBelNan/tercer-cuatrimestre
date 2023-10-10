<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ejemplo1._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <%if (user != "")
        {

    %>
    <h2>Ingresaste!</h2>
    <asp:Label ID="lblUser" runat="server" Text=" "></asp:Label>
    <%}
        else
        { %>
    <h2>Debes logearte</h2>
    <a href="testAspx.aspx">Login</a>
    <%} %>
</asp:Content>

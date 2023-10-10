<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="ejemplo1.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title">
        <div>
            <asp:TextBox ID="txbNombre" AutoPostBack="false" runat="server" OnTextChanged="txbNombre_TextChanged"></asp:TextBox>
            <br />
            <asp:TextBox ID="txbPassword" AutoPostBack="false" runat="server"></asp:TextBox>
            <asp:Button ID="btnAceptar" runat="server" Text="Saludar" OnClick="btnAceptar_Click1" />
        </div>
        <asp:Label ID="lblSaludo" runat="server" Text=" "></asp:Label>
        <br />
        <asp:Label ID="lblSecundario" runat="server" Text=" "></asp:Label>
    </main>
</asp:Content>

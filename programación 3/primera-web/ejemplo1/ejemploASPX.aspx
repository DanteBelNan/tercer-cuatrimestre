﻿<%@ Page Title="About" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="ejemplo1.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title">
        <p>Pagina vacia</p>
        <div>
            <asp:TextBox ID="txbNombre" runat="server"></asp:TextBox>
            <asp:Button ID="btnAceptar" runat="server" Text="Button" OnClick="btnAceptar_Click" />

        </div>
        <asp:Label ID="lblSaludo" runat="server" Text=" "></asp:Label>
    </main>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ejemploVacio.WebForm3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-2"></div>
        <div class="col">
        <div class="mb-3">
            <label for="exampleFormControlInput1" class="form-label">Email address</label>s
            <asp:TextBox ID="txbUser" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
        <div class="mb-3">
            <label for="exampleFormControlTextarea1" class="form-label">Password</label>
            <asp:TextBox ID="txbPassword" runat="server" type="password" CssClass="form-control"></asp:TextBox>
        </div>
            <asp:Button ID="btnLogin" runat="server" Text="Log In" cssClass="btn btn-primary" OnClick="btnLogin_Click"/>
        </div>
        <asp:Label ID="lblLogged" runat="server" Text="Sesion iniciada?"></asp:Label>
        <div class="col-2"></div>
    </div>
</asp:Content>

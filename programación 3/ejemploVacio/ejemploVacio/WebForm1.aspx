<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="ejemploVacio.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:GridView ID="dgvPokemones" runat="server" CssClass="table" AutoGenerateColumns="false" >
        <Columns>
            <asp:BoundField HeaderText="Name" DataField="Name" />
            <asp:BoundField HeaderText="Desc" DataField="Description" />
            <asp:BoundField HeaderText="Capturado el..." DataField="Captura" />
            <asp:CheckBoxField HeaderText="Es Shiny?" DataField="esShiny" />

        </Columns>
    </asp:GridView>
</asp:Content>

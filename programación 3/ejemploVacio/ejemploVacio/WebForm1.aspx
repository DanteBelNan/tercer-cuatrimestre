<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="ejemploVacio.WebForm1" EnableViewState="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col">
            <asp:GridView ID="dgvPokemones" runat="server" OnSelectedIndexChanged="dgvPokemones_SelectedIndexChanged"  CssClass="table" AutoGenerateColumns="false" >
                <Columns>
                    <asp:BoundField HeaderText="Name" DataField="Name" />
                    <asp:BoundField HeaderText="Desc" DataField="Description" />
                    <asp:BoundField HeaderText="Capturado el..." DataField="Captura" />
                    <asp:CheckBoxField HeaderText="Es Shiny?" DataField="esShiny" />
                    <asp:CommandField ShowSelectButton="true" SelectText="Seleccionar" HeaderText="Acción" />
                </Columns>
            </asp:GridView>
            <a href="PokemonForm.aspx">Crear pokemon</a>
        </div>
    </div>
</asp:Content>

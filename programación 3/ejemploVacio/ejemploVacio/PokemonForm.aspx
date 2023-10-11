<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true" CodeBehind="PokemonForm.aspx.cs" Inherits="ejemploVacio.PokemonForm"  EnableViewState="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-6">

            <div class="mb-3">
                <label for="" class="form-label">Id</label>
                <asp:TextBox runat="server" ID="txbId" CssClass="form-control" Text="1"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label for="" class="form-label">Nombre</label>
                <asp:TextBox runat="server" ID="txbNombre" CssClass="form-control" Text="2"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label for="" class="form-label">Descripcion</label>
                <asp:TextBox runat="server" TextMode="MultiLine" ID="txbDescripcion" CssClass="form-control" Text="test"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label for="" class="form-label">Tipo</label>
                <asp:DropDownList runat="server" ID="ddlTipo" CssClass="form-select"></asp:DropDownList>
            </div>

            <div class="mb-3">
                <label for="" class="form-label">Captura</label>
                <asp:TextBox runat="server" TextMode="Date" ID="txbCaptura" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label for="" class="form-label">Shiny</label>
                <asp:CheckBox runat="server" ID="chkbxShiny" CssClass="form-check-input"></asp:CheckBox>
            </div>

            <div class="mb-3">
                <asp:Button Text="Aceptar" ID="btnAceptar" runat="server" OnClick="btnAceptar_Click" CssClass="btn btn-primary" useSubmitBehavior="false"/>
                <a href="WebForm1.aspx">Cancelar</a>
            </div>
        </div>
    </div>
</asp:Content>

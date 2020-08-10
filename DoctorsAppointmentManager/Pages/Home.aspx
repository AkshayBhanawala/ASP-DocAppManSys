<%@ Page Language="C#" MasterPageFile="~/Pages/BeforeLogin_MasterPage.Master" AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="DoctorsAppointmentManager.Pages.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Home</title>
	<link href="<%=ResolveClientUrl("~/_Styles/Home_CSS.css")%>" rel="Stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div id="div_maincontainer" class="div_maincontainer">
		<div id="div_view_container" class="div_view_container">
			<a href="~/Login/Doctor" runat="server" id="A_view_1" class="div_view view1">
				<div class="div_content">
					<div class="div_img">
						<asp:Image ID="I_Login_Doctor" runat="server" ImageUrl="~/_Images/Doctor_Male.png" />
					</div>
					<asp:Label ID="L_Login_Doctor" runat="server" Text="Doctor Login"></asp:Label>
				</div>
				<div class="div_bg"></div>
			</a>
			<a href="~/Login/Patient" runat="server" id="A_view_2" class="div_view view2">
				<div class="div_content">
					<div class="div_img">
						<asp:Image ID="I_Login_Patient" runat="server" ImageUrl="~/_Images/Patient_Male.png" />
					</div>
					<asp:Label ID="L_Login_Patient" runat="server" Text="Patient Login"></asp:Label>
				</div>
				<div class="div_bg"></div>
			</a>
			<a href="~/Register/Patient" runat="server" id="A_view_3" class="div_view view3">
				<div class="div_content">
					<div class="div_img">
						<asp:Image ID="I_Register_Patient" runat="server" ImageUrl="~/_Images/Signup_Patient.png" />
					</div>
					<asp:Label ID="L_Register_Patient" runat="server" Text="Patient Registration"></asp:Label>
				</div>
				<div class="div_bg"></div>
			</a>
		</div>
	</div>
</asp:Content>

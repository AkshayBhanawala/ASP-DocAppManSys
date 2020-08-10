<%@ Page Language="C#" MasterPageFile="~/Pages/BeforeLogin_MasterPage.Master" AutoEventWireup="true" CodeFile="Registration.aspx.cs" Inherits="DoctorsAppointmentManager.Pages.Registration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Registration</title>
	<link href="<%=ResolveClientUrl("~/_Styles/Registration_CSS.css")%>" rel="Stylesheet" />
	<script src="<%=ResolveClientUrl("~/_Scripts/JS.js")%>" type="text/javascript"></script>
	<script>
		$(document).ready(function () {
			setTimeout(function () {
				$("#div_FormBodyContainer").addClass("huerotate");
			}, 1900);

		});

		function tryFormSubmit(e) {
			e.preventDefault(); // Stop Default Button Behaviour

			var AnimDuration = 500;

			var ClientButton = $("#" + e.srcElement.id);
			var ServerButton = $("#" + getClientID(ClientButton.attr('ServerButton')));

			var PageUrl = getPageUrl();
			var MethodUrl = '/' + ClientButton.attr('PostBackPath');
			var PostBackURL = PageUrl + MethodUrl;

			var DATA = '{' +
				'"UN": "' + $("#" + getClientID("TB_UN")).val() + '",' +
				'"PW": "' + $("#" + getClientID("TB_PW")).val() + '"' +
				'}';

			var OnAjaxSuccess = function (response) {
				if (response != null) {
					if (response.d || response.d == "true") {
						$('body').addClass('UnloadSplashScreen');
						setTimeout(function () {
							ServerButton.click();
						}, AnimDuration);
					}
				} else {
					console.log("Something went wrong while Ajax Success");
				}
			};
			/*
			var OnAjaxFailure = function (response) {
				if (response != null) {
					console.log("Failure Data: ");
					console.log(response);
				} else {
					console.log("Something went wrong while Ajax Failure");
				}
			};

			var OnAjaxComplete = function () {
				console.log("Ajax Call Complete");
			};
			*/
			performAjaxCall(PostBackURL, DATA, OnAjaxSuccess);
		}
	</script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div id="div_maincontainer" class="div_maincontainer">
		<form id="form1" runat="server">
			<div id="div_FormBodyContainer" class="div_FormBodyContainer">
				<div id="div_innercontainer" class="div_innercontainer">
					<div id="div_logocontainer" class="div_logocontainer">
						<a href="~" runat="server" class="div_logo"></a>
					</div>
					<div id="div_col1" class="div_col col1">
						<div class="div_container">
							<asp:Label ID="L_RegisterUserType" runat="server" Text="Registration"></asp:Label>
							<div class="div_imagecontainer">
								<asp:Image ID="I_RegisterUserType" runat="server" ImageUrl="~/_Images/Patient_Male.png" />
							</div>
						</div>
					</div>
					<div class="div_divider"></div>
					<div id="div_col2" class="div_col col2">
						<div class="div_container">
							<div id="div_login_form" class="div_login_form">
								<asp:TextBox ID="TB_FN" runat="server" CssClass="tb" placeholder="First Name" AutoCompleteType="Disabled"></asp:TextBox>
								<asp:TextBox ID="TB_LN" runat="server" CssClass="tb" placeholder="Last Name" AutoCompleteType="Disabled"></asp:TextBox>
								<asp:TextBox ID="TB_Age" runat="server" CssClass="tb" placeholder="Age" TextMode="Number" AutoCompleteType="Disabled"></asp:TextBox>
								<div class="div_gender">
									<asp:RadioButton ID="RB_Male" runat="server" GroupName="Gender" Text="Male" CssClass="radio" />
									<asp:RadioButton ID="RB_Female" runat="server" GroupName="Gender" Text="Female" CssClass="radio" />
									<asp:RadioButton ID="RB_Other" runat="server" GroupName="Gender" Text="Other" CssClass="radio" />
								</div>
								<asp:TextBox ID="TB_Mobile" runat="server" CssClass="tb" placeholder="Mobile Number" TextMode="Phone" AutoCompleteType="Disabled"></asp:TextBox>
								<asp:TextBox ID="RB_EMail" runat="server" CssClass="tb" placeholder="Email" TextMode="Email" AutoCompleteType="Disabled"></asp:TextBox>
								<asp:TextBox ID="TB_UN" runat="server" CssClass="tb" placeholder="Username" AutoCompleteType="Disabled"></asp:TextBox>
								<asp:TextBox ID="TB_PW" runat="server" CssClass="tb" placeholder="Password" TextMode="Password" AutoCompleteType="Disabled"></asp:TextBox>
								<button id="BTN_Register_Client" runat="server" postbackpath="isFormValid" serverbutton="BTN_Register" onclick="tryFormSubmit(event)" class="btn btn_green">Register</button>
								<asp:Button ID="BTN_Register" runat="server" CssClass="btn btn_green" Text="Login" TabIndex="3" OnClick="BTN_Register_Click" Style="display: none;" />
								<asp:Label ID="L_Error" runat="server" CssClass="span_error text_red" Text=""></asp:Label>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
</asp:Content>

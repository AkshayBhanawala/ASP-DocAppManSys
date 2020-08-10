<%@ Page Language="C#" MasterPageFile="~/Pages/BeforeLogin_MasterPage.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="DoctorsAppointmentManager.Pages.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Login</title>
	<link href="<%=ResolveClientUrl("~/_Styles/Login_CSS.css")%>" rel="Stylesheet" />
	<script>
		$(document).ready(function () {
			setTimeout(function () {
				$("#div_FormBodyContainer").addClass("huerotate");
			}, 1900);
			
		});

		function getClientID(asp_id) {
			return $('[id$=' + asp_id + ']').attr('id');
		}

		function getPageUrl() {
			var Protocol = '<%= Request.Url.Scheme %>' + "://";
			var HostPort = '<%= Request.Url.Authority %>';
			var AppRelativePath = '<%= Page.ResolveUrl(Page.AppRelativeVirtualPath)%>';
			return Protocol + HostPort + AppRelativePath;
		}

		function tryFormSubmit(e) {
			e.preventDefault(); // Stop Default Button Behaviour

			var AnimDuration = 500;

			var ClientButton = $("#" + e.srcElement.id);
			var ServerButton = $("#" + getClientID(ClientButton.attr('ServerButton')));
			var ErrorStatus = $("#" + getClientID("L_Error"));
			function resetErrorStatus() {
				ErrorStatus.html("");
			}

			var PageUrl = getPageUrl();
			var MethodUrl = '/' + ClientButton.attr('PostBackPath');
			var PostBackURL = PageUrl + MethodUrl;

			var DATA = '{' +
				'"TYPE": "' + $("#" + getClientID("HF_LoginType")).val() + '",' +
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
					} else {
						ErrorStatus.html("Unable to Login with provided credentials.");
						setTimeout(resetErrorStatus, 5000);
					}
				} else {
					console.log("Something went wrong while Ajax Success");
				}
			};
			var OnAjaxError = function (error) {
				//console.log(error);
			};
			var OnAjaxComplete = function () {
				//console.log("AJAX Completed");
			};
			performAjaxCall(PostBackURL, DATA, OnAjaxSuccess, OnAjaxError, OnAjaxComplete);
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
							<asp:Label ID="L_LoginUserType" runat="server" Text="Authorization/Login"></asp:Label>
							<div class="div_imagecontainer">
								<asp:Image ID="I_LoginUserType" runat="server" ImageUrl="~/_Images/Doctor_Male.png" />
							</div>
						</div>
					</div>
					<div class="div_divider"></div>
					<div id="div_col2" class="div_col col2">
						<div class="div_container">
							<div id="div_login_form" class="div_login_form">
								<asp:HiddenField ID="HF_LoginType" runat="server" Value="Doctor" />
								<asp:TextBox ID="TB_UN" runat="server" CssClass="tb" placeholder="Username" AutoCompleteType="Disabled"></asp:TextBox>
								<asp:TextBox ID="TB_PW" runat="server" CssClass="tb" placeholder="Password" TextMode="Password" AutoCompleteType="Disabled"></asp:TextBox>
								<button id="BTN_Login_Client" runat="server" postbackpath="isFormValid" serverbutton="BTN_Login" onclick="tryFormSubmit(event)" class="btn btn_green">Login</button>
								<asp:Button ID="BTN_Login" runat="server" CssClass="btn btn_green" Text="Login" TabIndex="3" OnClick="BTN_Login_Click" Style="display: none;" />
								<asp:Label ID="L_Error" runat="server" CssClass="span_error text_red" Text=""></asp:Label>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
</asp:Content>

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Error.aspx.cs" Inherits="DoctorsAppointmentManager.Pages.Home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>Error</title>
	<meta charset="UTF-8" />
	<meta content='width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=1' name='viewport' />
	<link rel="icon" type="image/png" href="~/_Images/Logo.png" />
	<link href="<%=ResolveClientUrl("~/_Styles/ErrorPage_CSS.css")%>" rel="Stylesheet" />
	<script src="<%=ResolveClientUrl("~/_Scripts/jquery-3.4.1.js")%>" type="text/javascript"></script>
	<script src="<%=ResolveClientUrl("~/_Scripts/PageUnload_JS.js")%>" type="text/javascript"></script>
	<script src="<%=ResolveClientUrl("~/_Scripts/JS.js")%>" type="text/javascript"></script>
</head>

<body>
	<div id="div_maincontainer" class="div_maincontainer">
		<div class="div_Error">
			<div class="div_ErrorDetails">
				<span class="oops">Oops!</span>
				<span class="text">Looks like something<br>
					went wrong.</span>
				<span class="ErrorCode">Error Code: <asp:Label ID="L_ErrorCode" runat="server" CssClass="ErrorCodeValue" Text="000" /></span>
				<span class="ErrorDetails">Error Details: <asp:Label ID="L_ErrorDetails" runat="server" CssClass="ErrorDetailsValue" Text="000" /></span>
				<div class="div_HelpfulLinks">
					<span>Here are some Helpful Links:</span>
					<a runat="server" id="A_Home" href="~">Home</a>
					<a runat="server" id="A_LoginDoctor" href="~/Login/Doctor">Login for Doctors and Staff</a>
					<a runat="server" id="A_LoginPatient" href="~/Login/Patient">Login for Patients</a>
					<a runat="server" id="A_RegisterPatient" href="~/Register/Patient">Registeration for Patients</a>
				</div>
			</div>
			<div class="div_ErrorImage">
				<img runat="server" id="I_ErrorImage" src="~/_Images/Confused.svg" />
			</div>
		</div>
	</div>
</body>
</html>

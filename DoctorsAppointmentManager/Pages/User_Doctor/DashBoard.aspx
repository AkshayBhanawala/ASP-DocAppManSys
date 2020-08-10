<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/User_Doctor/Doctor_MasterPage.Master" AutoEventWireup="true" CodeFile="DashBoard.aspx.cs" Inherits="DoctorsAppointmentManager.Pages.User_Doctor.DashBoard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>DashBoard</title>
	<link href="<%=ResolveClientUrl("~/_Styles/DashBoard_Doctor_CSS.css")%>" rel="Stylesheet" />
	<script>
		$(document).ready(function () {
			updateCounts();
			setInterval(updateCounts, 5000);
		}); 

		function updateCounts() {
			var L_PendingCaseTotalCount = $("#" + getClientID("L_PendingCaseTotalCount"));
			var L_PendingCaseTodayCount = $("#" + getClientID("L_PendingCaseTodayCount"));
			var L_CompletedCasesTodayCount = $("#" + getClientID("L_CompletedCasesTodayCount"));
			var L_CompletedCasesTotalCount = $("#" + getClientID("L_CompletedCasesTotalCount"));

			var PageUrl = getPageUrl();
			var MethodUrl = '/getCountValues';
			var PostBackURL = PageUrl + MethodUrl;

			var OnAjaxSuccess = function (response) {
				if (response != null) {
					response = JSON.parse(response.d);
					L_PendingCaseTotalCount.html(response.PendingCaseTotalCount);
					L_PendingCaseTodayCount.html(response.PendingCaseTodayCount);
					L_CompletedCasesTodayCount.html(response.CompletedCasesTodayCount);
					L_CompletedCasesTotalCount.html(response.CompletedCasesTotalCount);
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
			performAjaxCall(PostBackURL, null, OnAjaxSuccess, OnAjaxError, OnAjaxComplete);
		}
	</script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1_1" runat="server">
	<div id="div_contentpage" class="div_contentpage">
		<h1 id="h1" runat="server">DashBoard</h1>
		<div id="div_container" class="div_container">
			<div class="div_row">
				<div class="div_card">
					<div class="div_row1">
						<asp:Label ID="L_PendingCaseTotalCount" runat="server" Text="">0</asp:Label>
					</div>
					<div class="div_row2">
						<asp:Label ID="L_PendingCaseTotalText" runat="server" Text="Total Pending Cases"></asp:Label>
					</div>
				</div>
				<div class="div_card">
					<div class="div_row1">
						<asp:Label ID="L_PendingCaseTodayCount" runat="server" Text="">0</asp:Label>
					</div>
					<div class="div_row2">
						<asp:Label ID="L_PendingCaseTodayText" runat="server" Text="Today's Appointments"></asp:Label>
					</div>
				</div>
				<div class="div_card">
					<div class="div_row1">
						<asp:Label ID="L_CompletedCasesTodayCount" runat="server" Text="">0</asp:Label>
					</div>
					<div class="div_row2">
						<asp:Label ID="L_CompletedCasesTodayText" runat="server" Text="Today's Attended Cases"></asp:Label>
					</div>
				</div>
			</div>
			<div class="div_row">
				<div class="div_card">
					<div class="div_row1">
						<asp:Label ID="L_CompletedCasesTotalCount" runat="server" Text="">0</asp:Label>
					</div>
					<div class="div_row2">
						<asp:Label ID="L_CompletedCasesTotalText" runat="server" Text="Total Cases Completed"></asp:Label>
					</div>
				</div>
			</div>
		</div>
	</div>
</asp:Content>

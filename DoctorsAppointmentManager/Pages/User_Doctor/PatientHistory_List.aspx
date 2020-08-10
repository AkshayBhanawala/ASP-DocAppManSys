<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/User_Doctor/Doctor_MasterPage.Master" AutoEventWireup="true" CodeFile="PatientHistory_List.aspx.cs" Inherits="DoctorsAppointmentManager.Pages.User_Doctor.PatientHistory_List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Patients List</title>
	<link href="<%=ResolveClientUrl("~/_Styles/PatientsList_CSS.css")%>" rel="Stylesheet" />
	<script>

		var TB_Search = "";
		var div_nocases = "";
		var div_cases = "";
		var div_case = "";

		$(document).ready(function () {
			TB_Search = $("#" + getClientID("TB_Search"))
			div_nocases = $("#" + getClientID("div_nocases"));
			div_cases = $("#" + getClientID("div_cases"));
			div_case = div_cases.find("#div_case");
			div_nocases.hide();
			div_cases.hide();

			updateBindElements();
		});

		function updateBindElements() {
			TB_Search.keydown(function (e) {
				var KeyCode = e.which;
				//console.log(KeyCode);
				if (KeyCode == 13) {	// detecting enter key
					e.preventDefault();
					e.stopPropagation();
					e.stopImmediatePropagation();
					tryGetPatientsList();
				}
			});
		}

		function tryGetPatientsList() {
			var SearchQ = $.trim(TB_Search.val());
			if (SearchQ.length <= 0) {
				$("#actionResult").html("");
				div_nocases.hide();
				div_cases.hide();
				return;
			}
			var GenderImagePath = []
			GenderImagePath["Male"] = "<%=ResolveClientUrl("~/_Images/Gender_Male.svg")%>";
			GenderImagePath["Female"] = "<%=ResolveClientUrl("~/_Images/Gender_Female.svg")%>";
			GenderImagePath["Other"] = "<%=ResolveClientUrl("~/_Images/Gender_Other.svg")%>";

			var PageUrl = getPageUrl();
			var MethodUrl = '/getPatientsList';
			var PostBackURL = PageUrl + MethodUrl;
			var DocID = $("#" + getClientID("LogdInUserID")).val();
			var DATA = {
				"DocID": DocID,
				"SearchQ": SearchQ
			};
			DATA = JSON.stringify(DATA);

			var OnAjaxSuccess = function (response) {
				if (response != null) {
					response = JSON.parse(response.d);
					response.Rows = JSON.parse(response.Rows);
					$("#actionResult").html(response.Count + " &nbsp;matches");
					if (response.Count <= 0) {
						div_cases.hide();
						div_nocases.show();
					} else {
						div_nocases.hide();
						div_cases.show();
						div_cases.html("");
						$.each(response.Rows, function (I, Row) {
							var Gender = Row["GENDER"];
							var CASE = div_case.clone().prevObject;
							CASE.attr("gender", Gender);
							CASE.find("#L_PID").html("Patient. ID: " + Row["PID"]);
							var PHistoryLink = CASE.find("#A_PHistoryLink");
							CASE.find("#A_PHistoryLink").attr("href", PHistoryLink.attr("pageLink") + Row["PID"]);
							CASE.find("#L_PName").html(Row["PATIENTNAME"]);
							CASE.find("#L_Gender").html(Gender);
							CASE.find("#L_Age").html("Age: " + Row["AGE"]);
							div_cases.append(CASE.clone());
						});
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

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1_1" runat="server">
	<div id="div_contentpage" class="div_contentpage">
		<div id="div_Title" class="div_Title">
			<div>
				<h1 id="h1">Patients</h1>
			</div>
		</div>
		<div id="div_contentContainer" class="div_contentContainer">
			<div id="div_content" class="div_content">
				<div id="div_titleContainer" class="div_titleContainer">
					<div id="div_title" class="div_title">
						<h1 id="h2">Search</h1>
					</div>
					<div id="div_contentAction" class="div_contentAction">
						<input type="text" ID="TB_Search" TabIndex="1" class="tb" placeholder="Search Patient" title="Search Patient" autocomplete="off" />
					</div>
					<div id="div_actionResult" class="div_actionResult">
						<span id="actionResult"></span>
					</div>
				</div>
				<div id="div_cases" class="div_cases">
					<div id="div_case" class="div_case">
						<div class="col">
							<div class="row">
								<div class="col PID">
									<span id="L_PID">Patient ID</span>
								</div>
							</div>
							<div class="row">
								<div class="col PName">
									<a id="A_PHistoryLink" tabindex="-1" pagelink="<%=ResolveClientUrl("~/Doctor/PatientHistory/")%>" href="#" target="_blank">
										<span id="L_PName">Patient Name</span>
									</a>
								</div>
							</div>
							<div class="row">
								<div class="col Gender">
									<span id="L_Gender">Gender</span>
								</div>
								<div class="col Age">
									<span id="L_Age">Age</span>
								</div>
							</div>
						</div>
						<div id="genderBG" class="genderBG"></div>
					</div>
				</div>
				<div id="div_nocases" class="div_nocases">
					<div id="div_nocase" class="div_nocase">
						<span class="NoCase">No Patient Found</span>
					</div>
				</div>
			</div>
		</div>
	</div>
</asp:Content>

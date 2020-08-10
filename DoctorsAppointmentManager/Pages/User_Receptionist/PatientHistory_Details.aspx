<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/User_Receptionist/Receptionist_MasterPage.Master" AutoEventWireup="true" CodeFile="PatientHistory_Details.aspx.cs" Inherits="DoctorsAppointmentManager.Pages.User_Receptionist.PatientHistory_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title id="pageTitle" runat="server">Patients Details</title>
	<link href="<%=ResolveClientUrl("~/_Styles/PatientsDetails_CSS.css")%>" rel="Stylesheet" />
	<script>

		var div_nocases = "";
		var div_cases = "";
		var div_case = "";

		$(document).ready(function () {
			div_nocases = $("#" + getClientID("div_nocases"));
			div_cases = $("#" + getClientID("div_cases"));

			$("#div_cases").find(".div_case").each(function (index, div_case) {
				div_case = $(div_case);
				function toggleCaseCollapsing() {
					if (div_case.hasClass("opend")) {
						div_case.removeClass("opend");
						div_case.addClass("collapsed");
					} else {
						div_case.removeClass("collapsed");
						div_case.addClass("opend");
					}
				}
				div_case.find("#div_caseTab").bind("click", toggleCaseCollapsing);
				div_case.find("#span_closeTab").bind("click", toggleCaseCollapsing);
			});

		});

	</script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1_1" runat="server">
	<div id="div_contentpage" class="div_contentpage">
		<div id="div_Title" class="div_Title">
			<div id="div_patientname" class="div_patientname">
				<h1 runat="server" id="H1_PATIENTNAME">Patient Name</h1>
			</div>
			<div id="div_patientid" class="div_patientid">
				<span>ID: <span runat="server" id="SPAN_PATIENTID">PatientID</span></span>
			</div>
		</div>
		<div id="div_contentContainer" class="div_contentContainer">
			<div id="div_content" class="div_content">
				<div runat="server" id="genderBG" class="genderBG"></div>
				<div runat="server" id="div_titleContainer" class="div_titleContainer">
					<div class="div_birthdate">
						<div>
							<span>Birthdate:</span>
							<span runat="server" id="SPAN_BIRTHDATE">BIRTHDATE</span>
						</div>
						<div>
							<span>Age:</span>
							<span runat="server" id="SPAN_AGE">AGE</span>
						</div>
					</div>
					<div class="div_gender">
						<div>
							<span>Gender:</span>
							<span runat="server" id="SPAN_GENDER">GENDER</span>
						</div>
						<div>
							<span>BloodGroup:</span>
							<span runat="server" id="SPAN_BLOODGROUP">BLOODGROUP</span>
						</div>
					</div>
					<div class="div_contact">
						<div>
							<span>Address:</span>
							<span runat="server" id="SPAN_ADDRESS">ADDRESSADDRESSADDRESSADDRESS<br>
							</span>
						</div>
						<div>
							<span>Phone Number(s):</span>
							<span runat="server" id="SPAN_PHNO">1010101010</span>
						</div>
					</div>
				</div>
				<div id="div_cases" class="div_cases">
					<asp:ListView ID="LV1" runat="server">
						<ItemTemplate>
							<div class="div_case collapsed">
								<span id="span_closeTab" class="closeTab">✕</span>
								<div class="col">
									<div id="div_caseTab" class="row caseTab">
										<div class="col CID">
											<span><%# Eval("CaseID") %></span>
										</div>
										<div class="col CDate">
											<span><%# Eval("AppDate") %></span>
										</div>
										<div class="col CTime">
											<span><%# Eval("AppTime") %></span>
										</div>
									</div>
									<div id="div_collapsable" class="div_collapsable">
										<div class="row innerDivider MH"><span>Medical History</span></div>
										<div class="row data">
											<div class="col MHMedicines">
												<span class="head">Medicines: </span>
												<span><%# Eval("MH_Medicines") %></span>
											</div>
											<div class="col MHAllergies">
												<span class="head">Allergies: </span>
												<span><%# Eval("MH_Allergies") %></span>
											</div>
										</div>
										<div class="row innerDivider C"><span>Complaints</span></div>
										<div class="row data">
											<div class="col Complaints">
												<span><%# Eval("Complaints") %></span>
											</div>
										</div>
										<div class="row innerDivider TA"><span>Treatment & Advice</span></div>
										<div class="row data">
											<div class="col EyeDrops">
												<span class="head">Eye Drops: </span>
												<span><%# Eval("AT_ED") %></span>
											</div>
										</div>
										<div class="row data">
											<div class="col Medicines">
												<span class="head">Medicines: </span>
												<span><%# Eval("AT_MED") %></span>
											</div>
										</div>
										<div class="row data">
											<div class="col Advice">
												<span class="head">Advice: </span>
												<span><%# Eval("AT_Advice") %></span>
											</div>
										</div>
									</div>
								</div>
							</div>
						</ItemTemplate>
						<EmptyDataTemplate>
							<div id="div_nocase" class="div_nocase">
								<span>No Cases Found In New System</span>
						</EmptyDataTemplate>
					</asp:ListView>
				</div>
			</div>
		</div>
	</div>
</asp:Content>

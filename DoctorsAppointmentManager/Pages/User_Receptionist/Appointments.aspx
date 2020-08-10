<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/User_Receptionist/Receptionist_MasterPage.Master" AutoEventWireup="true" CodeFile="Appointments.aspx.cs" Inherits="DoctorsAppointmentManager.Pages.User_Receptionist.Appointments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Appointments</title>

	<link href="<%=ResolveClientUrl("~/_Styles/Appointments_CSS.css")%>" rel="Stylesheet" />
	<link href="<%=ResolveClientUrl("~/_Styles/ComboBox_CSS.css")%>" rel="Stylesheet" />
	<script src="<%=ResolveClientUrl("~/_Scripts/ComboBox_JS.js")%>" type="text/javascript"></script>

	<link href="<%=ResolveClientUrl("~/_Styles/jquery-ui.css")%>" rel="Stylesheet" />
	<link href="<%=ResolveClientUrl("~/_Styles/jquery-ui.structure.css")%>" rel="Stylesheet" />
	<link href="<%=ResolveClientUrl("~/_Styles/jquery-ui.theme.css")%>" rel="Stylesheet" />
	<script src="<%=ResolveClientUrl("~/_Scripts/jquery-ui.js")%>" type="text/javascript"></script>
	<style>
		.div_CaseDoc {
			background-color: #20202066;
		}
	</style>
	<script>
		$(document).ready(function () {
			tryUpdatePendingCases();
			setInterval(tryUpdatePendingCases, 10000);
			comboBox_UpdateView();
			updateBindElements();
		});

		function updateBindElements() {
			update_PatientID_Element();
			update_BirthDate_Element();
			update_AppointmentDate_Element();
			tryUpdateAppTimings();
			$("#" + getClientID("DDL_Doc_Filter")).change(function () {
				tryUpdatePendingCases();
			});
		}

		function update_PatientID_Element() {
			var DDL_PID = $("#" + getClientID("DDL_PID"));
			DDL_PID.change(function () {
				var PID = $(this).val();
				trySetPatientData(PID);
			});
		}

		function update_BirthDate_Element() {
			var TB_BD = $("#" + getClientID("TB_BD"));
			var browser_Format = "yy-mm-dd";
			var date_Format = "dd/mm/yy";
			var min_Date = $.datepicker.parseDate(browser_Format, TB_BD.attr("min"));
			var max_Date = $.datepicker.parseDate(browser_Format, TB_BD.attr("max"));
			var year_Range = min_Date.getFullYear() + ":" + max_Date.getFullYear();
			TB_BD.datepicker({
				dateFormat: date_Format,
				changeMonth: true,
				changeYear: true,
				minDate: min_Date,
				maxDate: max_Date,
				yearRange: year_Range
			});
			TB_BD.change(function (e) {
				var date = $.datepicker.parseDate(date_Format, TB_BD.val())
				if (date > max_Date) {
					e.target.setCustomValidity("Invalid Appointment Date");
				} else {
					e.target.setCustomValidity("");
				}
			});
		}

		function update_AppointmentDate_Element() {
			var TB_Date = $("#" + getClientID("TB_Date"));
			var browser_Format = "yy-mm-dd";
			var date_Format = "dd/mm/yy";
			var min_Date = $.datepicker.parseDate(browser_Format, TB_Date.attr("min"));
			var max_Date = $.datepicker.parseDate(browser_Format, TB_Date.attr("max"));
			TB_Date.datepicker({
				dateFormat: date_Format,
				minDate: min_Date,
				maxDate: max_Date
			});
			TB_Date.change(function (e) {
				var date = $.datepicker.parseDate(date_Format, TB_Date.val())
				if (date < min_Date || date > max_Date) {
					e.target.setCustomValidity("Invalid Appointment Date");
				} else {
					e.target.setCustomValidity("");
					tryUpdateAppTimings();
				}
			});
			TB_Date.val($.datepicker.formatDate("dd/mm/yy", min_Date));
		}

		function overlayBlur(show) {
			if (show) {
				$("#div_contentpage").addClass("blur");
			} else {
				$("#div_contentpage").removeClass("blur");
			}
		}

		function openAddAppointmentForm() {
			overlayBlur(true);
			$("#div_Container").removeClass("hide");
			$("#div_Container").addClass("show");
			$("#div_close").bind("click", cancelAddAppointmentForm);
			$("#div_Container").bind('keyup', function (event) {
				if (event.keyCode == 27) {
					cancelAddAppointmentForm();
				}
			});
		}

		function cancelAddAppointmentForm() {
			overlayBlur(false);
			$("#div_Container").removeClass("show");
			$("#div_Container").addClass("hide");
			$("#div_close").off();
			$("#div_Container").off();
		}

		function setAppFieldData(DataRow) {
			var HF_PATIENTCODE = $("#" + getClientID("HF_PATIENTCODE"));
			var TB_FN = $("#" + getClientID("TB_FN"));
			var TB_MN = $("#" + getClientID("TB_MN"));
			var TB_LN = $("#" + getClientID("TB_LN"));
			var TB_BD = $("#" + getClientID("TB_BD"));
			var DDL_Gender = $("#" + getClientID("DDL_Gender"));
			var DDL_Lang = $("#" + getClientID("DDL_Lang"));
			var TB_Height = $("#" + getClientID("TB_Height"));
			var TB_Weight = $("#" + getClientID("TB_Weight"));
			var DDL_BloodGroup = $("#" + getClientID("DDL_BloodGroup"));
			var TB_Address1 = $("#" + getClientID("TB_Address1"));
			var TB_Address2 = $("#" + getClientID("TB_Address2"));
			var TB_Address3 = $("#" + getClientID("TB_Address3"));
			var TB_City = $("#" + getClientID("TB_City"));
			var TB_State = $("#" + getClientID("TB_State"));
			var TB_Pincode = $("#" + getClientID("TB_Pincode"));
			var TB_Email = $("#" + getClientID("TB_Email"));
			var TB_PhNo1 = $("#" + getClientID("TB_PhNo1"));
			var TB_PhNo2 = $("#" + getClientID("TB_PhNo2"));

			var Genders = ["Male", "Female", "Other"];
			var Languages = ["English", "हिन्दी", "Hindi", "ગુજરાતી", "Gujarati"];
			var BloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];

			if (DataRow == null) {
				var DDL_PID = $("#" + getClientID("DDL_PID"));
				if (DDL_PID.val() != null) {
					if (DDL_PID.val().length > 0) {
						DDL_PID.val("").trigger("change");
					}
				}
				HF_PATIENTCODE.val("");
				TB_FN.val("");
				TB_MN.val("");
				TB_LN.val("");
				TB_BD.val("");
				DDL_Gender.val(Genders[0]).trigger("change");
				DDL_Lang.val(Languages[0]).trigger("change");
				TB_Height.val("");
				TB_Weight.val("");
				DDL_BloodGroup.val("").trigger("change");
				TB_Address1.val("");
				TB_Address2.val("");
				TB_Address3.val("");
				TB_City.val("");
				TB_State.val("");
				TB_Pincode.val("");
				TB_Email.val("");
				TB_PhNo1.val("");
				TB_PhNo2.val("");
			} else {
				HF_PATIENTCODE.val(DataRow.CODE);
				TB_FN.val(DataRow.FIRSTNAME);
				TB_MN.val(DataRow.MIDDLENAME);
				TB_LN.val(DataRow.LASTNAME);
				var date = new Date(Date.parse(DataRow.BIRTHDATE));
				var BDate = $.datepicker.formatDate("dd/mm/yy", date);
				TB_BD.val(BDate);
				var Gender = DataRow.GENDER;
				if (Genders[1].toLowerCase() == Gender.toLowerCase()) {
					Gender = Genders[1];
				} else if (Genders[2].toLowerCase() == Gender.toLowerCase()) {
					Gender = Genders[2];
				} else {
					Gender = Genders[0];
				}
				DDL_Gender.val(Gender).trigger("change");
				var Lang = DataRow.LANGUAGE;
				if (Languages[1].toLowerCase() == Lang.toLowerCase() ||
					Languages[2].toLowerCase() == Lang.toLowerCase()) {
					lang = Languages[1];
				} else if (Languages[3].toLowerCase() == Lang.toLowerCase() ||
					Languages[4].toLowerCase() == Lang.toLowerCase()) {
					lang = Languages[3];
				} else {
					lang = Languages[0];
				}
				DDL_Lang.val(lang).trigger("change");
				TB_Height.val((DataRow.HEIGHT <= 0) ? 0 : DataRow.HEIGHT);
				TB_Weight.val((DataRow.WEIGHT <= 0) ? 0 : DataRow.WEIGHT);
				var BloodGroup = DataRow.BLOODGROUP;
				var BGIndex = BloodGroups.indexOf(BloodGroup.toUpperCase());
				if (BGIndex >= 0) {
					BloodGroup = BloodGroups[BGIndex];
				} else {
					BloodGroup = "";
				}
				DDL_BloodGroup.val(BloodGroup).trigger("change");
				TB_Address1.val(DataRow.CURRENTADD1);
				TB_Address2.val(DataRow.CURRENTADD2);
				TB_Address3.val(DataRow.CURRENTADD3);
				TB_City.val(DataRow.CURRENTCITY);
				TB_State.val(DataRow.CURRENTSTATE);
				TB_Pincode.val(DataRow.PINCODE);
				TB_Email.val(DataRow.EMAILID);
				TB_PhNo1.val(DataRow.CURRENTCONTACTNO1);
				TB_PhNo2.val(DataRow.CURRENTCONTACTNO2);
			}
		}

		function getAppFieldData() {
			var firstName = $("#" + getClientID("TB_FN")).val();
			if ($.trim(firstName).length <= 0 || firstName == null) {
				return false;
			}

			var AD = $.datepicker.parseDate("dd/mm/yy", $("#" + getClientID("TB_Date")).val());
			AD = $.datepicker.formatDate("yy/mm/dd", AD);
			if (AD.length <= 0 || AD == null) {
				return false;
			}

			var middleName = $.trim($("#" + getClientID("TB_MN")).val());
			middleName = (middleName.length > 0) ? middleName : "-";

			var lastName = $.trim($("#" + getClientID("TB_LN")).val());
			lastName = (lastName.length > 0) ? lastName : "-";

			var height = $("#" + getClientID("TB_Height")).val();
			height = (height.length > 0) ? height : 0;

			var weight = $("#" + getClientID("TB_Weight")).val();
			weight = (weight.length > 0) ? weight : 0;

			var BD = $.datepicker.parseDate("dd/mm/yy", $("#" + getClientID("TB_BD")).val());
			BD = $.datepicker.formatDate("yy/mm/dd", BD);

			var AppData = {
				"CODE": $("#" + getClientID("HF_PATIENTCODE")).val(),
				"PATIENTID": $("#" + getClientID("DDL_PID")).val(),
				"FIRSTNAME": $("#" + getClientID("TB_FN")).val(),
				"MIDDLENAME": middleName,
				"LASTNAME": lastName,
				"BIRTHDATE": BD,
				"GENDER": $("#" + getClientID("DDL_Gender")).val(),
				"LANGUAGE": $("#" + getClientID("DDL_Lang")).val(),
				"HEIGHT": height,
				"WEIGHT": weight,
				"BLOODGROUP": $("#" + getClientID("DDL_BloodGroup")).val(),
				"CURRENTADD1": $("#" + getClientID("TB_Address1")).val(),
				"CURRENTADD2": $("#" + getClientID("TB_Address2")).val(),
				"CURRENTADD3": $("#" + getClientID("TB_Address3")).val(),
				"CURRENTCITY": $("#" + getClientID("TB_City")).val(),
				"CURRENTSTATE": $("#" + getClientID("TB_State")).val(),
				"PINCODE": $("#" + getClientID("TB_Pincode")).val(),
				"EMAILID": $("#" + getClientID("TB_Email")).val(),
				"CURRENTCONTACTNO1": $("#" + getClientID("TB_PhNo1")).val(),
				"CURRENTCONTACTNO2": $("#" + getClientID("TB_PhNo2")).val(),
				"APPDOCID": $("#" + getClientID("DDL_Doc")).val(),
				"APPDATE": AD,
				"APPTIME": $("#" + getClientID("DDL_Time")).val()
			};
			return AppData;
		}

		function tryUpdateAppTimings() {
			var DDL_Time = $("#" + getClientID("DDL_Time"));
			var TB_Date = $("#" + getClientID("TB_Date"));
			var AppDate = TB_Date.val();

			var PageUrl = getPageUrl();
			var MethodUrl = '/getTiming';
			var PostBackURL = PageUrl + MethodUrl;
			var DocID = $("#" + getClientID("DDL_Doc")).val();
			var AppDate = $("#" + getClientID("TB_Date")).val();
			var DATA = {
				"DocID": DocID,
				"AppDate": AppDate
			};
			DATA = JSON.stringify(DATA);

			var OnAjaxSuccess = function (response) {
				if (response != null) {
					response = JSON.parse(response.d);
					response.Rows = JSON.parse(response.Rows);
					DDL_Time.html("");
					if (response.Count > 0) {
						$.each(response.Rows, function (I, Row) {
							var option = $("<option></option>");
							option.text(Row);
							if (Row == "No Slot Available") {
								Row = "-";
							}
							option.val(Row);
							DDL_Time.append(option);
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
				comboBox_UpdateView(DDL_Time);
			};
			performAjaxCall(PostBackURL, DATA, OnAjaxSuccess, OnAjaxError, OnAjaxComplete);
		}

		function tryUpdatePendingCases() {
			var GenderImagePath = []
			GenderImagePath["Male"] = "<%=ResolveClientUrl("~/_Images/Gender_Male.svg")%>";
			GenderImagePath["Female"] = "<%=ResolveClientUrl("~/_Images/Gender_Female.svg")%>";
			GenderImagePath["Other"] = "<%=ResolveClientUrl("~/_Images/Gender_Other.svg")%>";
			var div_nocases = $("#" + getClientID("div_nocases"));
			var div_cases = $("#" + getClientID("div_cases"));
			var div_case = div_cases.find("#div_case");

			var PageUrl = getPageUrl();
			var MethodUrl = '/getPendingCases';
			var PostBackURL = PageUrl + MethodUrl;
			var DocID = parseInt($("#" + getClientID("DDL_Doc_Filter")).val());
			var DATA = {
				"DocID": DocID
			};
			DATA = JSON.stringify(DATA);

			var OnAjaxSuccess = function (response) {
				if (response != null) {
					response = JSON.parse(response.d);
					response.Rows = JSON.parse(response.Rows);
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
							CASE.find("#L_AppID").html("App. ID: " + Row["APPID"]);
							CASE.find("#L_PID").html("Patient. ID: " + Row["PID"]);
							var PHistoryLink = CASE.find("#A_PHistoryLink");
							CASE.find("#A_PHistoryLink").attr("href", PHistoryLink.attr("pageLink") + Row["PID"]);
							CASE.find("#L_PName").html(Row["PATIENTNAME"]);
							CASE.find("#L_Gender").html(Gender);
							CASE.find("#L_Age").html("Age: " + Row["AGE"]);
							CASE.find("#L_Date").html(Row["APPDATE"]);
							CASE.find("#L_Time").html(Row["APPTIME"]);
							CASE.find("#L_DocName").html(Row["DOCNAME"]);
							CASE.find("#L_DocSpec").html(Row["DOCSPEC"]);
							CASE.find("#BTN_CompleteAppointment").attr("onclick", "BTN_CompleteAppointment_Click(event," + Row["APPID"] + ")");
							div_cases.append(CASE.clone());
							if (DocID == -1) {
								div_cases.find(".div_CaseDoc").removeAttr("style");
							} else {
								div_cases.find(".div_CaseDoc").css("display", "none");
							}
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

		function trySetPatientData(PID) {
			if (PID == null) {
				setAppFieldData(null);
				return;
			}
			var PageUrl = getPageUrl();
			var MethodUrl = '/getPatientDetails';
			var PostBackURL = PageUrl + MethodUrl;
			var DATA = {
				"PatientID": PID
			};
			DATA = JSON.stringify(DATA);
			var OnAjaxSuccess = function (response) {
				if (response != null) {
					response = JSON.parse(response.d);
					response.Rows = JSON.parse(response.Rows);
					setAppFieldData(response.Rows[0]);
				} else {
					setAppFieldData(null);
					console.log("Something went wrong while Ajax Success");
				}
			};
			var OnAjaxError = function (error) {
				setAppFieldData(null);
				//console.log(error);
			};
			var OnAjaxComplete = function () {
				//console.log("AJAX Completed");
			};
			performAjaxCall(PostBackURL, DATA, OnAjaxSuccess, OnAjaxError, OnAjaxComplete);
		}

		function tryUpdateAppointment(AppID) {
			var PageUrl = getPageUrl();
			var MethodUrl = '/updateAppointmentStatus';
			var PostBackURL = PageUrl + MethodUrl;
			var DATA = {
				"AppID": AppID
			};
			DATA = JSON.stringify(DATA);

			var OnAjaxSuccess = function (response) {
				if (response != null) {
					if (response.d || response.d == "true") {
						tryUpdatePendingCases();
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

		function tryAddAppointment() {
			var AppData = getAppFieldData()
			if (AppData == false) {
				return;
			}
			var PageUrl = getPageUrl();
			var MethodUrl = '/addAppointment';
			var PostBackURL = PageUrl + MethodUrl;
			var DATA = {
				"AppData": JSON.stringify(AppData)
			};
			DATA = JSON.stringify(DATA);

			var OnAjaxSuccess = function (response) {
				if (response != null) {
					if (response.d || response.d == "true") {
						tryUpdatePendingCases();
						cancelAddAppointmentForm();
						setAppFieldData(null);
						tryUpdateAppTimings();
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

		function BTN_CompleteAppointment_Click(e, AppID) {
			var confirmYes = function () {
				overlayBlur(false);
				tryUpdateAppointment(AppID);
			};
			var confirmNo = function () {
				overlayBlur(false);
			};
			openConfirmDialog(confirmYes, confirmNo);
			overlayBlur(true);
		}

		function BTN_OpenAddAppointment_Click(e) {
			e.preventDefault();
			openAddAppointmentForm();
			setTimeout(function () {
				$("#" + getClientID("DDL_PID") + "_TB")[0].focus();
			}, 100);
		}

		function BTN_CancelAddAppointment_Click(e) {
			e.preventDefault();
			cancelAddAppointmentForm();
		}

		function BTN_AddAppointment_Click(e) {
			e.preventDefault();
			tryAddAppointment();
		}

	</script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1_1" runat="server">
	<div id="div_contentpage" class="div_contentpage">
		<div id="div_Appointments" class="div_Appointments">
			<div id="div_Title" class="div_Title">
				<div>
					<h1 id="h1">Appointments</h1>
				</div>
				<div>
					<div>
						<button id="BTN_OpenAddAppointment" class="btn btn_OpenAddApp" title="Add New Appointment" onclick="BTN_OpenAddAppointment_Click(event)">+</button>
					</div>
				</div>
			</div>
			<div id="div_AppointmentsList" class="div_AppointmentsList">
				<h1 id="h2">List of Appointments</h1>
				<div style="margin-bottom: 20px">
					<asp:DropDownList ID="DDL_Doc_Filter" runat="server" TabIndex="-1" title="Doctor"></asp:DropDownList>
				</div>
				<div id="div_cases" class="div_cases">
					<div id="div_case" class="div_case">
						<div class="col">
							<div class="row">
								<div class="col AppID">
									<span id="L_AppID">App. ID</span>
								</div>
								<div class="col PID">
									<span id="L_PID">Patient ID</span>
								</div>
							</div>
							<div class="row">
								<div class="col PName">
									<a id="A_PHistoryLink" tabindex="-1" pagelink="<%=ResolveClientUrl("~/Receptionist/PatientHistory/")%>" href="#" target="_blank">
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
						<div class="col">
							<div class="row Date">
								<span id="L_Date">Date</span>
							</div>
							<div class="row Time">
								<span id="L_Time">Time</span>
							</div>
						</div>
						<div class="col div_CaseDoc">
							<div class="row">
								<b><span id="L_DocName">Doctor Strange</span></b>
							</div>
							<div class="row">
								<b><span id="L_DocSpec">Time Sorcerer</span></b>
							</div>
						</div>
						<div class="col DeleteButton">
							<input type="button" id="BTN_CompleteAppointment" class="btn btn_green" value="Mark Complete" />
						</div>
						<div id="genderBG" class="genderBG"></div>
					</div>
				</div>
				<div id="div_nocases" class="div_nocases">
					<div id="div_nocase" class="div_nocase">
						<span class="NoCase">No New Appointments are scheduled for this Doctor</span>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="div_Container" class="div_Container">
		<div id="div_close" class="div_close">
			<span>✕</span>
		</div>
		<div id="div_FormContainer" class="div_FormContainer">
			<div id="div_AppointmentForm" class="div_AppointmentForm">
				<div class="row header">
					<div>
						<h1>Add Appointment</h1>
					</div>
				</div>
				<div class="row divider"></div>
				<div class="row">
					<div>
						<asp:DropDownList ID="DDL_PID" runat="server" TabIndex="1" placeholder="Patient ID" title="Patient ID" ComboBox_EditableTextBox="true" ComboBox_OpenOnFocus="false" ComboBox_IgnoreFirstOption="true"></asp:DropDownList>
						<asp:HiddenField ID="HF_PATIENTCODE" runat="server" />
					</div>
					<div id="hint" class="hint">
						<div id="hintElement" class="element">&#63;</div>
						<div id="hintContent" class="content">
							Info:<br>
							<br>
							Patient ID Consist Of:<br>
							<b>1st Letter of</b> Each Of the Following-<br>
							<b>F</b>irstName, <b>M</b>iddleName, <b>L</b>astName<br>
							Followed By a <b>-</b>(Hyphen/Dash)<br>
							then <b>Registration Number</b><br>
							<br>
							Ex:
							<br>
							FirstName = <b>A</b>kshay
							<br>
							MiddleName = <b>P</b>areshbhai
							<br>
							LastName = <b>B</b>hanawala
							<br>
							<br>
							Patient ID = APB-######
							<br>
							<br>
							<b>If</b> Patient is Already <b>Registered</b>, Patient ID will Appear in the Box & Data Will be <b>Automatically Filled</b>.<br>
							<br>
							Warning:<br>
							--> For <b>New Patient</b>, Please <b>Remove PatientID</b> value <b>Before</b> Appointing..
						</div>
					</div>
				</div>
				<div class="row">
					<div>
						<asp:TextBox ID="TB_FN" runat="server" TabIndex="2" CssClass="tb" placeholder="First Name" title="First Name" AutoCompleteType="Disabled" required></asp:TextBox>
					</div>
					<div>
						<asp:TextBox ID="TB_MN" runat="server" TabIndex="3" CssClass="tb" placeholder="Middle Name" title="Middle Name" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
					<div>
						<asp:TextBox ID="TB_LN" runat="server" TabIndex="4" CssClass="tb" placeholder="Last Name" title="Last Name" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
				</div>
				<div class="row">
					<div>
						<asp:TextBox ID="TB_BD" runat="server" TabIndex="5" CssClass="tb" placeholder="Birthdate [DD/MM/YYYY]" title="Birthdate" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
					<div>
						<asp:DropDownList ID="DDL_Gender" runat="server" TabIndex="6" placeholder="Gender" title="Gender"></asp:DropDownList>
					</div>
					<div>
						<asp:DropDownList ID="DDL_Lang" runat="server" TabIndex="7" placeholder="Preferred Language" title="Preferred Language"></asp:DropDownList>
					</div>
				</div>
				<div class="row">
					<div>
						<asp:TextBox ID="TB_Height" runat="server" TabIndex="8" CssClass="tb" placeholder="Height" title="Height" TextMode="Number" step="0.1" min="0" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
					<div>
						<asp:TextBox ID="TB_Weight" runat="server" TabIndex="9" CssClass="tb" placeholder="Weight" title="Weight" TextMode="Number" step="0.1" min="0" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
					<div>
						<asp:DropDownList ID="DDL_BloodGroup" runat="server" TabIndex="10" placeholder="Blood Group" title="Blood Group"></asp:DropDownList>
					</div>
				</div>
				<div class="row">
					<div>
						<asp:TextBox ID="TB_Address1" runat="server" TabIndex="11" CssClass="tb" placeholder="Address Line 1" title="Address Line 1" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
					<div>
						<asp:TextBox ID="TB_Address2" runat="server" TabIndex="12" CssClass="tb" placeholder="Address Line 2" title="Address Line 2" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
					<div>
						<asp:TextBox ID="TB_Address3" runat="server" TabIndex="13" CssClass="tb" placeholder="Address Line 3" title="Address Line 3" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
				</div>
				<div class="row">
					<div>
						<asp:TextBox ID="TB_City" runat="server" TabIndex="14" CssClass="tb" placeholder="City" title="City" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
					<div>
						<asp:TextBox ID="TB_State" runat="server" TabIndex="15" CssClass="tb" placeholder="State" title="State" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
					<div>
						<asp:TextBox ID="TB_Pincode" runat="server" TabIndex="16" CssClass="tb" placeholder="Pincode" title="Pincode" TextMode="Number" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
				</div>
				<div class="row">
					<div>
						<asp:TextBox ID="TB_Email" runat="server" TabIndex="17" CssClass="tb" placeholder="Email" title="Email" TextMode="Email" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
					<div>
						<asp:TextBox ID="TB_PhNo1" runat="server" TabIndex="18" CssClass="tb" placeholder="Phone No. 1" title="Phone Number 1" TextMode="Phone" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
					<div>
						<asp:TextBox ID="TB_PhNo2" runat="server" TabIndex="19" CssClass="tb" placeholder="Phone No. 2" title="Phone Number 2" TextMode="Phone" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
				</div>
				<div class="row divider"></div>
				<div class="row">
					<div>
						<asp:DropDownList ID="DDL_Doc" runat="server" TabIndex="20" title="Doctor" ComboBox_DropTop="true"></asp:DropDownList>
					</div>
					<div>
						<asp:TextBox ID="TB_Date" runat="server" TabIndex="21" CssClass="tb" placeholder="App Date [DD/MM/YYYY]" title="Appointment Date" AutoCompleteType="Disabled"></asp:TextBox>
					</div>
					<div>
						<select ID="DDL_Time" TabIndex="22" title="Appointment Time" ComboBox_DropTop="true"></select>
					</div>
				</div>
				<div class="row divider"></div>
				<div class="row tail">
					<div>
						<button id="BTN_AddAppointment" TabIndex="23" title="Add New Appointment" onclick="BTN_AddAppointment_Click(event)" class="btn btn_green">Add</button>
					</div>
					<div>
						<button id="BTN_CancelAddAppointment" TabIndex="24" title="Close Form" onclick="BTN_CancelAddAppointment_Click(event)" class="btn btn_orange">Cancel</button>
					</div>
				</div>
				<div class="row">
					<div>
						<asp:Label ID="L_Error" runat="server" CssClass="span_error text_red" Text=""></asp:Label>
					</div>
				</div>
			</div>
		</div>
	</div>
</asp:Content>

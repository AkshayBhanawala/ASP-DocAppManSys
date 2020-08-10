using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DoctorsAppointmentManager.Pages.User_Doctor
{
	public partial class Appointments : Page
	{
		protected override void Render(HtmlTextWriter writer)
		{
			// Register controls for ignoring modified control - event validation 

			base.Render(writer);
		}

		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				fill_DDL_PID();
				set_TB_BD();
				fill_DDL_Gender();
				fill_DDL_Lang();
				fill_DDL_BloodGroup();
				fill_DDL_Doc();
				set_TB_Date();
			}
		}
		private void fill_DDL_PID()
		{
			Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
			string Query = "SELECT PATIENTID FROM PATIENTREGISTRATION ORDER BY PATIENTID";
			DataTable DT = DBH.Get_Filled_DT(Query);
			DDL_PID.Items.Add(String.Empty);
			foreach (DataRow DR in DT.Rows) {
				DDL_PID.Items.Add(DR[0].ToString());
			}
		}
		private void set_TB_BD()
		{
			string browserDateFormat = "yyyy-MM-dd";
			string minDate = DateTime.Now.AddYears(-120).ToString(browserDateFormat);
			string maxDate = DateTime.Now.ToString(browserDateFormat);
			TB_BD.Attributes.Add("min", minDate);
			TB_BD.Attributes.Add("max", maxDate);
		}
		private void fill_DDL_Gender()
		{
			DDL_Gender.Items.Add("Male");
			DDL_Gender.Items.Add("Female");
			DDL_Gender.Items.Add("Other");
		}
		private void fill_DDL_Lang()
		{
			Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
			String Query = "SELECT DISTINCT LANGUAGE FROM ATLanguageData";
			DataTable DT = DBH.Get_Filled_DT(Query);
			foreach (DataRow DR in DT.Rows)
			{ DDL_Lang.Items.Add(DR[0].ToString()); }
		}
		private void fill_DDL_BloodGroup()
		{
			ListItem LM = new ListItem(String.Empty, "-");
			DDL_BloodGroup.Items.Add(LM);
			DDL_BloodGroup.Items.Add("A+");
			DDL_BloodGroup.Items.Add("A-");
			DDL_BloodGroup.Items.Add("B+");
			DDL_BloodGroup.Items.Add("B-");
			DDL_BloodGroup.Items.Add("AB+");
			DDL_BloodGroup.Items.Add("AB-");
			DDL_BloodGroup.Items.Add("O+");
			DDL_BloodGroup.Items.Add("O-");
		}
		private void fill_DDL_Doc()
		{
			Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
			string Query = "SELECT ((FIRSTNAME)+' '+(LASTNAME)+IIF(LEN(SPECIALITY)>0, ('  |  ' + SPECIALITY), '')) as DOCTORINFO, CODE FROM USERMASTER WHERE ISDOCTOR=1 AND APPROVED='APPROVED' AND APPROVEDAS='DOCTOR'";
			DataTable DT = DBH.Get_Filled_DT(Query);
			foreach (DataRow DR in DT.Rows)
			{
				ListItem li_doc = new ListItem(DR[0].ToString(), DR[1].ToString());
				DDL_Doc.Items.Add(li_doc);
			}
			DDL_Doc.SelectedValue = Session["Code"].ToString();
		}
		private void set_TB_Date()
		{
			string browserDateFormat = "yyyy-MM-dd";
			string minDate = DateTime.Now.ToString(browserDateFormat);
			string maxDate = DateTime.Now.AddDays(10).ToString(browserDateFormat);
			TB_Date.Attributes.Add("min", minDate);
			TB_Date.Attributes.Add("max", maxDate);
			TB_Date.Text = DateTime.Now.ToString("dd/MM/YYYY");
		}

		private static bool IsPatientAlreadyRegistered(dynamic DATA)
		{
			string PATIENTID = Convert.ToString(DATA.PATIENTID);
			// Checking if patient is already registered
			if (PATIENTID != "" && PATIENTID.Length > 3)
			{
				Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
				string Query = "SELECT CODE FROM PATIENTREGISTRATION WHERE PATIENTID='" + PATIENTID + "'";
				object Registered_CODE = DBH.Execute_Scalar(Query);
				if (Registered_CODE == null)
				{ return false; }
				else
				{ return true; }
			}
			else
			{ return false; }
		}

		private static bool Register_Patient(dynamic DATA)
		{
			System.Globalization.TextInfo textInfo = System.Threading.Thread.CurrentThread.CurrentCulture.TextInfo;
			string FIRSTNAME = textInfo.ToTitleCase(Convert.ToString(DATA.FIRSTNAME));
			string MIDDLENAME = textInfo.ToTitleCase(Convert.ToString(DATA.MIDDLENAME));
			string LASTNAME = textInfo.ToTitleCase(Convert.ToString(DATA.LASTNAME));
			string BIRTHDATE = Convert.ToString(DATA.BIRTHDATE);
			string GENDER = Convert.ToString(DATA.GENDER);
			string LANGUAGE = Convert.ToString(DATA.LANGUAGE);
			double HEIGHT = Convert.ToDouble(DATA.HEIGHT);
			double WIGHT = Convert.ToDouble(DATA.WIGHT);
			string BLOODGROUP = Convert.ToString(DATA.BLOODGROUP);
			string CURRENTADD1 = Convert.ToString(DATA.CURRENTADD1);
			string CURRENTADD2 = Convert.ToString(DATA.CURRENTADD2);
			string CURRENTADD3 = Convert.ToString(DATA.CURRENTADD3);
			string CURRENTCITY = Convert.ToString(DATA.CURRENTCITY);
			string CURRENTSTATE = Convert.ToString(DATA.CURRENTSTATE);
			string PINCODE = Convert.ToString(DATA.PINCODE);
			string CURRENTCONTACTNO1 = Convert.ToString(DATA.CURRENTCONTACTNO1);
			string CURRENTCONTACTNO2 = Convert.ToString(DATA.CURRENTCONTACTNO2);
			string EMAILID = Convert.ToString(DATA.EMAILID);

			Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();

			// Get New PatientID Code
			int Reg_Code = 1;
			string query = "SELECT MAX(CODE) FROM PATIENTREGISTRATION";
			object Last_Code = DBH.Execute_Scalar(query);
			if (Last_Code != DBNull.Value)
			{ Reg_Code = (int)Last_Code + 1; }
			DATA.CODE = Reg_Code;

			// Generate New PatientID
			string New_P_ID = "";
			New_P_ID += FIRSTNAME.Substring(0, 1) + MIDDLENAME.Substring(0, 1) + LASTNAME.Substring(0, 1);
			New_P_ID += "-" + Reg_Code;
			DATA.PATIENTID = New_P_ID;

			// Register Patient
			query = "INSERT INTO PATIENTREGISTRATION (PATIENTID, FIRSTNAME, MIDDLENAME, LASTNAME, BIRTHDATE, GENDER, LANGUAGE, HEIGHT, WEIGHT, BLOODGROUP, CURRENTADD1, CURRENTADD2, CURRENTADD3, CURRENTCITY, CURRENTSTATE, PINCODE, CURRENTCONTACTNO1, CURRENTCONTACTNO2, EMAILID) VALUES ('" + New_P_ID + "','" + FIRSTNAME + "','" + MIDDLENAME + "','" + LASTNAME + "','" + BIRTHDATE + "','" + GENDER + "','" + LANGUAGE + "'," + HEIGHT + "," + WIGHT + ",'" + BLOODGROUP + "','" + CURRENTADD1 + "','" + CURRENTADD2 + "','" + CURRENTADD3 + "','" + CURRENTCITY + "','" + CURRENTSTATE + "','" + PINCODE + "','" + CURRENTCONTACTNO1 + "','" + CURRENTCONTACTNO2 + "','" + EMAILID + "')";
			return (DBH.Execute_NonQuery(query) == 1) ? true : false;
		}

		private static bool Add_Appointment(dynamic DATA)
		{
			string PATIENTID = Convert.ToString(DATA.PATIENTID);
			int APPDOCID = Convert.ToInt32(DATA.APPDOCID);
			string APPDATE = Convert.ToString(DATA.APPDATE);
			string APPTIME = Convert.ToString(DATA.APPTIME);
			int CODE = Convert.ToInt32(DATA.CODE);

			Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
			string query = "INSERT INTO PATIENTSAPPOINTMENT (PATIENTID, DOCTORID, APPOINTMENTDATE, APPOINTMENTTIME, ISCANCELED, PATIENTSTATUS, PATIENTREGISTRATIONID) VALUES ('" + PATIENTID + "'," + APPDOCID + ",'" + APPDATE + "','" + APPTIME + "', 1, 'Appointed', " + CODE + ")";
			return (DBH.Execute_NonQuery(query) == 1) ? true : false;
		}

		[System.Web.Services.WebMethod]
		public static bool addAppointment(string AppData)
		{
			dynamic data = JObject.Parse(AppData);
			if (!IsPatientAlreadyRegistered(data))
			{
				Register_Patient(data);
				return Add_Appointment(data);
			}
			else
			{ return Add_Appointment(data); }
		}

		[System.Web.Services.WebMethod]
		public static string getPendingCases(int DocID)
		{
			Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
			string query = "SELECT PA.CODE AS APPID, PR.PATIENTID AS PID, (DATENAME(DAY,PA.APPOINTMENTDATE)+'-'+CONVERT(VARCHAR,DATEPART(MONTH,PA.APPOINTMENTDATE))+'-'+DATENAME(YEAR,PA.APPOINTMENTDATE)) AS APPDATE, (DATENAME(HOUR,PA.APPOINTMENTTIME)+':'+RIGHT('0' + DATENAME(MINUTE,PA.APPOINTMENTTIME),2)) AS APPTIME, ((PR.FIRSTNAME)+' '+(PR.MIDDLENAME)+' '+(PR.LASTNAME)) AS PATIENTNAME, PR.GENDER AS GENDER, (DATEDIFF(YEAR,PR.BIRTHDATE,GETDATE())) AS AGE FROM PATIENTREGISTRATION AS PR, PATIENTSAPPOINTMENT AS PA WHERE PR.CODE=PA.PATIENTREGISTRATIONID AND PA.PATIENTSTATUS='" + CaseStatus.Appointed + "' AND PA.DOCTORID=" + DocID + " ORDER BY PA.APPOINTMENTDATE, PA.APPOINTMENTTIME";
			DataTable DT = DBH.Get_Filled_DT(query);
			List<Dictionary<string, string>> ListDT = DBH.GetDataTableDictionaryList(DT);
			Dictionary<string, string> Counts = new Dictionary<string, string> {
				{ "Count", DT.Rows.Count.ToString() },
				{ "Rows", JsonConvert.SerializeObject(ListDT) }
			};
			string S = JsonConvert.SerializeObject(Counts);
			return S;
		}

		[System.Web.Services.WebMethod]
		public static bool updateAppointmentStatus(int AppID)
		{
			Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
			string query = "UPDATE PATIENTSAPPOINTMENT SET [PATIENTSTATUS]='" + CaseStatus.Complete + "' WHERE CODE=" + AppID;
			if (DBH.Execute_NonQuery(query) > 0)
			{ return true; }
			else
			{ return false; }
		}

		[System.Web.Services.WebMethod]
		public static string getTiming(int DocID, string AppDate)
		{
			string[] Time_List = { "13:00", "13:15", "13:30", "13:45", "14:00", "14:15", "14:30", "14:45", "15:00", "15:15", "15:30", "15:45", "16:00", "16:15", "16:30", "16:45", "17:00", "17:15", "17:30", "17:45", "18:00", "18:15", "18:30", "18:45", "19:00", "19:15", "19:30", "19:45", "20:00", "20:15", "20:30", "20:45", "21:00", "21:15", "21:30", "21:45", "22:00", "22:15", "22:30", "22:45" };
			AppDate = DateTime.ParseExact(AppDate, "dd/MM/yyyy", null).ToString("yyyy-MM-dd");
			Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
			string query = "SELECT APPOINTMENTTIME FROM PATIENTSAPPOINTMENT WHERE APPOINTMENTDATE='" + AppDate + "' AND DOCTORID=" + DocID;
			DataTable DT_Timings = DBH.Get_Filled_DT(query);
			Dictionary<string, string> Counts;
			if (DT_Timings.Rows.Count == Time_List.Length)
			{ Counts = new Dictionary<string, string> {
					{ "Count", DT_Timings.Rows.Count.ToString() },
					{ "Rows", JsonConvert.SerializeObject(new string[]{"No Slot Available"}) }
				}; }
			else
			{
				DT_Timings.Constraints.Add("AppTimePK", DT_Timings.Columns[0], true);
				List<String> Timings = new List<String>();
				foreach (string Time in Time_List)
				{
					if (!DT_Timings.Rows.Contains(Time))
					{ Timings.Add(Time); }
				}
				Counts = new Dictionary<string, string> {
					{ "Count", Timings.Count.ToString() },
					{ "Rows", JsonConvert.SerializeObject(Timings) }
				};
			}
			string S = JsonConvert.SerializeObject(Counts);
			return S;
		}

		[System.Web.Services.WebMethod]
		public static string getPatientDetails(string PatientID)
		{
			Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
			string query = "SELECT CODE, PATIENTID, FIRSTNAME, MIDDLENAME, LASTNAME, FORMAT(BIRTHDATE, 'yyyy/MM/dd') as BIRTHDATE, GENDER, LANGUAGE, HEIGHT, WEIGHT, BLOODGROUP, CURRENTADD1, CURRENTADD2, CURRENTADD3, CURRENTCITY, CURRENTSTATE, PINCODE, CURRENTCONTACTNO1, CURRENTCONTACTNO2, EMAILID FROM PATIENTREGISTRATION WHERE PATIENTID='" + PatientID + "'";
			DataTable DT = DBH.Get_Filled_DT(query);
			List<Dictionary<string, string>> ListDT = DBH.GetDataTableDictionaryList(DT);
			Dictionary<string, string> Counts = new Dictionary<string, string> {
				{ "Count", DT.Rows.Count.ToString() },
				{ "Rows", JsonConvert.SerializeObject(ListDT) }
			};
			string S = JsonConvert.SerializeObject(Counts);
			return S;
		}
	}
}
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using Newtonsoft.Json;

namespace DoctorsAppointmentManager.Pages.User_Receptionist
{
	public partial class DashBoard : Page
	{
		static int UserCode;
		protected void Page_Load(object sender, EventArgs e)
		{
			UserCode = Convert.ToInt32(Session["Code"]);
			if (!IsPostBack)
			{

			}
		}

		[System.Web.Services.WebMethod]
		public static string getCountValues()
		{
			Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
			string query = "";
			string CurrentDate = DateTime.Now.ToString("yyyy-MM-dd");

			// Total Pending Cases
			query = "SELECT PA.CODE FROM PATIENTREGISTRATION AS PR, PATIENTSAPPOINTMENT AS PA WHERE PR.CODE = PA.PATIENTREGISTRATIONID AND PA.PATIENTSTATUS = '" + CaseStatus.Appointed + "'";
			int C1 = DBH.getCount(query);

			// Today's Appointments
			query = "SELECT PA.CODE FROM PATIENTREGISTRATION AS PR, PATIENTSAPPOINTMENT AS PA WHERE PR.CODE = PA.PATIENTREGISTRATIONID AND PA.PATIENTSTATUS = '" + CaseStatus.Appointed + "' AND PA.APPOINTMENTDATE = '" + CurrentDate + "'";
			int C2 = DBH.getCount(query);

			// Today Completed Cases
			query = "SELECT PA.CODE FROM PATIENTREGISTRATION AS PR, PATIENTSAPPOINTMENT AS PA WHERE PR.CODE = PA.PATIENTREGISTRATIONID AND PA.PATIENTSTATUS = '" + CaseStatus.Complete + "' AND PA.APPOINTMENTDATE = '" + CurrentDate + "'";
			int C3 = DBH.getCount(query);

			// Total Completed Cases
			query = "SELECT PA.CODE FROM PATIENTREGISTRATION AS PR, PATIENTSAPPOINTMENT AS PA WHERE PR.CODE = PA.PATIENTREGISTRATIONID AND PA.PATIENTSTATUS = '" + CaseStatus.Complete + "'";
			int C4 = DBH.getCount(query);

			Dictionary<string, int> Counts = new Dictionary<string, int> {
				{ "PendingCaseTotalCount", C1 },
				{ "PendingCaseTodayCount", C2 },
				{ "CompletedCasesTodayCount", C3 },
				{ "CompletedCasesTotalCount", C4 }
			};
			String S = JsonConvert.SerializeObject(Counts);
			return S;
		}
	}
}
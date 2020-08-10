using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;

namespace DoctorsAppointmentManager.Pages.User_Doctor
{
	public partial class PatientHistory_List : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}

		private static string BuildQuery_NameSearch(string FieldName, string FullName)
		{
			string Query = "";
			foreach (string NamePart in FullName.Split())
			{ Query += FieldName + " LIKE " + "'%" + NamePart + "%' AND "; }
			Query = Query.Substring(0, Query.LastIndexOf(" AND "));
			return Query;
		}

		[System.Web.Services.WebMethod]
		public static string getPatientsList(int DocID, string SearchQ)
		{
			string Query = "";
			double SearchPN = 9999999999;
			Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
			DataTable DT;
			if (!(Double.TryParse(SearchQ, out SearchPN)))
			{
				Query = "SELECT DISTINCT PR.PATIENTID AS PID, ((PR.FIRSTNAME) + ' ' + (PR.MIDDLENAME) + ' ' + (PR.LASTNAME)) AS PATIENTNAME, PR.GENDER, (DATEDIFF(YEAR, PR.BIRTHDATE, GETDATE())) AS AGE FROM PATIENTREGISTRATION AS PR, PATIENTSAPPOINTMENT AS PA WHERE (PR.CODE = PA.PATIENTREGISTRATIONID AND PA.DOCTORID = " + DocID + ") AND ((PR.PATIENTID LIKE '%" + SearchQ + "%') OR (";
				string FieldName = "PR.FIRSTNAME + ' ' + PR.MIDDLENAME + ' ' + PR.LASTNAME";
				Query += BuildQuery_NameSearch(FieldName, SearchQ);
				Query += "));";
				DT = DBH.Get_Filled_DT(Query);
			}
			else
			{	if(SearchPN < 999)
				{
					SearchPN = -9999999999;
				}
				Query = "SELECT DISTINCT PR.PATIENTID AS PID, ((PR.FIRSTNAME) + ' ' + (PR.MIDDLENAME) + ' ' + (PR.LASTNAME)) AS PATIENTNAME, PR.GENDER, (DATEDIFF(YEAR, PR.BIRTHDATE, GETDATE())) AS AGE FROM PATIENTREGISTRATION AS PR, PATIENTSAPPOINTMENT AS PA WHERE (PR.CODE = PA.PATIENTREGISTRATIONID AND PA.DOCTORID = " + DocID + ") AND (PR.CURRENTCONTACTNO1 LIKE '" + SearchPN + "%' OR PR.CURRENTCONTACTNO2 LIKE '" + SearchPN + "%');";
				DT = DBH.Get_Filled_DT(Query);
			}
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
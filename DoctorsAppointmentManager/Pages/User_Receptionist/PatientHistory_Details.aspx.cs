using System;
using System.Data;

namespace DoctorsAppointmentManager.Pages.User_Receptionist
{
	public partial class PatientHistory_Details : System.Web.UI.Page
	{
		string Patient_ID;
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				if (Page.RouteData.Values.Count > 0)
				{
					Patient_ID = this.Page.RouteData.Values["PatientID"].ToString();
					Fill_PatientDetails();
					Fill_Cases();
				}
			}
		}

		private string getValidValue(string value)
		{
			value = value.Trim();
			if(value.Equals("") || value.Equals("-"))
			{ return ""; }
			return value;
		}

		public void Fill_PatientDetails()
		{
			string Query = "SELECT ((FIRSTNAME)+' '+(MIDDLENAME)+' '+(LASTNAME)) AS PATIENTNAME, BIRTHDATE, (DATEDIFF(YEAR,BIRTHDATE,GETDATE())) AS AGE, GENDER, BLOODGROUP, CURRENTADD1, CURRENTADD2, CURRENTADD3, CURRENTCITY, CURRENTSTATE, PINCODE, CURRENTCONTACTNO1, CURRENTCONTACTNO2 FROM PATIENTREGISTRATION WHERE PATIENTID='" + Patient_ID + "'";
			Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
			DataTable DT = DBH.Get_Filled_DT(Query);
			if (DT.Rows.Count <= 0)
			{ throw new Exception("Invalid Patient-ID"); }
			else
			{
				pageTitle.InnerHtml = "Details [" + DT.Rows[0]["PATIENTNAME"].ToString() + "]";
				H1_PATIENTNAME.InnerHtml = DT.Rows[0]["PATIENTNAME"].ToString();
				SPAN_PATIENTID.InnerHtml = Patient_ID;
				SPAN_BIRTHDATE.InnerHtml = ((DateTime)DT.Rows[0]["BIRTHDATE"]).ToString("dd, MMMM yyyy");
				SPAN_AGE.InnerHtml = DT.Rows[0]["AGE"].ToString();
				SPAN_GENDER.InnerHtml = DT.Rows[0]["GENDER"].ToString();
				genderBG.Attributes.Add("gender", DT.Rows[0]["GENDER"].ToString());
				string bloodgroup = getValidValue(DT.Rows[0]["BLOODGROUP"].ToString());
				bloodgroup = (bloodgroup.Equals("") ? "Untested" : bloodgroup);
				SPAN_BLOODGROUP.InnerHtml = bloodgroup;

				string[] addr = new string[6]
				{
					getValidValue(DT.Rows[0]["CurrentAdd1"].ToString()),
					getValidValue(DT.Rows[0]["CURRENTADD2"].ToString()),
					getValidValue(DT.Rows[0]["CURRENTADD3"].ToString()),
					getValidValue(DT.Rows[0]["CURRENTCITY"].ToString()),
					getValidValue(DT.Rows[0]["PINCODE"].ToString()),
					getValidValue(DT.Rows[0]["CURRENTSTATE"].ToString()),
				};
				string CurrAddress = addr[0];
				CurrAddress += (CurrAddress.Equals("") ? "" : "<br>") + addr[1];
				CurrAddress += ((CurrAddress.Equals("") || CurrAddress.EndsWith("<br>")) ? "" : "<br>") + addr[2];
				CurrAddress += ((CurrAddress.Equals("") || CurrAddress.EndsWith("<br>")) ? "" : "<br>") + addr[3];
				CurrAddress += ((CurrAddress.Equals("") || CurrAddress.EndsWith("<br>")) ? "" : addr[4].Equals("") ? "" : " - ") + addr[4];
				CurrAddress += ((CurrAddress.Equals("") || CurrAddress.EndsWith("<br>")) ? "" : "<br>") + addr[5];
				CurrAddress = (CurrAddress.Equals("") ? "None" : CurrAddress);
				SPAN_ADDRESS.InnerHtml = CurrAddress;

				string[] phno = new string[2]
				{
					getValidValue(DT.Rows[0]["CURRENTCONTACTNO1"].ToString()),
					getValidValue(DT.Rows[0]["CURRENTCONTACTNO2"].ToString())
				};
				string PhNos = phno[0];
				PhNos += (PhNos.Equals("") ? "" : "<br>") + phno[1];
				PhNos = (PhNos.Equals("") ? "None" : PhNos);
				SPAN_PHNO.InnerHtml = PhNos;
			}
		}

		public void Fill_Cases()
		{
			string Query = "SELECT * FROM EYEPATIENTCASES WHERE PATIENTID='" + Patient_ID + "'";
			Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
			DataTable DT1 = DBH.Get_Filled_DT(Query);
			if (DT1.Rows.Count <= 0)
			{ LV1.DataSource = DT1.DefaultView; }
			else
			{
				DataTable DT2 = new DataTable("CASES");
				Add_Case_DataColumns(ref DT2);
				foreach (DataRow DR in DT1.Rows)
				{ DT2.Rows.Add(Get_Case_Row(DR).ItemArray); }
				LV1.DataSource = DT2.DefaultView;
			}
			LV1.DataBind();
		}

		protected void Add_Case_DataColumns(ref DataTable DT)
		{
			DT.Columns.Add(new DataColumn("CaseID"));
			DT.Columns.Add(new DataColumn("AppDate"));
			DT.Columns.Add(new DataColumn("AppTime"));
			DT.Columns.Add(new DataColumn("Complaints"));
			DT.Columns.Add(new DataColumn("MH_Medicines"));
			DT.Columns.Add(new DataColumn("MH_Allergies"));
			DT.Columns.Add(new DataColumn("AT_ED"));
			DT.Columns.Add(new DataColumn("AT_MED"));
			DT.Columns.Add(new DataColumn("AT_Advice"));
		}

		protected DataRow Get_Case_Row(DataRow DR)
		{
			string Query = "SELECT APPOINTMENTDATE, APPOINTMENTTIME FROM PATIENTSAPPOINTMENT WHERE Code='" + DR[2].ToString() + "'";
			Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
			DataTable DT_TEMP = DBH.Get_Filled_DT(Query);

			DataTable DT = new DataTable();
			Add_Case_DataColumns(ref DT);
			DT.Rows.Add();
			//Case ID ------------------------------------------------------//
			DT.Rows[0].SetField(0, DR[0]);

			//AppDate ------------------------------------------------------//
			DateTime D = (DateTime)DT_TEMP.Rows[0][0];
			string Date = D.ToString("dddd, dd MMMM yyyy");
			DT.Rows[0].SetField(1, Date);

			//AppTime ------------------------------------------------------//
			TimeSpan T = (TimeSpan)DT_TEMP.Rows[0][1];
			string Time = T.ToString(@"hh\:mm");
			DT.Rows[0].SetField(2, Time);

			//Complaints ------------------------------------------------------//
			string Complaints = "";
			for (Int32 I = 3; I <= 6; I++)
			{
				if (DR[I] != null && !String.IsNullOrWhiteSpace(DR[I].ToString()))
				{ Complaints += Get_Complaint_Data_String(DR[I].ToString()); }
			}
			if (Complaints == "") { Complaints = "---"; }
			DT.Rows[0].SetField(3, Complaints);

			//MH Medicines ------------------------------------------------------//
			if (DR[7] != null && !String.IsNullOrWhiteSpace(DR[7].ToString()))
			{
				string[] MH_M_Values = DR[7].ToString().Split('|');
				string Medicines = "";
				foreach(string val in MH_M_Values)
				{
					Medicines = ((Medicines.Equals("") || Medicines.EndsWith("<br>")) ? "" : "<br>") + val;
				}
				Medicines = ((Medicines == "") ? "None" : Medicines);
				DT.Rows[0].SetField(4, Medicines);
			}

			//MH Allergies ------------------------------------------------------//
			if (DR[8] != null && !String.IsNullOrWhiteSpace(DR[8].ToString()))
			{
				string[] MH_A_Values = DR[8].ToString().Split('|');
				string Allergies = "";
				foreach (string val in MH_A_Values)
				{
					Allergies = ((Allergies.Equals("") || Allergies.EndsWith("<br>")) ? "" : "<br>") + val;
				}
				Allergies = ((Allergies == "") ? "None" : Allergies);
				DT.Rows[0].SetField(5, Allergies);
			}

			//Eye Drops ------------------------------------------------------//
			string AT_EyeDrops = "";
			for (Int32 I = 22; I <= 31; I++)
			{
				if (DR[I] != null && !String.IsNullOrWhiteSpace(DR[I].ToString()))
				{ AT_EyeDrops += Get_AT_EyeDrop_Data_String(DR[I].ToString()); }
			}
			AT_EyeDrops = ((AT_EyeDrops == "") ? "None" : AT_EyeDrops);
			DT.Rows[0].SetField(6, AT_EyeDrops);

			//Medicines ------------------------------------------------------//
			string AT_Medicines = "";
			for (Int32 I = 32; I <= 41; I++)
			{
				if (DR[I] != null && !String.IsNullOrWhiteSpace(DR[I].ToString()))
				{ AT_Medicines += Get_AT_Medicine_Data_String(DR[I].ToString()); }
			}
			AT_Medicines = ((AT_Medicines == "") ? "None" : AT_Medicines);
			DT.Rows[0].SetField(7, AT_Medicines);

			//Advices ------------------------------------------------------//
			DT.Rows[0].SetField(8, DR[42]);

			return DT.Rows[0];
		}

		protected string Get_Complaint_Data_String(string C)
		{
			string Complain = "";
			string[] C_Values = C.Split('|');
			Complain += "📝 ";
			Complain += C_Values[0] + "<br>";
			Complain += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Since " + C_Values[2] + " Month(s) & " + C_Values[1] + " Day(s) ";
			Complain += "<br><br>";
			return Complain;
		}

		protected string Get_AT_EyeDrop_Data_String(string AT_ED)
		{
			string EyeDrop = "";
			string[] AT_ED_Values = AT_ED.Split('|');
			EyeDrop += "💧 ";
			EyeDrop += AT_ED_Values[0] + "<br>&nbsp;&nbsp;&nbsp;&nbsp;";
			EyeDrop += AT_ED_Values[2] + " " + AT_ED_Values[1] + "(s) - ";
			EyeDrop += AT_ED_Values[3] + " ";
			EyeDrop += "(" + AT_ED_Values[4] + ", " + AT_ED_Values[5] + ", " + AT_ED_Values[6] + ", " + AT_ED_Values[7] + ")";
			EyeDrop += "<br><br>";
			return EyeDrop;
		}

		protected string Get_AT_Medicine_Data_String(string AT_MED)
		{
			string Medicine = "";
			string[] AT_MED_Values = AT_MED.Split('|');
			Medicine += "💊 ";
			Medicine += AT_MED_Values[0] + "<br>&nbsp;&nbsp;&nbsp;&nbsp;";
			Medicine += AT_MED_Values[2] + " " + AT_MED_Values[1] + "(s) - ";
			Medicine += "(" + AT_MED_Values[3] + ", " + AT_MED_Values[4] + ", " + AT_MED_Values[5] + ", " + AT_MED_Values[6] + ")";
			Medicine += "<br><br>";
			return Medicine;
		}
	}
}
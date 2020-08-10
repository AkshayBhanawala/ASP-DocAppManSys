using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.Routing;

namespace DoctorsAppointmentManager.Pages
{
	public partial class Login : System.Web.UI.Page
	{
		private bool isFemale = true;
		private bool isUserDoctor = false;

		protected void Page_Load(object sender, EventArgs e)
		{
			if (RouteData.Values.Count > 0)
			{
				string UserType = RouteData.Values["UserType"].ToString();
				if (UserType.ToLower() == "doctor" || UserType.ToLower() == "doc")
				{ isUserDoctor = true; }
			}

			if (!this.IsPostBack)
			{
				setupUI();
			}
		}

		private void setupUI()
		{
			string LoginText_Doctor = "Doctor's Authorization";
			string LoginText_Patient = "Patient's Login";
			string LoginText;

			string ImageURL;
			if (isUserDoctor)
			{
				HF_LoginType.Value = UserTypes.Doctor;
				LoginText = LoginText_Doctor;
				if (isFemale)
				{ ImageURL = URLs.Images.Doctor.Female; }
				else
				{ ImageURL = URLs.Images.Doctor.Male; }
			}
			else
			{
				HF_LoginType.Value = UserTypes.Patient;
				LoginText = LoginText_Patient;
				if (isFemale)
				{ ImageURL = URLs.Images.Patient.Female; }
				else
				{ ImageURL = URLs.Images.Patient.Male; }
			}
			L_LoginUserType.Text = LoginText;
			I_LoginUserType.ImageUrl = ImageURL;
		}

		protected void BTN_Login_Click(object sender, EventArgs e)
		{
			string URL_AfterLogin = URLs.Pages.Page[Session["UserType"].ToString()];
			Response.Redirect(URL_AfterLogin);
		}

		[System.Web.Services.WebMethod]
		public static bool isFormValid(string TYPE, string UN, string PW)
        {
			//dynamic stuff = JsonConvert.DeserializeObject(Data);
			bool isValid = false;
			if(!string.IsNullOrWhiteSpace(UN) && !string.IsNullOrWhiteSpace(PW))
			{
				Classes.DatabaseHandler DBH = new Classes.DatabaseHandler();
				string query = "";
				if (TYPE == UserTypes.Doctor) // Doctor Section or Patient Query
				{ query = "SELECT * FROM USERMASTER WHERE LOWER(USERID)='" + UN.ToLower() + "' AND PASSWORD='" + PW + "'"; }
				else
				{ return false; }
				SqlDataReader DR = DBH.Execute_Reader(query);
				if(DR.HasRows)
				{
					DR.Read();
					if (DR["Password"].ToString() == PW) // becasue SQL side string comparision is case-insensitive.
					{
						isValid = true;
						HttpContext.Current.Session["IsLoggedIn"] = true;
						HttpContext.Current.Session["Code"] = DR["Code"];
						HttpContext.Current.Session["UserID"] = DR["UserId"];
						HttpContext.Current.Session["UserType"] = DR["ApprovedAs"];
						HttpContext.Current.Session["FullName"] = DR["FullName"];
						HttpContext.Current.Session["Gender"] = DR["Gender"];
					}
					else
					{ isValid = false; }
					DR.Close();
					DBH.Connection_Close();
				}
				else
				{ isValid = false; }
			}
			return isValid;
		}
	}
}
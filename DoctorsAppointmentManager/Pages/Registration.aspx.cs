using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DoctorsAppointmentManager.Pages
{
	public partial class Registration : System.Web.UI.Page
	{
		// User Texts
		private string LoginText = "Patient's Registration";

		// User Type Image Paths
		private string ImageURL_Patient_Male = "~/_Images/Patient_Male.png";
		private string ImageURL_Patient_Female = "~/_Images/Patient_Female.png";
		private string ImageURL;
		
		private Boolean isFemale = true;

		protected void Page_Load(object sender, EventArgs e)
		{
			if (!this.IsPostBack)
			{
				setupUI();
			}
		}

		private void setupUI()
		{
			if (isFemale)
			{ ImageURL = ImageURL_Patient_Female; }
			else
			{ ImageURL = ImageURL_Patient_Male; }
			I_RegisterUserType.ImageUrl = ImageURL;
			L_RegisterUserType.Text = LoginText;
		}

		protected void BTN_Register_Click(object sender, EventArgs e)
		{
			Response.Redirect("~/Login/Patient");
		}

		[System.Web.Services.WebMethod]
		public static Boolean isFormValid(string UN, string PW)
		{
			//dynamic stuff = JsonConvert.DeserializeObject(Data);
			Boolean isValid = false;
			if (!string.IsNullOrWhiteSpace(UN) && !string.IsNullOrWhiteSpace(PW))
			{
				isValid = true;
			}
			return isValid;
		}
	}
}
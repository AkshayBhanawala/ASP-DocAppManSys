using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DoctorsAppointmentManager.Pages
{
	public partial class Home : System.Web.UI.Page
	{
		// User Type Image Paths
		private string ImageURL_Doctor_Male = "~/_Images/Doctor_Male.png";
		private string ImageURL_Doctor_Female = "~/_Images/Doctor_Female.png";
		private string ImageURL_Patient_Male = "~/_Images/Patient_Male.png";
		private string ImageURL_Patient_Female = "~/_Images/Patient_Female.png";
		private string ImageURL_Doctor, ImagePath_Patient;
		
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
			{
				ImageURL_Doctor = ImageURL_Doctor_Female;
				ImagePath_Patient = ImageURL_Patient_Female;
			}
			else
			{
				ImageURL_Doctor = ImageURL_Doctor_Male;
				ImagePath_Patient = ImageURL_Patient_Male;
			}
			I_Login_Doctor.ImageUrl= ImageURL_Doctor;
			I_Login_Patient.ImageUrl = ImagePath_Patient;
		}
	}
}
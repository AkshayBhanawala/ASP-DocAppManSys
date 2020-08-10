using System;
using System.Web.UI.WebControls;

namespace DoctorsAppointmentManager.Pages.User_Doctor
{
	public partial class Doctor_MasterPage : System.Web.UI.MasterPage
	{
		protected void Page_Init(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				if (Session["UserType"].ToString() != UserTypes.Doctor)
				{ Response.Redirect(URLs.Pages.Page[Session["UserType"].ToString()]); }
			}
		}
		protected void Page_Load(object sender, EventArgs e)
		{ }
	}
}
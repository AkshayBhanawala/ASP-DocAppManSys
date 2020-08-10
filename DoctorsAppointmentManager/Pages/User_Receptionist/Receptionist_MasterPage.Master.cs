using System;
using System.Web.UI.WebControls;

namespace DoctorsAppointmentManager.Pages.User_Receptionist
{
	public partial class Receptionist_MasterPage : System.Web.UI.MasterPage
	{
		protected void Page_Init(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				if (Session["UserType"].ToString() != UserTypes.Receptionist)
				{ Response.Redirect(URLs.Pages.Page[Session["UserType"].ToString()]); }
			}
		}
		protected void Page_Load(object sender, EventArgs e)
		{ }
	}
}
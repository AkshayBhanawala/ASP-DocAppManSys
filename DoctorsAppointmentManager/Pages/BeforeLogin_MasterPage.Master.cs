using System;

namespace DoctorsAppointmentManager.Pages
{
	public partial class BeforeLogin_MasterPage : System.Web.UI.MasterPage
	{
		protected void Page_Init(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				if (Session["IsLoggedIn"] != null)
				{
					if (Convert.ToBoolean(Session["IsLoggedIn"]))
					{ Response.Redirect(URLs.Pages.Page[Session["UserType"].ToString()]); }
				}
			}
		}
		protected void Page_Load(object sender, EventArgs e)
		{ }
	}
}
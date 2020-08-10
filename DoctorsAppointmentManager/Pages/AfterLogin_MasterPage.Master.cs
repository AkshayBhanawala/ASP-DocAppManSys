using System;
using System.Web.UI;

namespace DoctorsAppointmentManager.Pages
{
	public partial class AfterLogin_MasterPage : System.Web.UI.MasterPage
	{
		protected override void Render(HtmlTextWriter writer)
		{
			// Register controls for ignoring modified control - event validation 
			Page.ClientScript.RegisterForEventValidation(BTN_Logout.UniqueID.ToString());
			base.Render(writer);
		}

		protected void Page_Init(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				if (Session["IsLoggedIn"] != null)
				{
					if (!Convert.ToBoolean(Session["IsLoggedIn"]))
					{ Response.Redirect(URLs.Pages.Home); return; }
					setupUI();
					LogdInUserID.Value = Session["Code"].ToString();
					LogdInUserType.Value = Session["UserType"].ToString();
				}
				else
				{ Response.Redirect(URLs.Pages.Home); }
			}
		}

		protected void Page_Load(object sender, EventArgs e)
		{ }

		private void setupUI()
		{
			string UserType = Session["UserType"].ToString();
			string Gender = Session["Gender"].ToString();

			L_DisplayName.Text = Session["FullName"].ToString();
			I_photo.ImageUrl = URLs.Images.Image[UserType][Gender];
		}

		protected void BTN_Logout_Click(object sender, EventArgs e)
		{
			Session.Clear();
			Session.Abandon();
			Response.Redirect(URLs.Pages.Home);
		}
	}
}
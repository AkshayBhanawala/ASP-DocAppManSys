using System;

namespace DoctorsAppointmentManager.Pages
{
	public partial class Home : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!this.IsPostBack)
			{
				Exception E = Server.GetLastError();
				if (RouteData.Values.Count > 0)
				{
					string StatusCode = RouteData.Values["StatusCode"].ToString();
					if (StatusCode == "500")
					{
						Exception EX = new Exception("Some server side code has unhandled exception");
						try
						{ EX = (Exception)Session["LastError"]; }
						catch(Exception t) { EX = new Exception("Some server side code has unhandled exception"); }
						L_ErrorDetails.Text = (EX.InnerException != null) ? (EX.InnerException.Message + "<br>" + EX.Message) : (EX.Message);
					}
					L_ErrorCode.Text = StatusCode;
				}
				else
				{
					if (E != null)
					{
						E = E.GetBaseException();
						L_ErrorCode.Text = Response.StatusCode.ToString();
					}
				}
				Session.Clear();
				Session.Abandon();
			}
		}
	}
}
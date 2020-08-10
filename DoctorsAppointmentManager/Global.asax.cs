using System;
using System.Web;
using System.Web.Routing;

namespace DoctorsAppointmentManager
{
	public partial class Global : HttpApplication
	{
		protected void Application_Start(object sender, EventArgs e)
		{
			RegisterRoutes(RouteTable.Routes);
		}

		protected void Application_Error(object sender, EventArgs e)
		{
			Exception err = Server.GetLastError();
			HttpContext.Current.Session.Add("LastError", err);
		}

		void Session_Start(object sender, EventArgs e)
		{
			Session["LastError"] = ""; //initialize the session
		}

		static void RegisterRoutes(RouteCollection routes)
		{
			// Test Page Route
			routes.MapPageRoute("Test", "Test", "~/Pages/Test.aspx");

			// ErrorPage Route(s)
			routes.MapPageRoute("ErrorPage", "Error", "~/Pages/Error.aspx");
			routes.MapPageRoute("ErrorPageStatusCode", "Error/{StatusCode}", "~/Pages/Error.aspx");

			// Home Route(s)
			routes.MapPageRoute("Home", "", "~/Pages/Home.aspx");
			routes.MapPageRoute("Login", "Login", "~/Pages/Home.aspx");

			// Login Route(s)
			routes.MapPageRoute("LoginUserType", "Login/{UserType}", "~/Pages/Login.aspx");

			// Registration Route(s)
			routes.MapPageRoute("Register", "Register", "~/Pages/Registration.aspx");
			routes.MapPageRoute("RegisterPatient", "Register/Patient", "~/Pages/Registration.aspx");

			// Doctors Route(s)
			routes.MapPageRoute("Doctor", "Doctor", "~/Pages/User_Doctor/Dashboard.aspx");
			routes.MapPageRoute("DoctorDashboard", "Doctor/Dashboard", "~/Pages/User_Doctor/Dashboard.aspx");
			routes.MapPageRoute("DoctorAppointments", "Doctor/Appointments", "~/Pages/User_Doctor/Appointments.aspx");
			routes.MapPageRoute("DoctorPatientHistory", "Doctor/PatientHistory", "~/Pages/User_Doctor/PatientHistory_List.aspx");
			routes.MapPageRoute("DoctorPatientHistoryID", "Doctor/PatientHistory/{PatientID}", "~/Pages/User_Doctor/PatientHistory_Details.aspx");

			// Receptionist Route(s)
			routes.MapPageRoute("Receptionist", "Receptionist", "~/Pages/User_Receptionist/Dashboard.aspx");
			routes.MapPageRoute("ReceptionistDashboard", "Receptionist/Dashboard", "~/Pages/User_Receptionist/Dashboard.aspx");
			routes.MapPageRoute("ReceptionistAppointments", "Receptionist/Appointments", "~/Pages/User_Receptionist/Appointments.aspx");
			routes.MapPageRoute("ReceptionistPatientHistory", "Receptionist/PatientHistory", "~/Pages/User_Receptionist/PatientHistory_List.aspx");
			routes.MapPageRoute("ReceptionistPatientHistoryID", "Receptionist/PatientHistory/{PatientID}", "~/Pages/User_Receptionist/PatientHistory_Details.aspx");

			// Patients Route(s)
			routes.MapPageRoute("Patient", "Patient", "~/Pages/User_Patient/Dashboard.aspx");
			routes.MapPageRoute("PatientDashboard", "Patient/Dashboard", "~/Pages/User_Patient/Dashboard.aspx");
		}
	}
}
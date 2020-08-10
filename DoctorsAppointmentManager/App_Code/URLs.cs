using System.Collections.Generic;

namespace DoctorsAppointmentManager
{
	public static partial class URLs
	{
		public static partial class Pages
		{
			public const string
				Home = "~",
				Error = "~/Error",
				LoginDoctor = "~/Login/Doctor",
				LoginPatient = "~/Login/Patient",
				RegisterPatient = "~/Register/Patient",
				Admin = "~/Admin",
				Doctor = "~/Doctor",
				Receptionist = "~/Receptionist",
				IPDStaff = "~/IPDStaff",
				Patient = "~/Patient"
				;

			public static readonly Dictionary<string, string> Page = new Dictionary<string, string> {
				{ "Home", Home },
				{ "Error", Error },
				{ "LoginDoctor", LoginDoctor },
				{ "LoginPatient", LoginPatient },
				{ "RegisterPatient", RegisterPatient },
				{ "Admin", Admin },
				{ "Doctor", Doctor },
				{ "Receptionist", Receptionist },
				{ "IPD Staff", IPDStaff },
				{ "Patient", Patient }
			};
		}
		public static partial class Images
		{
			public static partial class Doctor
			{
				public const string
					Male = "~/_Images/Doctor_Male.png",
					Female = "~/_Images/Doctor_Female.png"
					;
			}
			public static partial class Patient
			{
				public const string
					Male = "~/_Images/Patient_Male.png",
					Female = "~/_Images/Patient_Female.png"
					;
			}
			public static partial class Admin
			{
				public const string
					Male = "~/_Images/Admin_Male.png",
					Female = "~/_Images/Admin_Female.png"
					;
			}
			public static partial class Receptionist
			{
				public const string
					Male = "~/_Images/Receptionist_Male.png",
					Female = "~/_Images/Receptionist_Female.png"
					;
			}
			public static partial class IPDStaff
			{
				public const string
					Male = "~/_Images/IPDStaff_Male.png",
					Female = "~/_Images/IPDStaff_Female.png"
					;
			}

			public static readonly Dictionary<string, Dictionary<string, string>> Image = new Dictionary<string, Dictionary<string, string>> {
				{ "Doctor", new Dictionary<string, string> {
					{ "Male", "~/_Images/Doctor_Male.png" },
					{ "Female", "~/_Images/Doctor_Female.png" }
					}},
				{ "Patient", new Dictionary<string, string> {
					{ "Male", "~/_Images/Patient_Male.png" },
					{ "Female", "~/_Images/Patient_Female.png" }
					}},
				{ "Admin", new Dictionary<string, string> {
					{ "Male", "~/_Images/Admin_Male.png" },
					{ "Female", "~/_Images/Admin_Female.png" }
					}},
				{ "Receptionist", new Dictionary<string, string> {
					{ "Male", "~/_Images/Receptionist_Male.png" },
					{ "Female", "~/_Images/Receptionist_Female.png" }
					}},
				{ "IPDStaff", new Dictionary<string, string> {
					{ "Male", "~/_Images/IPDStaff_Male.png" },
					{ "Female", "~/_Images/IPDStaff_Female.png" }
					}}
			};
		}
	}
}
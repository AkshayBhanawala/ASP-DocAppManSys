using System;
using System.Data.SqlClient;
using System.Data;
using System.Collections.Generic;
using System.Linq;

namespace DoctorsAppointmentManager.Classes
{
	public partial class DatabaseHandler
	{
		private static string CNS = System.Configuration.ConfigurationManager.ConnectionStrings["CN"].ToString();
		private SqlConnection CN = new SqlConnection(CNS);
		private SqlCommand Command_Object;

		public DatabaseHandler()
		{ }

		public void Connection_Open()
		{
			if (CN.State != ConnectionState.Open)
			{
				CN.Close();
				CN.Open();
			}
		}
		public void Connection_Close()
		{
			if (CN.State != ConnectionState.Closed)
			{ CN.Close(); }
		}

		public DataTable Get_Filled_DT(string Query)
		{
			DataSet DS = new DataSet();
			try
			{
				SqlDataAdapter DataAdapter_Object;
				DataAdapter_Object = new SqlDataAdapter(Query, CN);
				DataAdapter_Object.Fill(DS);
			}
			catch (Exception EX)
			{ System.Diagnostics.Debug.WriteLine(EX.ToString()); }
			Connection_Close();
			return DS.Tables[0].Copy();
		}

		public int getCount(string Query)
		{
			DataTable DT = Get_Filled_DT(Query);
			return DT.Rows.Count;
		}

		public int Execute_NonQuery(string Query)
		{
			int CommandOutput = -1;
			try
			{
				Connection_Open();
				Command_Object = new SqlCommand(Query, CN);
				CommandOutput = Command_Object.ExecuteNonQuery();
			}
			catch(Exception EX)
			{ System.Diagnostics.Debug.WriteLine(EX.ToString()); }
			Connection_Close();
			return CommandOutput;
		}

		public SqlDataReader Execute_Reader(string Query)
		{
			SqlDataReader DR = null;
			try
			{
				Connection_Open();
				Command_Object = new SqlCommand(Query, CN);
				DR = Command_Object.ExecuteReader();
			}
			catch (Exception EX)
			{
				Connection_Close();
				System.Diagnostics.Debug.WriteLine(EX.ToString());
			}
			return DR;
		}

		public object Execute_Scalar(string Query)
		{
			object OBJ = null;
			try
			{
				Connection_Open();
				Command_Object = new SqlCommand(Query, CN);
				OBJ = Command_Object.ExecuteScalar();
			}
			catch (Exception EX)
			{ System.Diagnostics.Debug.WriteLine(EX.ToString()); }
			Connection_Close();
			return OBJ;
		}
		public List<Dictionary<string, string>> GetDataTableDictionaryList(DataTable DT)
		{
			return DT.AsEnumerable().Select(
				row => DT.Columns.Cast<DataColumn>().ToDictionary(
					column => column.ColumnName,
					column => row[column].ToString()
				)).ToList();
		}
	}
}
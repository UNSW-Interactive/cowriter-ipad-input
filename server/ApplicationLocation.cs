/*
 * Created by SharpDevelop.
 * User: froman
 * Date: 22.11.2012
 * Time: 10:14
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;

namespace CoWriterServer
{
	/// <summary>
	/// Description of ApplicationLocation.
	/// </summary>
	public class ApplicationLocation
	{
		public static readonly string StartupPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);		

		public const string DATE_TIME_STRING_MAIN = "yyyy-MM-dd HH:mm:ss";
		
		public const string EXTENSION_CSV = ".csv";
		public const string EXTENSION_XML = ".xml";
		public const string EXTENSION_TXT = ".txt";
		
		public const string LOG_FILE = "LogFile";
		
		public static readonly DelimitedListTraceListener Log = new DelimitedListTraceListener(StartupPath + "\\" + LOG_FILE + EXTENSION_TXT);

	}
}

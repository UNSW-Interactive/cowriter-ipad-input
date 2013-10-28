/*
 * Created by SharpDevelop.
 * User: Flaviu
 * Date: 2013-05-29
 * Time: 14:29
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Drawing;
using System.IO;
using System.Security.Cryptography;

namespace CoWriterServer
{
	/// <summary>
	/// Description of TimePoint.
	/// </summary>
	public class TimePoint
	{
		public double X {get;set;}
		public double Y {get;set;}
		public Color C {get;set;}
		public DateTime T {get;set;}
		public string I {get;set;}
		
		public TimePoint()
		{
			X = 0; Y = 0; C = Color.Black; T = DateTime.Now; I = Path.GetRandomFileName();
		}
		
		public TimePoint(double x, double y, Color c, DateTime t, string i) {
			X = x;
			Y = y;
			C = c;
			T = t;
			I = i;
		}
	}
}

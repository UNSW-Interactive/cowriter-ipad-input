/*
 * Created by SharpDevelop.
 * User: froman
 * Date: 12.09.2012
 * Time: 08:53
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using Newtonsoft.Json;

namespace CoWriterServer
{
	/// <summary>
	/// Description of UIFreeHandLine.
	/// </summary>
	public class UIFreeHandLine
	{
		public const string POINT_X = "X";
		public const string POINT_Y = "Y";
		public const string TIME = "T";
		public const string COLOR = "C";
		public const string ID = "I";
		
 		public List<TimePoint> Points {get;set;}
		
		public UIFreeHandLine()
		{
			Points = new List<TimePoint>();
		}
		
		public List<Dictionary<string, object>> Serialize() {
			List<Dictionary<string, object>> lst = new List<Dictionary<string, object>>();
			foreach (TimePoint p in Points) {
				Dictionary<string, object> d = new Dictionary<string, object>();
				d.Add(POINT_X, p.X);
				d.Add(POINT_Y, p.Y);
				d.Add(TIME, p.T);
				d.Add(COLOR, p.C.ToArgb());
				d.Add(ID, p.I);
				lst.Add(d);
			}
			return lst;
		}
		
		public void Deserialize(string s) {
			List<Dictionary<string, object>> lst = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(s);
			foreach (Dictionary<string, object> d in lst) {
				Points.Add(new TimePoint((float)Convert.ToDouble(d[POINT_X].ToString()), (float)Convert.ToDouble(d[POINT_Y].ToString()), Color.FromArgb((int)Convert.ToInt32(d[COLOR].ToString())), DateTime.ParseExact(d[TIME].ToString(), "yyyy-MM-dd HH:mm:ss.fff", CultureInfo.CurrentCulture), d[ID].ToString()));
			}
		}
	}
}

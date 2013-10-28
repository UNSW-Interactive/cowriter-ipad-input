/*
 * Created by SharpDevelop.
 * User: Flaviu
 * Date: 2013-05-29
 * Time: 14:43
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Collections.Generic;
using System.Drawing;
using Newtonsoft.Json;

namespace CoWriterServer
{
	/// <summary>
	/// Description of User.
	/// </summary>
	public class User
	{
//		public const int USER_TIMEOUT = 10; // seconds
		public const int USER_TIMEOUT = 300; // seconds
		
		public string UserID {get;set;}
		public List<UIFreeHandLine> Shapes {get;set;} 
		public DateTime LastConnection {get;set;}
		
		public User()
		{
			Shapes = new List<UIFreeHandLine>();
			LastConnection = DateTime.Now;
		}
		
		public void AddReplaceShape(UIFreeHandLine newShape) {
			if (newShape.Points.Count == 0) return;
			for (int i = Shapes.Count - 1; i >= 0; i--) {
				UIFreeHandLine fhl = Shapes[i];
				if (fhl.Points.Count > 0) {
					if (fhl.Points[0].I.Equals(newShape.Points[0].I)) {
						lock (Shapes) {
							int pos = Shapes.IndexOf(fhl);
							Shapes.RemoveAt(pos);
							Shapes.Insert(pos, newShape);
						}
						return;
					}
				}
			}
			lock (Shapes) {
				Shapes.Add(newShape);
			}
		}
		
		public bool Timeout {
			get {
				return DateTime.Now.Subtract(LastConnection).TotalSeconds > USER_TIMEOUT;
			}
		}

		public List<List<Dictionary<string, object>>> Serialize() {
			List<List<Dictionary<string, object>>> lines = new List<List<Dictionary<string, object>>>();
			lock (Shapes) {
				foreach (UIFreeHandLine fhl in Shapes) {
					lines.Add(fhl.Serialize());
				}
			}
			return lines;
		}
	}
}

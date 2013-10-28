/*
 * Created by SharpDevelop.
 * User: froman
 * Date: 22.11.2012
 * Time: 10:38
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Drawing;
using System.Threading;
using System.Timers;
using System.Xml.Serialization;

namespace CoWriterServer
{
	/// <summary>
	/// Description of Manager.
	/// </summary>
	public class Manager
	{
		
		public const int STATE_INPUT = 0;
		public const int STATE_INPUT_WAITING = 1;
		public const int STATE_VERIFY = 2;
		
//		public int State {get;set;}
		public List<User> Users {get;set;}
		string SessionID;
		public ColorCoresp ColorList {get;set;}
		List<int> UsedColor = new List<int>();
		
		public Manager()
		{
			Users = new List<User>();
			ColorList = LoadColorList();
			SessionID = Path.GetRandomFileName();
//			State = STATE_INPUT;
			System.Threading.Timer t = new System.Threading.Timer(
				delegate {
					for (int i = Users.Count - 1; i >= 0; i--) {
						if (Users[i].Timeout) {
							lock (Users) {
								try {
									Users.RemoveAt(i);
								}
								catch {}
							}
						}
					}
					if (Users.Count == 0) {
//						State = STATE_INPUT;
					}
				},
				null, 2000, 2000);
		}
		
		bool UserExists(string udid) {
			return UserGet(udid) != null;
		}
		
		User UserGet(string udid) {
			for (int i = 0; i < Users.Count; i++) {
				User u = Users[i];
				if (u.UserID.Equals(udid)) {
					lock (u) {
						u.LastConnection = DateTime.Now;
					}
					return u;
				}
			}
			return null;
		}
		
		void UserAdd(string udid) {
			User u = new User();
			u.UserID = udid;
			lock (Users) {
				Users.Add(u);
			}
		}
		
		public void ClearUsersShapes() {
			SaveSession("End of Session");
			foreach (User u in Users) {
				u.Shapes.Clear();
			}
			SessionID = Path.GetRandomFileName();
		}
		
		bool AllUsersHaveShapes {
			get {
				foreach (User u in Users) {
					if (u.Shapes.Count == 0) return false;
				}
				return true;
			}
		}
		
		public void SaveSession(string reason) {
			try {
				string FileName = "";
				if (reason.Equals("Autosave")) {
					FileName = ApplicationLocation.StartupPath + "\\" + DateTime.Now.ToString("yyyy-MM-dd") + " " + SessionID + " " + reason + ".txt";
				}
				else {
					FileName = ApplicationLocation.StartupPath + "\\" + DateTime.Now.ToString("yyyy-MM-dd") + " " + SessionID + " " + DateTime.Now.ToString("HH-mm-ss") + " " + reason + ".txt";
				}
				StreamWriter sw = new StreamWriter(FileName);
				for (int i = 0; i < Users.Count; i++) {
					User u = Users[i];
					sw.WriteLine("User: " + u.UserID);
					if (u.Shapes.Count > 0) {
						sw.WriteLine("Color: " + u.Shapes[0].Points[0].C.ToString());
					}
					for (int j = 0; j < u.Shapes.Count; j++) {
						UIFreeHandLine fhl = u.Shapes[j];
						sw.WriteLine(fhl.Points[0].X + "," + fhl.Points[0].Y + "," + fhl.Points[0].T.ToString("HH:mm:ss.fff"));
						for (int k = 1; k < fhl.Points.Count; k++) {
							TimePoint tp = fhl.Points[k];
							TimePoint tp0 = fhl.Points[k-1];
							sw.WriteLine((tp.X - tp0.X) + "," + (tp.Y - tp0.Y) + "," + tp.T.Subtract(tp0.T).ToString());
						}
						sw.WriteLine();
					}
				}
				sw.WriteLine("---------------------------------------");
				sw.Close();
			}
			catch (Exception e) {
				ApplicationLocation.Log.WriteLine("Failed to save at " + DateTime.Now.ToString(ApplicationLocation.DATE_TIME_STRING_MAIN) + " : " + e.ToString());
			}
		}
		
		public NetworkObject CreateResponseFromRequest(NetworkObject NOReq) {
			NetworkObject NORsp = new NetworkObject();
			NORsp.NetworkCode = NOReq.NetworkCode;
			string eo1 = "", eo2 = "", eo3 = "", eo4 = "", eo5 = "";
			if (NOReq.ExchangeObjects.Count > 0) {
				eo1 = NOReq.ExchangeObjects[0].ToString();
			}
			if (NOReq.ExchangeObjects.Count > 1) {
				eo2 = NOReq.ExchangeObjects[1].ToString();
			}
			if (NOReq.ExchangeObjects.Count > 2) {
				eo3 = NOReq.ExchangeObjects[2].ToString();
			}
			if (NOReq.ExchangeObjects.Count > 3) {
				eo4 = NOReq.ExchangeObjects[3].ToString();
			}
			if (NOReq.ExchangeObjects.Count > 4) {
				eo5 = NOReq.ExchangeObjects[4].ToString();
			}
			switch (NOReq.NetworkCode) {
				case NetworkObject.REQUEST_STATE:
					if (!UserExists(eo1)) {
						UserAdd(eo1);
					}
					User u = UserGet(eo1);
//					switch (State) {
//						case STATE_INPUT:
//							NORsp.ExchangeObjects.Add(u.Shapes.Count == 0 ? STATE_INPUT : STATE_INPUT_WAITING);
					NORsp.ExchangeObjects.Add(GetColor(eo1).ToArgb());
//					NORsp.ExchangeObjects.Add(GenerateColor(Users.IndexOf(u)).ToArgb());
//							break;
//						case STATE_VERIFY:
//							NORsp.ExchangeObjects.Add(STATE_VERIFY);
					foreach (User uuu in Users) {
						if (uuu.Shapes.Count > 0) {
							NORsp.ExchangeObjects.AddRange(uuu.Serialize());
//									Console.WriteLine("User {0} Shapes {1}", uuu.UserID, uuu.Shapes.Count);
						}
					}
//							break;
//						default:
//
//							break;
//					}
					break;
					
				case NetworkObject.CLEAR_MY_SHAPES:
					User me = UserGet(eo1);
					SaveSession("Delete by " + me.UserID);
					me.Shapes.Clear();
//					State = STATE_INPUT;
					break;
					
				case NetworkObject.SEND_SHAPE:
					if (UserExists(eo1)) {
						User uu = UserGet(eo1);
//						uu.Shapes.Clear();
						for (int i = 1; i < NOReq.ExchangeObjects.Count; i++) {
							UIFreeHandLine uif = new UIFreeHandLine();
							uif.Deserialize(NOReq.ExchangeObjects[i].ToString());
							uu.AddReplaceShape(uif);
//							Console.WriteLine("Shapes with the added / replaced one {0}", uu.Shapes.Count);
						}
					}
					break;
					
				default:
					ApplicationLocation.Log.WriteLine("No such Message ID: " + NOReq.NetworkCode);
					break;
			}
			return NORsp;
		}
		
		static Color GenerateColor(int UserNo) {
			switch (UserNo % 10) {
					case 0: return Color.Blue;
					case 1: return Color.Red;
					case 2: return Color.Lime;
					case 3: return Color.Magenta;
					case 4: return Color.Cyan;
					case 5: return Color.DarkKhaki;
					case 6: return Color.Turquoise;
					case 7: return Color.Pink;
					case 8: return Color.SkyBlue;
					case 9: return Color.Yellow;
					default: return Color.Black;
			}
		}
		
//		Color GetColor(string udid) {
//			Color clr;
//			int num = Users.Count - 1;
//			if (ColorList.ColorList.ContainsKey(udid)) {
//				clr = Color.FromArgb(ColorList.ColorList[udid]);
//			}
//			else {
//				clr = GenerateColor(num);
//				num++;
//			}
//			
//			if (UsedColor.Contains(clr.ToArgb())) {
//				do {
//					clr = GenerateColor(num);
//					num++;
//				} while (UsedColor.Contains(clr.ToArgb()));
//				UsedColor.Add(clr.ToArgb());
//				if (ColorList.ColorList.ContainsKey(udid)) {
//					ColorList.ColorList.Remove(udid);
//				}
//				ColorList.AddPair(udid, clr);
//				SaveColorList();
//			}
//			else {
//				UsedColor.Add(clr.ToArgb());
//			}
//			return clr;
//		}

		Color GetColor(string udid) {
			Color clr;
			int num = Users.Count - 1;
			if (ColorList.ColorList.ContainsKey(udid)) {
				clr = Color.FromArgb(ColorList.ColorList[udid]);
			}
			else {
				do {
					clr = GenerateColor(num);
					num++;
				} while (ColorList.ColorList.ContainsValue(clr.ToArgb()));
				if (ColorList.ColorList.ContainsKey(udid)) {
					ColorList.ColorList[udid] = clr.ToArgb();
				}
				else {
					ColorList.AddPair(udid, clr);
				}
				SaveColorList();
			}
			return clr;
		}
		
		public ColorCoresp LoadColorList() {
			ColorCoresp sts = new ColorCoresp();
			XmlSerializer xml = new XmlSerializer(typeof(ColorCoresp));
			StreamReader sr = null;
			try {
				sr = new StreamReader(ApplicationLocation.StartupPath + "\\" + "ColorList.xml");
				sts = (ColorCoresp)xml.Deserialize(sr);
			}
			catch {
				if (sr != null) {
					sr.Close();
				}
				return sts;
			}
			if (sr != null) {
				sr.Close();
			}
			return sts;
		}
		
		public void SaveColorList() {
			XmlSerializer xml = new XmlSerializer(ColorList.GetType());
			StreamWriter tw = new StreamWriter(ApplicationLocation.StartupPath + "\\" + "ColorList.xml");
			xml.Serialize(tw, ColorList);
			tw.Close();
		}

	}
}

/*
 * Created by SharpDevelop.
 * User: froman
 * Date: 22.11.2012
 * Time: 10:10
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Runtime.CompilerServices;
using System.Threading;

namespace CoWriterServer
{
	/// <summary>
	/// Description of Server.
	/// </summary>
	public class Server
	{
		public const int DEFAULT_PORT = 40123;
		
		public static int Port {get;set;}
		Thread ListenerThread {get;set;}
		HttpListener ListenerHttp {get;set;}
		Manager DataManager {get;set;}
		
		public Server()
		{
			Server.Port = DEFAULT_PORT;
			
			ListenerHttp = new HttpListener();
			DataManager = new Manager();
		}
		
		public void StartServer() {
			Server.Port = DEFAULT_PORT;
			try {
				ListenerHttp.Prefixes.Add("http://*:" + Port + "/");
				ListenerHttp.Start();
				ListenerThread = new Thread(ManageRequests);
				ListenerThread.Start();
				System.Timers.Timer t = new System.Timers.Timer();
				t.Interval = 30 * 1000;
				t.Elapsed += delegate { 
					DataManager.SaveSession("Autosave");
				};
				t.Start();
			}
			catch {
				StopServer();
			}
		}
		
		public void StopServer() {
			if (ListenerHttp != null && ListenerHttp.IsListening) {
				ListenerHttp.Abort();
			}
			DataManager.SaveColorList();
		}
		
		public void ClearData() {
			DataManager.ClearUsersShapes();
			DataManager.SaveColorList();
		}
		
		void ManageRequests() {
			while (ListenerHttp.IsListening) {
				try {
					IAsyncResult context = ListenerHttp.BeginGetContext(new AsyncCallback(ManageRequestsAsync), ListenerHttp);
					context.AsyncWaitHandle.WaitOne();
				}
				catch {}
			}
		}
		
		void ManageRequestsAsync(IAsyncResult ar) {
			try {
				HttpListener listener = ar.AsyncState as HttpListener;
				HttpListenerContext context = listener.EndGetContext(ar);
				StreamReader sr = new StreamReader(context.Request.InputStream);
				NetworkObject NOReq = NetworkObject.Deserialize(sr.ReadToEnd());
				sr.Close();
				StreamWriter sw = new StreamWriter(context.Response.OutputStream);
				string Response = NetworkObject.Serialize(DataManager.CreateResponseFromRequest(NOReq));
				sw.Write(Response);
				sw.Close();
			}
			catch (Exception e) {
//				DataManager.SaveSession("General Crash");
				ApplicationLocation.Log.WriteLine(DateTime.Now.ToString(ApplicationLocation.DATE_TIME_STRING_MAIN) + ": " + e.ToString());
				ApplicationLocation.Log.Flush();
			}
		}
	}
}

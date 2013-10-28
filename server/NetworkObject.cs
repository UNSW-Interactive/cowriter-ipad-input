/*
 * Created by SharpDevelop.
 * User: froman
 * Date: 30.04.2012
 * Time: 11:21
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace CoWriterServer
{
	/// <summary>
	/// Description of NetworkObject.
	/// </summary>
	public class NetworkObject
	{

		const string NETWORK_CODE = @"NetworkCode";
		const string EXCHANGE_OBJECTS = @"ExchangeObjects";

		//REQUEST_STATE
		public const int REQUEST_STATE = 100;
		// 1: UDID (string)
		// ---
		// 1: STATE (int)
		// 2: COLOR (int)		
		
		public const int SEND_SHAPE = 101;
		// 1: UDID (string)
		// 2..n+1: list of shapes
		// ---

		public const int CLEAR_MY_SHAPES = 102;
		// 1: UDID (string)		
		
		public int NetworkCode {get;set;}
		public List<object> ExchangeObjects {get;set;}
		
		public NetworkObject()
		{
			ExchangeObjects = new List<object>();
		}
		
		public NetworkObject(int code) : this() {
			NetworkCode = code;
		}
		
		public static NetworkObject Deserialize(string message) {
			return JsonConvert.DeserializeObject<NetworkObject>(message);
		}
		
		public static string Serialize(NetworkObject no) {
			return JsonConvert.SerializeObject(no);
		}	
	}
}

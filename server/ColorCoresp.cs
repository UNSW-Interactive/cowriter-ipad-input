/*
 * Created by SharpDevelop.
 * User: Flaviu
 * Date: 2013-10-22
 * Time: 10:17
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Collections.Generic;
using System.Drawing;

namespace CoWriterServer
{
	/// <summary>
	/// Description of ColorCoresp.
	/// </summary>
	public class ColorCoresp
	{
		public SerializableDictionary<string, int> ColorList {get;set;}
		
		public ColorCoresp()
		{
			ColorList = new SerializableDictionary<string, int>();
		}
		
		public void AddPair(string udid, Color color) {
			AddPair(udid, color.ToArgb());
		}
		
		public void AddPair(string udid, int color) {
			ColorList.Add(udid, color);
		}
	}
}

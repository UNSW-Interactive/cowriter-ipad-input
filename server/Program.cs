/*
 * Created by SharpDevelop.
 * User: Flaviu
 * Date: 2013-05-29
 * Time: 14:05
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;

namespace CoWriterServer
{
	class Program
	{
		public static void Main(string[] args)
		{
			Server s = new Server();
			s.StartServer();
			
			ConsoleKeyInfo key;
			do {
				key = PrintMenu();
				switch (key.Key) {
					case ConsoleKey.F1: 
						s.ClearData();
						break;
					default:
						break;
				}
			} while (key.Key != ConsoleKey.Escape);
			s.ClearData();
			s.StopServer();
		}
		
		static ConsoleKeyInfo PrintMenu() {
			Console.Clear();
			Console.WriteLine("This is CoWriter Server");
			Console.WriteLine("This windows needs to stay open while you are running the iPad apps.");
			Console.WriteLine();
			Console.WriteLine("Last Operation At: {0}", DateTime.Now.ToLongTimeString());
			Console.WriteLine();
			Console.WriteLine("MENU:");
			Console.WriteLine("F1: Clear All Data and Start New Session");
			Console.WriteLine("ESC: Close the Server");
			
			return Console.ReadKey(true);
		}
	}
}
package com.animenight.igs 
{
	import profiler.Profiler;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class StaticProfiler 
	{
		private static var _profiler = new Profiler(32);
		
		public function StaticProfiler() 
		{
			
		}
		
		public static function GetInstance():Profiler
		{
			return _profiler;
		}
	}

}
package com.animenight.igs 
{
	import com.animenight.rantlite.Rant;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class Patterns 
	{
		private static var _instance:Patterns;
		
		public static function GetInstance():Patterns
		{
			if (_instance == undefined)
				_instance = new Patterns();
			return _instance;
		}
		
		public static function Run(name:String):String
		{
			return Patterns.GetInstance().Run(name);
		}
		
		public static function Username():String
		{
			var username = Patterns.GetInstance().Run('username');
			return username.replace(/\s/g, '');
		}
		
		private var _patterns:Object;
		private var _rant:Rant;
		
		[Embed(source = "../../../patterns/username.rant", mimeType = "application/octet-stream")]
		private var _usernamePattern:Class;
		[Embed(source = "../../../patterns/companies.rant", mimeType = "application/octet-stream")]
		private var _companyPattern:Class;
		[Embed(source = "../../../patterns/generic.rant", mimeType = "application/octet-stream")]
		private var _gameNamePattern:Class;
		[Embed(source = "../../../patterns/sequel.rant", mimeType = "application/octet-stream")]
		private var _gameSequelPattern:Class;
		
		public function Patterns()
		{
			_rant = new Rant();
			
			_patterns = {
				username: classToString(_usernamePattern),
				company: classToString(_companyPattern),
				gameName: classToString(_gameNamePattern),
				gameSequel: classToString(_gameSequelPattern)
			};
		}
		
		public function Run(name:String):String
		{
			if (!_patterns.hasOwnProperty(name))
				return "[Missing Pattern]";
			return _rant.Do(_patterns[name]);
		}
		
		private function classToString(c:Class):String
		{
			return (new c() as ByteArray).toString();
		}
	}

}
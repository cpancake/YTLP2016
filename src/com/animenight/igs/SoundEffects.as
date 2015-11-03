package com.animenight.igs 
{
	import flash.media.Sound;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class SoundEffects 
	{
		[Embed(source="../../../../resources/unable.mp3")]
		private static var _unableClass:Class;
		
		public static const UNABLE:Sound = new _unableClass();
	}

}
package com.animenight.igs.data.events 
{
	import com.animenight.igs.Player;
	import com.animenight.igs.data.DialogXmlManager;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class RetsupuraeEvent extends RandomEvent
	{
		[Embed(source="../../../../../../resources/events/retsupurae.xml", mimeType="application/octet-stream")]
		private const _dialogClass:Class;
		private var _dialogManager:DialogXmlManager;
		
		public function RetsupuraeEvent() 
		{
			var contentFile:ByteArray = new _dialogClass();
			var content:String = contentFile.readUTFBytes(contentFile.length);
			_dialogManager = new DialogXmlManager(new XML(content));
		}
		
		override public function Check(player:Player):Boolean 
		{
			// Subscribers > 5000, 5% chance
			return player.subs > 5000 && (Math.random() < 0.05);
		}
		
		override public function Start():void
		{
			
		}
	}

}
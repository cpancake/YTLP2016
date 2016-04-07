package com.animenight.igs.scenes.tabs 
{
	import com.animenight.igs.Player;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class VideoTab extends Sprite
	{
		private var _player:Player;
		
		public function VideoTab(player:Player) 
		{
			_player = player;
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event)
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function update()
		{
			
		}
	}

}
package com.animenight.igs 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class Background extends Sprite
	{
		[Embed(source="../../../../resources/background.jpg")]
		private static var _backgroundEmbed:Class;
		
		private var _background:Bitmap;
		
		public function Background() 
		{
			_background = new _backgroundEmbed() as Bitmap;
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function addedToStage(e:Event):void
		{
			_background.alpha = 0.4;
			this.addChild(_background);
			//draw();
			//this.addEventListener(Event.ENTER_FRAME, function(e:Event) { draw(); });
		}

		public function draw()
		{
			this.graphics.beginFill(0x99B2B7);
			this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this.graphics.endFill();
		}
	}

}
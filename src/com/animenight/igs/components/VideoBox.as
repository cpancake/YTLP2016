package com.animenight.igs.components
{
	import com.animenight.igs.Comments;
	import com.animenight.igs.GraphicsExtensions;
	import com.animenight.igs.Util;
	import com.animenight.igs.VideoProject;
	import com.animenight.igs.events.KillMeEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class VideoBox extends Sprite
	{
		public static const MESSAGE_BOX_WIDTH:Number = 600;
		public static const MESSAGE_BOX_HEIGHT:Number = 520;
		
		private var _video:VideoProject;
		
		public function VideoBox(video:VideoProject)
		{
			_video = video;
			draw();
			
			this.graphics.beginFill(0x999999);
			this.graphics.drawRect(1, 1, MESSAGE_BOX_WIDTH - 2, 30);
			this.graphics.endFill();
			
			var xButtonSprite:Sprite = new Sprite();
			var xButtonLabel:EasyTextField = new EasyTextField("X");
			xButtonLabel.bold = true;
			xButtonLabel.color = 0xffffff;
			xButtonLabel.size = 24;
			xButtonSprite.mouseEnabled = true;
			xButtonSprite.useHandCursor = true;
			xButtonSprite.mouseChildren = false;
			xButtonSprite.buttonMode = true;
			xButtonSprite.addChild(xButtonLabel);
			xButtonSprite.x = MESSAGE_BOX_WIDTH - xButtonLabel.textWidth - 10;
			xButtonSprite.y = -5;
			var that = this;
			xButtonSprite.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				var event:KillMeEvent = new KillMeEvent(KillMeEvent.KILL_ME);
				event.me = that;
				dispatchEvent(event);
			});
			this.addChild(xButtonSprite);
			
			var thumbnail:Bitmap = new Bitmap(_video.aiThumbnail.bitmapData);
			thumbnail.x = 20;
			thumbnail.y = 50;
			thumbnail.width = 560;
			thumbnail.height = 560 * 0.6;
			this.addChild(thumbnail);
			
			var titleLabel:EasyTextField = new EasyTextField(_video.name);
			titleLabel.bold = true;
			titleLabel.x = 20;
			titleLabel.y = thumbnail.y + thumbnail.height + 5;
			titleLabel.size = 18;
			titleLabel.width = thumbnail.width;
			titleLabel.wordWrap = true;
			this.addChild(titleLabel);
			
			var infoLabel:EasyTextField = new EasyTextField("");
			infoLabel.text = Util.formatNumber(video.views) + " views - by " + video.aiPlayer.name + ", " + Util.formatNumber(video.aiPlayer.subs) + " subscribers";
			infoLabel.color = 0xaaaaaa;
			infoLabel.x = 20;
			infoLabel.y = titleLabel.y + titleLabel.textHeight;
			this.addChild(infoLabel);
			
			var descLabel:EasyTextField = new EasyTextField("");
			if (video.aiDescription == null)
			{
				video.aiDescription = Comments.generate(200);
			}
			descLabel.text = video.aiDescription;
			descLabel.wordWrap = true;
			descLabel.width = thumbnail.width;
			descLabel.x = 20;
			descLabel.y = infoLabel.y + infoLabel.textHeight;
			this.addChild(descLabel);
		}
		
		private function draw():void
		{
			GraphicsExtensions.drawBorderedRect(this.graphics, 0, 0, MESSAGE_BOX_WIDTH, MESSAGE_BOX_HEIGHT, 0x000000, 0xffffff);
		}
	}

}
package com.animenight.igs.components 
{
	import com.animenight.igs.Util;
	import com.animenight.igs.GraphicsExtensions;
	import com.animenight.igs.VideoProject;
	import com.animenight.igs.events.MessageEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class TopVideo extends Sprite
	{
		private var _video:VideoProject;
		private var _bgColor:uint = 0xffffff;
		
		public function TopVideo(video:VideoProject) 
		{
			_video = video;
			
			draw();
			
			var thumbnail:Bitmap = _video.aiThumbnail;
			thumbnail.smoothing = true;
			thumbnail.x = 10;
			thumbnail.y = 10;
			thumbnail.width = 170;
			thumbnail.height = 102;
			this.addChild(_video.aiThumbnail);
			
			var title:EasyTextField = new EasyTextField("");
			title.width = 170;
			title.bold = true;
			title.x = 10;
			title.y = thumbnail.y + thumbnail.height + 5;
			title.update();
			title.multiline = true;
			var words = video.name.split(" ");
			for (var i = 0; i < words.length; i++)
			{
				var word:String = words[i];
				title.text += word + " ";
				title.update();
				if (title.textWidth > 170)
				{
					title.text = title.text.substr(0, title.text.length - word.length - 2);
					title.text += "\n";
					title.text += Util.trim(word) + " ";
					title.update();
				}
			}
			title.text = Util.maxLength(Util.trim(title.text), 56);
			title.bold = true;
			this.addChild(title);
			
			var info:EasyTextField = new EasyTextField("");
			info.size = 14;
			info.text = 
				"by " + _video.aiPlayer.name +
				"\n" + Util.formatNumber(_video.views) + " views";
			info.x = 10;
			info.y = title.y + title.textHeight;
			info.color = 0xaaaaaa;
			this.addChild(info);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
				_bgColor = 0xffffaa;
				draw();
			});
			
			this.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
				_bgColor = 0xffffff;
				draw();
			});
			
			this.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				var event:MessageEvent = new MessageEvent(MessageEvent.SHOW_VIDEO, true);
				event.video = _video;
				dispatchEvent(event);
			});
		}
		
		private function draw()
		{
			GraphicsExtensions.drawBorderedRect(this.graphics, 0, 0, TopVideosList.VIDEO_WIDTH, TopVideosList.VIDEO_HEIGHT, 0x000000, _bgColor);
		}
	}

}
package com.animenight.igs.components 
{
	import com.animenight.igs.GraphicsExtensions;
	import com.animenight.igs.VideoProject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class TopVideosList extends Sprite
	{
		public static const VIDEO_WIDTH:Number = 190;
		public static const VIDEO_PADDING:Number = 14;
		public static const VIDEO_HEIGHT:Number = 220;
		
		private var _videos:Array = [];
		
		public function TopVideosList() 
		{
			
		}
		
		public function update(topVideos:Array):void
		{
			_videos = [];
			this.removeChildren();
			
			var i:Number = 0;
			topVideos.forEach(function(v:VideoProject, _, __) {
				var currentX:Number = 1 + (i % 3) * (VIDEO_WIDTH + VIDEO_PADDING);
				var currentY:Number = 1 + Math.floor(i / 3) * (VIDEO_HEIGHT + VIDEO_PADDING);
				
				var video:TopVideo = new TopVideo(v);
				video.x = currentX;
				video.y = currentY;
				addChild(video);
				
				i++;
			});
		}
	}

}
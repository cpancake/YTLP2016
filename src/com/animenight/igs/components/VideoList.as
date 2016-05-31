package com.animenight.igs.components 
{
	import com.animenight.igs.VideoProject;
	import com.animenight.igs.VideoSeries;
	import com.animenight.igs.events.NewVideoEvent;
	import com.animenight.igs.scenes.GameScene;
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class VideoList extends Sprite
	{
		public var listWidth:Number;
		
		private var _videos:Array = [];
		private var _noVideos:EasyTextField;
		
		public function VideoList(width:Number, noVideosLabel:String = "No Videos") 
		{
			this.listWidth = width;
			this.graphics.beginFill(0xff0000, 0);
			this.graphics.drawRect(0, 0, width, 200);
			this.graphics.endFill();
			
			_noVideos = new EasyTextField(noVideosLabel);
			_noVideos.autoSize = TextFieldAutoSize.NONE;
			_noVideos.alignment = TextFormatAlign.CENTER;
			_noVideos.color = 0xaaaaaa;
			_noVideos.italics = true;
			_noVideos.width = width;
			_noVideos.height = 40;
			this.addChild(_noVideos);
		}
		
		public function addVideo(v:VideoProject)
		{
			if (_videos.filter(function(vf:VideoListItem, _, __) { return v.id == vf.id; }).length > 0)
			{
				return;
			}
			var item:VideoListItem = new VideoListItem(this, v);
			var that = this;
			item.addEventListener(NewVideoEvent.RELEASE_VIDEO, function(e:NewVideoEvent):void {
				that.removeVideo(e.video);
				e.video.day = GameScene.player.daysPlayed;
				var evt = new NewVideoEvent(NewVideoEvent.RELEASE_VIDEO);
				evt.video = e.video;
				that.dispatchEvent(evt);
			});
			_videos.push(item);
			this.addChild(item);
			updatePositions();
		}
		
		public function removeVideo(v:VideoProject)
		{
			var videoIndex:Number = -1;
			for (var i:Number = 0; i < _videos.length; i++)
			{
				if (_videos[i].id == v.id)
				{
					videoIndex = i;
					break;
				}
			}
			if (videoIndex == -1) return;
			this.removeChild(_videos[videoIndex]);
			_videos.splice(videoIndex, 1);
			updatePositions();
		}
		
		public function updatePositions()
		{
			var currentY:Number = 0;
			_videos = _videos.sortOn("day", Array.DESCENDING | Array.NUMERIC);
			for (var i = 0; i < _videos.length; i++)
			{
				var video:VideoListItem = _videos[i];
				video.y = currentY;
				currentY += video.displayHeight + 5;
			}
			
			_noVideos.visible = _videos.length == 0;
		}
		
		public function update()
		{
			_videos.forEach(function(v:VideoListItem, _, __) { v.update(); });
			updatePositions();
		}
		
		public function closeAllBut(id:String):void
		{
			_videos.forEach(function(v:VideoListItem, _, __) { 
				if (v.id != id)
				{
					v.contract();
				}
			});
		}
	}

}
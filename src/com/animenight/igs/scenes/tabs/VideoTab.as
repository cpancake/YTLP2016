package com.animenight.igs.scenes.tabs 
{
	import com.animenight.igs.Player;
	import com.animenight.igs.VideoProject;
	import com.animenight.igs.VideoSeries;
	import com.animenight.igs.components.EasyButton;
	import com.animenight.igs.components.EasyTextField;
	import com.animenight.igs.components.TabButton;
	import com.animenight.igs.components.VideoList;
	import com.animenight.igs.events.NewVideoEvent;
	import com.animenight.igs.events.UIEvent;
	import com.bit101.components.ScrollBar;
	import com.bit101.components.ScrollPane;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class VideoTab extends Sprite
	{
		private const SIDEBAR_WIDTH:Number = 150;
		private const SCROLLPANE_WIDTH:Number = 800 - (10 + SIDEBAR_WIDTH + 10) - 10;
		
		private var _player:Player;
		
		private var _seriesButton:EasyButton;
		private var _unreleasedButton:EasyButton;
		private var _publishedButton:EasyButton;
		
		private var _workOnVideoButton:EasyButton;
		
		private var _unreleasedScrollPane:ScrollPane;
		private var _unreleasedVideoList:VideoList;
		private var _releasedScrollPane:ScrollPane;
		private var _releasedVideoList:VideoList;
		private var _seriesScrollPane:ScrollPane;
		private var _seriesVideoList:VideoList;
		
		public function VideoTab(player:Player) 
		{
			_player = player;
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			_unreleasedVideoList = new VideoList(SCROLLPANE_WIDTH - 20);
			_releasedVideoList = new VideoList(SCROLLPANE_WIDTH - 20);
			_seriesVideoList = new VideoList(SCROLLPANE_WIDTH - 20);
			_workOnVideoButton = new EasyButton("Work On Video (1 Hour)");
			_workOnVideoButton.enabled = false;
			
			_unreleasedVideoList.addEventListener(NewVideoEvent.RELEASE_VIDEO, releaseVideo);
			_seriesVideoList.addEventListener(NewVideoEvent.NEW_VIDEO, function(e:NewVideoEvent):void {
				newVideo(e.video);
			});
		}
		
		private function addedToStage(e:Event)
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			_unreleasedButton = new EasyButton("Unreleased Videos");
			_unreleasedButton.enabled = false;
			_unreleasedButton.x = 10;
			_unreleasedButton.y = 10;
			_unreleasedButton.resizeBox(SIDEBAR_WIDTH, _unreleasedButton.height);
			_unreleasedButton.addEventListener(MouseEvent.CLICK, unreleasedButtonClicked);
			this.addChild(_unreleasedButton);
			
			_seriesButton = new EasyButton("Video Series");
			_seriesButton.enabled = true;
			_seriesButton.x = 10;
			_seriesButton.y = _unreleasedButton.y + _unreleasedButton.height + 10;
			_seriesButton.resizeBox(SIDEBAR_WIDTH, _unreleasedButton.height);
			_seriesButton.addEventListener(MouseEvent.CLICK, seriesButtonClicked);
			this.addChild(_seriesButton);
			
			_publishedButton = new EasyButton("Published Videos");
			_publishedButton.enabled = true;
			_publishedButton.x = 10;
			_publishedButton.y = _seriesButton.y + _seriesButton.height + 10;
			_publishedButton.resizeBox(SIDEBAR_WIDTH, _unreleasedButton.height);
			_publishedButton.addEventListener(MouseEvent.CLICK, publishedButtonClicked);
			this.addChild(_publishedButton);
			
			_workOnVideoButton.x = 10 + SIDEBAR_WIDTH + 10;
			_workOnVideoButton.y = 500 - _workOnVideoButton.height;
			_workOnVideoButton.resizeBox(SCROLLPANE_WIDTH, _workOnVideoButton.height);
			this.addChild(_workOnVideoButton);
			_workOnVideoButton.addEventListener(MouseEvent.CLICK, workOnVideo);
			
			_unreleasedScrollPane = new ScrollPane();
			_unreleasedScrollPane.x = 10 + SIDEBAR_WIDTH + 10;
			_unreleasedScrollPane.y = 10;
			_unreleasedScrollPane.width = SCROLLPANE_WIDTH;
			_unreleasedScrollPane.height = 500 - _unreleasedScrollPane.y - 10 - _workOnVideoButton.height - 10;
			_unreleasedScrollPane.drawBackground = false;
			_unreleasedScrollPane.autoHideScrollBar = true;
			this.addChild(_unreleasedScrollPane);
			
			_unreleasedVideoList.x = 0;
			_unreleasedVideoList.y = 1;
			_unreleasedVideoList.reversed = false;
			_unreleasedScrollPane.addChild(_unreleasedVideoList);
			
			_releasedScrollPane = new ScrollPane();
			_releasedScrollPane.x = 10 + SIDEBAR_WIDTH + 10;
			_releasedScrollPane.y = 10;
			_releasedScrollPane.width = SCROLLPANE_WIDTH;
			_releasedScrollPane.height = 500 - _releasedScrollPane.y - 10;
			_releasedScrollPane.drawBackground = false;
			_releasedScrollPane.autoHideScrollBar = true;
			this.addChild(_releasedScrollPane);
			
			_releasedVideoList.x = 0;
			_releasedVideoList.y = 1;
			_releasedScrollPane.visible = false;
			_releasedScrollPane.addChild(_releasedVideoList);
			
			_seriesScrollPane = new ScrollPane();
			_seriesScrollPane.x = 10 + SIDEBAR_WIDTH + 10;
			_seriesScrollPane.y = 10;
			_seriesScrollPane.width = SCROLLPANE_WIDTH;
			_seriesScrollPane.height = 500 - _seriesScrollPane.y - 10;
			_seriesScrollPane.drawBackground = false;
			_seriesScrollPane.autoHideScrollBar = true;
			this.addChild(_seriesScrollPane);
			
			_seriesVideoList.x = 0;
			_seriesVideoList.y = 1;
			_seriesScrollPane.visible = false;
			_seriesScrollPane.addChild(_seriesVideoList);
		}
		
		public function update()
		{
			_unreleasedVideoList.update();
			_releasedVideoList.update();
			_seriesVideoList.update();
		}
		
		public function newVideo(video:VideoProject):void
		{
			_unreleasedVideoList.addVideo(video);
			_workOnVideoButton.enabled = true;
			if (_unreleasedScrollPane != null)
			{
				_unreleasedScrollPane.update();
			}
		}
		
		public function newVideoSeries(series:VideoProject):void
		{
			_seriesVideoList.addVideo(series);
			if (_seriesScrollPane != null)
			{
				_seriesScrollPane.update();
			}
		}
		
		public function goToReleased():void
		{
			unreleasedButtonClicked(null);
		}
		
		public function goToSeries():void
		{
			seriesButtonClicked(null);
		}
		
		private function releaseVideo(e:NewVideoEvent):void
		{
			_releasedVideoList.addVideo(e.video);
			if (_releasedScrollPane != null)
			{
				_releasedScrollPane.update();
			}
		}
		
		private function seriesButtonClicked(e:MouseEvent):void
		{
			if (!_seriesButton.enabled) return;
			_publishedButton.enabled = true;
			_unreleasedButton.enabled = true;
			_seriesButton.enabled = false;
			
			_unreleasedScrollPane.visible = false;
			_releasedScrollPane.visible = false;
			_seriesScrollPane.visible = true;
			_workOnVideoButton.visible = _unreleasedScrollPane.visible;
		}
		
		private function unreleasedButtonClicked(e:MouseEvent):void
		{
			if (!_unreleasedButton.enabled) return;
			_unreleasedButton.enabled = false;
			_publishedButton.enabled = true;
			_seriesButton.enabled = true;
			
			_unreleasedScrollPane.visible = true;
			_releasedScrollPane.visible = false;
			_seriesScrollPane.visible = false;
			_workOnVideoButton.visible = _unreleasedScrollPane.visible;
		}
		
		private function publishedButtonClicked(e:MouseEvent):void
		{
			if (!_publishedButton.enabled) return;
			_publishedButton.enabled = false;
			_unreleasedButton.enabled = true;
			_seriesButton.enabled = true;
			
			_unreleasedScrollPane.visible = false;
			_releasedScrollPane.visible = true;
			_seriesScrollPane.visible = false;
			_workOnVideoButton.visible = _unreleasedScrollPane.visible;
		}
		
		private function workOnVideo(e:MouseEvent):void
		{
			if (_player.hoursLeft < 1)
			{
				var evt:UIEvent = new UIEvent(UIEvent.TIME_NEEDED);
				this.dispatchEvent(evt);
				return;
			}
			var video:VideoProject = _player.latestUnfinishedVideo;
			if (video.recordTime >= video.recordTimeSpecified)
			{
				video.editingTime++;
			}
			else
			{
				video.recordTime++;
			}
			_player.hoursLeft--;
			if (!_player.latestUnfinishedVideo)
				_workOnVideoButton.enabled = false;
			var evt:UIEvent = new UIEvent(UIEvent.SHOULD_UPDATE);
			this.dispatchEvent(evt);
		}
	}

}
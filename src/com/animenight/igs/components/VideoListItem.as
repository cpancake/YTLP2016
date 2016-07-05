package com.animenight.igs.components 
{
	import com.animenight.igs.GraphicsExtensions;
	import com.animenight.igs.Util;
	import com.animenight.igs.VideoProject;
	import com.animenight.igs.events.NewVideoEvent;
	import com.animenight.igs.events.UIEvent;
	import com.animenight.igs.scenes.GameScene;
	import com.animenight.igs.events.MessageChoiceEvent;
	import com.animenight.igs.events.MessageEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class VideoListItem extends Sprite
	{
		public static const HEIGHT:Number = 37;
		public static const DONE_COLOR:uint = 0xe6ffd1;
		
		[Embed(source = "../../../../../resources/minus_button.png")]
		private var _minusButtonImage:Class;
		[Embed(source = "../../../../../resources/plus_button.png")]
		private var _plusButtonImage:Class;
		
		private var _videoList:VideoList;
		
		private var _video:VideoProject;
		private var _released:Boolean = false;
		private var _expanded:Boolean = false;
		
		private var _backgroundColor:uint = 0xffffff;
		
		private var _listLabel:EasyTextField;
		private var _plusButton:Bitmap;
		private var _minusButton:Bitmap;
		private var _background:Sprite;
		private var _infoPanel:Sprite;
		private var _infoLabel:EasyTextField;
		private var _releaseVideoButton:EasyButton;
		
		public function VideoListItem(parent:VideoList, video:VideoProject) 
		{
			_videoList = parent;
			_video = video;
			_releaseVideoButton = new EasyButton("Release Video");
			
			this.graphics.beginFill(0xffffff, 0);
			this.graphics.drawRect(5, 0, parent.listWidth - 10, HEIGHT);
			this.graphics.endFill();
			
			this.mouseEnabled = true;
			this.useHandCursor = true;
			this.buttonMode = true;
			
			_plusButton = new _plusButtonImage();
			_minusButton = new _minusButtonImage();
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
				_backgroundColor = 0xffffaa;
				drawBackground();
			});
			
			this.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
				_backgroundColor = isVideoDone() ? DONE_COLOR : 0xffffff;
				drawBackground();
			});
			
			var that = this;
			this.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				if (_expanded)
				{
					contract();
					return;
				}
				else
				{
					_minusButton.visible = true;
					_plusButton.visible = false;
					_infoPanel.visible = true;
					_videoList.closeAllBut(_video.id);
				}
				
				_expanded = !_expanded;
				parent.updatePositions();
				that.dispatchEvent(new UIEvent(UIEvent.SHOULD_UPDATE));
			});
		}
		
		public function get id():String
		{
			return _video.id;
		}
		
		public function get day():Number
		{
			return _video.day;
		}
		
		public function get displayHeight():Number
		{
			if (_expanded) return this.height;
			return HEIGHT;
		}
		
		public function get expanded():Boolean
		{
			return _expanded;
		}
		
		public function contract():void
		{
			_minusButton.visible = false;
			_plusButton.visible = true;
			_infoPanel.visible = false;
			_expanded = false;
			_videoList.updatePositions();
			this.dispatchEvent(new UIEvent(UIEvent.SHOULD_UPDATE));
		}
		
		private function addedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			_infoPanel = new Sprite();
			_infoPanel.x = 10;
			_infoPanel.y = HEIGHT - 1;
			_infoPanel.visible = false;
			this.addChildAt(_infoPanel, 0);
			
			var infoPanelHeight:Number = 100;
			_infoLabel = new EasyTextField("Something!");
			_infoLabel.multiline = true;
			updateLabel();
			_infoLabel.x = 5;
			_infoLabel.y = 5;
			_infoPanel.addChild(_infoLabel);
			
			var height:Number = _infoLabel.textHeight + 10;
			if (_video.isSeries)
			{
				var newVideoButton:EasyButton = new EasyButton("New Video");
				newVideoButton.x = _videoList.listWidth - 20 - newVideoButton.width - 5;
				newVideoButton.y = 5;
				var that = this;
				newVideoButton.addEventListener(MouseEvent.CLICK, newSeriesVideo);
				_infoPanel.addChild(newVideoButton);
			}
			else if (!_video.released)
			{
				var scrapVideoButton:EasyButton = new EasyButton("Scrap Video");
				scrapVideoButton.x = _videoList.listWidth - 20 - scrapVideoButton.width - 5;
				scrapVideoButton.y = 5;
				var that = this;
				scrapVideoButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
					e.stopImmediatePropagation();
					var messageEvt:MessageEvent = new MessageEvent(MessageEvent.SHOW_CHOICE, true);
					messageEvt.title = "Scrap Video";
					messageEvt.message = "Are you sure you want to scrap this video?";
					messageEvt.buttons = ["Yes", "No"];
					messageEvt.receiver = that;
					that.addEventListener(MessageChoiceEvent.CHOICE, function scrapVideoChoice(e:MessageChoiceEvent):void {
						that.removeEventListener(MessageChoiceEvent.CHOICE, scrapVideoChoice);
						
						if (e.choice == "No") return;
						_videoList.removeVideo(_video);
						GameScene.player.videoProjects.splice(GameScene.player.videoProjects.indexOf(_video), 1);
						that.dispatchEvent(new UIEvent(UIEvent.SHOULD_UPDATE));
					});
					that.dispatchEvent(messageEvt);
				});
				_infoPanel.addChild(scrapVideoButton);
				
				_releaseVideoButton.x = _videoList.listWidth - 20 - _releaseVideoButton.width - 5;
				_releaseVideoButton.y = scrapVideoButton.y + scrapVideoButton.height + 10;
				_releaseVideoButton.enabled = isVideoDone();
				_releaseVideoButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
					e.stopImmediatePropagation();
					
					_video.released = true;
					var evt:NewVideoEvent = new NewVideoEvent(NewVideoEvent.RELEASE_VIDEO, true);
					evt.video = _video;
					that.dispatchEvent(evt);
				});
				
				height = _releaseVideoButton.y + _releaseVideoButton.height + 10;
				_infoPanel.addChild(_releaseVideoButton);
			}
			
			GraphicsExtensions.drawBorderedRect(_infoPanel.graphics, 0, 0, _videoList.listWidth - 20, height, 0x000000, 0xffffff);
			
			_background = new Sprite();
			drawBackground();
			this.addChildAt(_background, 1);
			
			_listLabel = new EasyTextField(_video.name);
			_listLabel.update();
			_listLabel.x = 10;
			_listLabel.y = (35 / 2) - _listLabel.height / 2;
			_listLabel.alignment = TextFormatAlign.LEFT;
			this.addChild(_listLabel);
			
			var title:String = _video.name;
			while (_listLabel.width > _videoList.listWidth - 10 - 45)
			{
				title = title.substring(0, title.length - 1);
				_listLabel.text = title + "...";
			}
			
			_plusButton.x = _videoList.listWidth - 5 - 4 - _plusButton.width;
			_plusButton.y = 3;
			this.addChild(_plusButton);
			
			_minusButton.x = _plusButton.x;
			_minusButton.y = _plusButton.y;
			_minusButton.visible = false;
			this.addChild(_minusButton);
		}
		
		public function update():void
		{
			_backgroundColor = isVideoDone() ? DONE_COLOR : 0xffffff;
			_releaseVideoButton.enabled = isVideoDone();
			updateLabel();
			drawBackground();
		}
		
		private function drawBackground():void
		{
			if (!_background) return;
			_background.graphics.clear();
			GraphicsExtensions.drawBorderedRect(_background.graphics, 5, 0, _videoList.listWidth - 10, HEIGHT, 0x000000, _backgroundColor);
		}
		
		private function updateLabel():void
		{
			if (_infoLabel == null) return;
			if (_video.isSeries)
			{
				var totalViews:Number = 0, totalIncome:Number = 0;
				_video.videos.forEach(function(v:VideoProject, _, __) { 
					totalViews += v.views;
					totalIncome += v.totalIncome;
				});
				_infoLabel.text = "Started " + Util.daysAgo(GameScene.player.daysPlayed, _video.day) + ".";
				_infoLabel.text += "\nNumber of Videos: " + _video.videos.length;
				_infoLabel.text += "\nTotal Views: " + Util.formatNumber(totalViews);
				_infoLabel.text += "\nTotal Income: " + Util.formatMoney(totalIncome);
			}
			else if (_video.released)
			{
				_infoLabel.text = "Released " + Util.daysAgo(GameScene.player.daysPlayed, _video.day) + ".\n";
				_infoLabel.text += "Views: " + Util.formatNumber(_video.views);
				_infoLabel.text += "\nIncome: $" + Util.formatMoney(_video.totalIncome);
				_infoLabel.text += "\nRating: +" + _video.likes + " / -" + _video.dislikes;
			}
			else
			{
				_infoLabel.text = 
					"Started " + Util.daysAgo(GameScene.player.daysPlayed, _video.day) + ".\n";
				var recordPercentage:Number = Math.floor((_video.recordTime / _video.recordTimeSpecified) * 100);
				_infoLabel.text += "Recording Time: " + _video.recordTime + "/" + _video.recordTimeSpecified +" hours (" + recordPercentage + "% done)\n";
				var editPercentage:Number = Math.floor((_video.editingTime / _video.editingTimeSpecified) * 100);
				_infoLabel.text += "Editing Time: " + _video.editingTime + "/" + _video.editingTimeSpecified +" hours (" + editPercentage + "% done)";
			}
		}
		
		private function newSeriesVideo(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			var messageEvt:MessageEvent = new MessageEvent(MessageEvent.SHOW_NEW_VIDEO, true);
			messageEvt.receiver = this;
			var name = _video.name + " Part " + (_video.videos.length + 1);
			messageEvt.placeholder = name;
			var that:VideoListItem = this;
			this.addEventListener(MessageChoiceEvent.CHOICE, function videoInput(e:MessageChoiceEvent):void {
				that.removeEventListener(MessageChoiceEvent.CHOICE, videoInput);
				if (e.choice == "Cancel") return;
				if (Util.trim(e.input) == '')
				{
					var evt:MessageEvent = new MessageEvent(MessageEvent.SHOW_MESSAGE, true);
					evt.title = "Error";
					evt.message = "You need to provide a name for your new video!";
					that.dispatchEvent(evt);
				}
				else
				{
					var video:VideoProject = new VideoProject(false, Util.trim(e.input), _video.game);
					video.id = Util.generateUniqueId(GameScene.player);
					video.day = GameScene.player.daysPlayed;
					video.inSeries = true;
					video.seriesNum = _video.videos.length + 1;
					video.recordTimeSpecified = e.recordTime;
					video.editingTimeSpecified = e.editTime;
					GameScene.player.videoProjects.push(video);
					_video.videos.push(video);
				
					var videoEvt:NewVideoEvent = new NewVideoEvent(NewVideoEvent.NEW_VIDEO, true);
					videoEvt.video = video;
					that.dispatchEvent(videoEvt);
					
					that.dispatchEvent(new UIEvent(UIEvent.SHOULD_UPDATE));
					that.dispatchEvent(new UIEvent(UIEvent.GO_TO_UNRELEASED, true));
				}
			});
			this.dispatchEvent(messageEvt);
			trace(messageEvt);
		}
		
		private function isVideoDone():Boolean
		{
			if (_video.isSeries || _video.released) return false;
			return _video.recordTime >= _video.recordTimeSpecified && _video.editingTime >= _video.editingTimeSpecified;
		}
	}
}
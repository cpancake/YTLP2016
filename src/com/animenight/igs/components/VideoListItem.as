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
		
		public function VideoListItem(parent:VideoList, video:VideoProject) 
		{
			_videoList = parent;
			_video = video;
			
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
				_backgroundColor = 0xffffff;
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
				var action:String = (currentStep() == "Editing" ? "Edit" : "Record");
				var actionButton:EasyButton = new EasyButton(action + " (1 Hour)");
				actionButton.x = _videoList.listWidth - 20 - actionButton.width - 5;
				actionButton.y = 5;
				var that = this;
				actionButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
					e.stopImmediatePropagation();
					if (GameScene.player.hoursLeft < 1)
					{
						that.dispatchEvent(new UIEvent(UIEvent.TIME_NEEDED, true));
						return;
					}
					nextStepButton.enabled = true;
					GameScene.player.hoursLeft -= 1;
					
					if (currentStep() == "Editing")
					{
						_video.editingTime++;
						GameScene.player.editExperience++;
					}
					else
					{
						_video.recordTime++;
						GameScene.player.recordExperience++;
					}
					
					that.dispatchEvent(new UIEvent(UIEvent.SHOULD_UPDATE, true));
					updateLabel();
				});
				_infoPanel.addChild(actionButton);
			
				var nextStepButton:EasyButton = new EasyButton("Start Editing");
				nextStepButton.x = _videoList.listWidth - 20 - nextStepButton.width - 5;
				nextStepButton.y = actionButton.y + actionButton.height + 10;
				nextStepButton.enabled = false;
				nextStepButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
					e.stopImmediatePropagation();
					if (_video.finishedRecording)
					{
						_video.released = true;
						_video.finishedEditing = true;
						var evt:NewVideoEvent = new NewVideoEvent(NewVideoEvent.RELEASE_VIDEO, true);
						evt.video = _video;
						that.dispatchEvent(evt);
					}
					else
					{
						_video.finishedRecording = true;
						actionButton.text = "Edit (1 Hour)";
						actionButton.x = _videoList.listWidth - 20 - actionButton.width - 5;
						nextStepButton.text = "Release";
						nextStepButton.enabled = false;
						nextStepButton.x = _videoList.listWidth - 20 - nextStepButton.width - 5;
					}
				});
				height = nextStepButton.y + nextStepButton.height + 10;
				_infoPanel.addChild(nextStepButton);
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
			updateLabel();
		}
		
		private function drawBackground():void
		{
			GraphicsExtensions.drawBorderedRect(_background.graphics, 5, 0, _videoList.listWidth - 10, HEIGHT, 0x000000, 0xffffff);
		}
		
		private function currentStep():String
		{
			if (_video.finishedRecording)
			{
				return "Editing";
			}
			return "Recording";
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
					"Started " + Util.daysAgo(GameScene.player.daysPlayed, _video.day) + ".\n" +
					"Stage: ";
				_infoLabel.text += currentStep();
				_infoLabel.text += "\nHours Spent Recording: " + _video.recordTime + "\n";
				_infoLabel.text += "Hours Spent Editing: " + _video.editingTime;
			}
		}
		
		private function newSeriesVideo(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			var messageEvt:MessageEvent = new MessageEvent(MessageEvent.SHOW_INPUT, true);
			messageEvt.message = "Please enter the name for part " + (_video.videos.length + 1) + " of your Let's Play of \"" + _video.game.name + "\"";
			messageEvt.title = "New Video";
			messageEvt.buttons = [ "OK", "Cancel" ];
			messageEvt.receiver = this;
			var name = _video.name + " Part " + (_video.videos.length + 1);
			messageEvt.placeholder = name;
			var that:VideoListItem = this;
			this.addEventListener(MessageChoiceEvent.CHOICE, function videoInput(e:MessageChoiceEvent):void {
				that.removeEventListener(MessageChoiceEvent.CHOICE, videoInput);
				if (e.choice == "Cancel") return;
				var evt:MessageEvent = new MessageEvent(MessageEvent.SHOW_MESSAGE, true);
				if (Util.trim(e.input) == '')
				{
					evt.title = "Error";
					evt.message = "You need to provide a name for your new video!";
				}
				else
				{
					var video:VideoProject = new VideoProject(false, Util.trim(e.input), _video.game);
					video.id = Util.generateUniqueId(GameScene.player);
					video.day = GameScene.player.daysPlayed;
					video.inSeries = true;
					video.seriesNum = _video.videos.length + 1;
					GameScene.player.videoProjects.push(video);
					_video.videos.push(video);
					evt.title = "Video Started";
					evt.message = "You've started your new video! Click on 'Unreleased Videos' to get to work on it.";
				
					var videoEvt:NewVideoEvent = new NewVideoEvent(NewVideoEvent.NEW_VIDEO, true);
					videoEvt.video = video;
					that.dispatchEvent(videoEvt);
					
					that.dispatchEvent(new UIEvent(UIEvent.SHOULD_UPDATE));
				}
				that.dispatchEvent(evt);
			});
			this.dispatchEvent(messageEvt);
		}
	}
}
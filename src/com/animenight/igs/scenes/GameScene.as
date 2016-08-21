package com.animenight.igs.scenes 
{
	import com.animenight.igs.*;
	import com.animenight.igs.components.ChangeIndicator;
	import com.animenight.igs.components.MessageBox;
	import com.animenight.igs.components.NewVideoBox;
	import com.animenight.igs.components.VideoBox;
	import com.animenight.igs.events.KillMeEvent;
	import com.animenight.igs.events.MessageChoiceEvent;
	import com.animenight.igs.events.MessageEvent;
	import com.animenight.igs.events.NewVideoEvent;
	import com.animenight.igs.events.UIEvent;
	import com.animenight.igs.scenes.tabs.*;
	import com.animenight.igs.components.StatBar;
	import com.animenight.igs.components.TabButton;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.VideoEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class GameScene extends Sprite
	{
		private var _daysLabel:TextField;
		private var _player:Player;
		private var _statBar:StatBar;
		private var _scheduleButton:TabButton;
		private var _tabButtons:Array = [];
		private var _tabs:Object;
		private var _tabBodyContainer:Sprite;
		private var _currentTab:String;
		private var _blackBox:Sprite;
		private var _messageBox:MessageBox;
		private var _videoBox:VideoBox;
		
		private var _changeIndicators:Array = [];
		
		private static var _staticPlayer:Player;
		public static function get player():Player
		{
			return _staticPlayer;
		}
		
		public function GameScene(player:Player) 
		{
			_staticPlayer = _player = player;
			this.mouseChildren = true;
			var that = this;
			
			_statBar = new StatBar(_player);
			_statBar.addEventListener(MouseEvent.CLICK, nextDay);
			
			_tabBodyContainer = new Sprite();
			_tabBodyContainer.x = 0;
			_tabBodyContainer.y = 60;
			
			_tabs = {
				'Player': new PlayerTab(_player),
				'Videos': new VideoTab(_player),
				'Games': new GamesTab(_player),
				'Community': new CommunityTab(_player)
			};
			
			for (var id:String in _tabs)
			{
				var value:DisplayObject = _tabs[id];
				value.addEventListener(UIEvent.SHOULD_UPDATE, function(e:UIEvent):void {
					updateUI();
				});
				value.addEventListener(UIEvent.CASH_CHANGE, cashChangeIndicatorEvent);
				value.addEventListener(UIEvent.TIME_NEEDED, function(e:UIEvent):void {
					_statBar.warnShadow();
					SoundEffects.UNABLE.play(0, 0);
				});
				value.addEventListener(UIEvent.GO_TO_UNRELEASED, function(e:UIEvent):void {
					switchTab("Videos");
					_tabs["Videos"].goToReleased();
				});
				value.addEventListener(UIEvent.GO_TO_SERIES, function(e:UIEvent):void {
					switchTab("Videos");
					_tabs["Videos"].goToSeries();
				});
				value.addEventListener(MessageEvent.SHOW_MESSAGE, showBoxEvent);
				value.addEventListener(MessageEvent.SHOW_CHOICE, showChoiceEvent);
				value.addEventListener(MessageEvent.SHOW_INPUT, showChoiceEvent);
				value.addEventListener(MessageEvent.SHOW_VIDEO, showVideoEvent);
				value.addEventListener(MessageEvent.SHOW_NEW_VIDEO, showNewVideoEvent);
				value.addEventListener(NewVideoEvent.NEW_VIDEO, function(e:NewVideoEvent) {
					_tabs["Videos"].newVideo(e.video);
				});
				value.addEventListener(NewVideoEvent.NEW_VIDEO_SERIES, function(e:NewVideoEvent) {
					_tabs["Videos"].newVideoSeries(e.videoSeries);
				});
			}
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.ENTER_FRAME, updateChangeIndicators);
		}
		
		public function switchTab(tab:String):void
		{
			var button = _tabButtons[["Player", "Videos", "Games", "Community"].indexOf(tab)];
			handleTabButton(button);
		}
		
		public function updateUI():void
		{
			_daysLabel.text = "Day " + (_player.daysPlayed + 1);
			_statBar.update();
			_tabs[_currentTab].update();
			for (var i = 0; i < _tabButtons.length; i++)
			{
				_tabButtons[i].update();
			}
		}
		
		private function addedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0xffffff);
			bg.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			bg.graphics.endFill();
			this.addChild(bg);
			
			this.addChild(_tabBodyContainer);
			
			this.addChild(_statBar);
			
			var daysFormat:TextFormat = new TextFormat('Open Sans', 24, 0x000000, true);
			daysFormat.align = TextFormatAlign.LEFT;
			
			_daysLabel = new TextField();
			_daysLabel.embedFonts = true;
			_daysLabel.autoSize = TextFieldAutoSize.LEFT;
			_daysLabel.defaultTextFormat = daysFormat;
			_daysLabel.x = 10;
			_daysLabel.y = 20 - (_daysLabel.height / 2) - 5;
			_daysLabel.selectable = false;
			this.addChild(_daysLabel);
			
			_tabButtons = [
				new TabButton('Player'), 
				new TabButton('Videos'), 
				new TabButton('Games'), 
				new TabButton('Community')
			];
			_tabButtons[0].active = true;
			_tabBodyContainer.addChild(_tabs['Player']);
			_currentTab = 'Player';
			
			for (var i = 0; i < _tabButtons.length; i++)
			{
				_tabButtons[i].y = 10;
				_tabButtons[i].x = 350 + (TabButton.WIDTH * i) + (i * 10);
				_tabButtons[i].addEventListener(MouseEvent.CLICK, tabButtonClick);
				this.addChild(_tabButtons[i]);
			}
			
			_blackBox = new Sprite();
			_blackBox.graphics.beginFill(0x000000, 1);
			_blackBox.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			_blackBox.graphics.endFill();
			_blackBox.alpha = 0;
			_blackBox.mouseChildren = true;
			_blackBox.mouseEnabled = false;
			this.addChild(_blackBox);
			
			this.updateUI();
		}
		
		private function tabButtonClick(e:MouseEvent):void
		{
			var button:TabButton = e.target as TabButton;
			handleTabButton(button);
		}
		
		private function handleTabButton(button:TabButton):void
		{
			button.badge = "";
			button.update();
			if (button.active) return;
			_tabButtons.forEach(function(e:TabButton, _, __) { e.SetActive(false); } );
			button.SetActive(true);
			if (!_tabs[button.text]) return;
			_tabs[button.text].update();
			_currentTab = button.text;
			_tabBodyContainer.removeChildren();
			_tabBodyContainer.addChild(_tabs[button.text]);
		}
		
		private function nextDay(e:MouseEvent):void
		{
			_blackBox.mouseEnabled = true;
			var that = this;
			var goingUp:Boolean = true;
			
			function fadeBlackBox(e:Event):void {
				if (goingUp)
				{
					_blackBox.alpha += 0.05;
					if (_blackBox.alpha >= 1)
					{
						processNextDay();
						goingUp = false;
					}
				}
				else
				{
					_blackBox.alpha -= 0.05;
					if (_blackBox.alpha <= 0)
					{
						_blackBox.alpha = 0;
						_blackBox.mouseEnabled = false;
						that.removeEventListener(Event.ENTER_FRAME, fadeBlackBox);
					}
				}
			}
			
			this.addEventListener(Event.ENTER_FRAME, fadeBlackBox);
		}
		
		private function processNextDay():void
		{
			// actually do next day stuff
			_player.daysPlayed++;
			_player.hoursLeft = _player.HOURS_AVAILABLE;
			if (_player.hasJob)
			{
				if (_player.workedToday == false)
					_player.workPerformance -= _player.jobPerformanceDecrease();
				_player.workedToday = false;
				// you're fired!
				if (_player.workPerformance <= 0)
				{
					_player.hasJob = false;
					_player.workPerformance = 100;
					_player.workPosition = 0;
					showMessage("Fired!", "Due to your poor work performance, you've been fired!");
				}
			}
			// weekly expenses
			if (_player.daysPlayed > 1 && (_player.daysPlayed + 1) % 7 == 0)
			{
				_player.cash -= _player.weeklyExpenses;
				addCashChangeIndicator( -_player.weeklyExpenses, "Weekly Expenses");
				
				if (_player.cash < 0)
				{
					showMessage("You Need Cash!", "You're low on cash. If you get below $-100, you'll go bankrupt!");
				}
				if (_player.cash < -100)
				{
					showMessage("Game Over!", "It's over bud.");
				}
			}
			// release new game
			if (_player.games.hasNewGame(_player.daysPlayed))
			{
				var btn:TabButton = _tabButtons[2];
				var num:Number;
				if (btn.badge != "")
				{
					num = parseInt(btn.badge, 10);
					if (num != NaN)
						btn.badge = num + 1 + "";
					else
						btn.badge = "1";
				}
				else
					btn.badge = "1";
			}
			var prevSubs:Number = _player.subs;
			
			// calculate videos
			var videoIncome:Number = 0;
			var newViews:Number = 0;
			_player.videoProjects.forEach(function(v:VideoProject, _, __) {
				var videoViews:Number = v.views;
				videoIncome += v.calculateDay(_player);
				newViews += v.views - videoViews;
			});
			if(videoIncome > 0)
				addCashChangeIndicator(videoIncome, "Video Income");
			
			var newSubs:Number = _player.subs - prevSubs;
			_player.viewHistory.push(newViews);
			_player.subscriberHistory.push(newSubs);
			
			_player.aiPlayers.calculateDay();
				
			updateUI();
		}
		
		private function addCashChangeIndicator(cashAmount:Number, cashSource:String):void
		{
			var plus = cashAmount < 0 ? "-" : "+";
			var indicator:ChangeIndicator = new ChangeIndicator(
				cashSource + ": " + plus + "$" + Math.abs(cashAmount), 
				cashAmount < 0 ? 0xff0000 : 0x00ff00);
			indicator.x = this.stage.stageWidth - 10;
			indicator.y = _statBar.topPosition - 25 - _changeIndicators.length * indicator.textHeight;
			_changeIndicators.push(indicator);
			this.addChild(indicator);
			this.removeChild(_blackBox);
			this.addChild(_blackBox);
		}
		
		private function cashChangeIndicatorEvent(e:UIEvent):void
		{
			addCashChangeIndicator(e.cashAmount, e.cashSource);
		}
		
		private function updateChangeIndicators(e:Event):void
		{
			var deleteIndicators:Array = [];
			
			for (var i = 0; i < _changeIndicators.length; i++)
			{
				var indicator:ChangeIndicator = _changeIndicators[i];
				indicator.timer = indicator.timer - 2;
				indicator.y = _statBar.topPosition - 25 - i * indicator.textHeight;
				if (indicator.timer < 0)
				{
					this.removeChild(indicator);
					deleteIndicators.push(indicator);
				}
			}
			
			for (var i = 0; i < deleteIndicators.length; i++)
			{
				_changeIndicators.splice(_changeIndicators.indexOf(deleteIndicators[i]), 1);
			}
		}
		
		private function showMessage(title:String, message:String):void
		{
			var msgBox = new MessageBox(title, message);
			var that = this;
			msgBox.addEventListener(KillMeEvent.KILL_ME, function(e:KillMeEvent):void {
				that.removeChild(e.me);
			});
			msgBox.addEventListener(MessageChoiceEvent.CHOICE, function(_e:MessageChoiceEvent):void {
				that.removeChild(msgBox);
			});
			this.addChild(msgBox);
			
			// make sure _blackBox is on top of all children
			this.removeChild(_blackBox);
			this.addChild(_blackBox);
		}
		
		private function showBoxEvent(e:MessageEvent):void
		{
			showMessage(e.title, e.message);
		}
		
		private function showChoiceEvent(e:MessageEvent):void
		{
			var that = this;
			var messageBox:MessageBox = new MessageBox(e.title, e.message, e.buttons, e.type == MessageEvent.SHOW_INPUT);
			messageBox.placeholder = e.placeholder;
			messageBox.addEventListener(MessageChoiceEvent.CHOICE, function(_e:MessageChoiceEvent):void {
				that.removeChild(messageBox);
				var evt = _e.clone();
				evt.choice = _e.choice;
				evt.input = _e.input;
				if(e.receiver)
					e.receiver.dispatchEvent(evt);
			});
			this.addChild(messageBox);
		}
		
		private function showVideoEvent(e:MessageEvent):void
		{
			if (_videoBox != null)
			{
				this.removeChild(_videoBox);
			}
			var videoBox:VideoBox = new VideoBox(e.video);
			videoBox.x = 400 - (VideoBox.MESSAGE_BOX_WIDTH / 2);
			videoBox.y = 300 - (VideoBox.MESSAGE_BOX_HEIGHT / 2);
			_videoBox = videoBox;
			_videoBox.addEventListener(KillMeEvent.KILL_ME, function(e:KillMeEvent):void {
				removeChild(e.me);
				_videoBox = null;
			});
			this.addChild(videoBox);
			
			// make sure _blackBox is on top of all children
			this.removeChild(_blackBox);
			this.addChild(_blackBox);
		}
		
		private function showNewVideoEvent(e:MessageEvent):void
		{
			var that = this;
			var messageBox:NewVideoBox = new NewVideoBox();
			messageBox.placeholder = e.placeholder;
			messageBox.addEventListener(MessageChoiceEvent.CHOICE, function(_e:MessageChoiceEvent):void {
				that.removeChild(messageBox);
				var evt:MessageChoiceEvent = _e.clone() as MessageChoiceEvent;
				evt.choice = _e.choice;
				evt.input = _e.input;
				evt.recordTime = _e.recordTime;
				evt.editTime = _e.editTime;
				if(e.receiver)
					e.receiver.dispatchEvent(evt);
			});
			this.addChild(messageBox);
		}
		
		/*
		 * Debugger functions
		*/
		public function dcash(money:int):void
		{
			_player.cash = money;
			updateUI();
		}
		
		public function dsubs(subs:int):void
		{
			_player.subs = subs;
			updateUI();
		}
		
		public function dgame(aaa:Boolean):void
		{
			_player.games.generateGame(aaa, _player.daysPlayed, true);
			var btn:TabButton = _tabButtons[2];
			var num:Number;
			if (btn.badge != "")
			{
				num = parseInt(btn.badge, 10);
				if (num != NaN)
					btn.badge = num + 1 + "";
				else
					btn.badge = "1";
			}
			else
				btn.badge = "1";
			updateUI();
		}
		
		public function dgamepop(index:Number):Number
		{
			return _player.games.allGames[index].getPopularity(_player.daysPlayed);
		}
		
		public function dvideo():void
		{
			var project:VideoProject = new VideoProject(false, "Test Video", _player.games.allGames[0]);
			project.id = Util.generateUniqueId(_player);
			project.day = _player.daysPlayed;
			_player.videoProjects.push(project);
			
			_tabs["Videos"].newVideo(project);
		}
		
		public function dthumb(isLP:Boolean, number:Number = 1):void
		{
			var thumb:Bitmap = ThumbnailGenerator.generateThumbnail(isLP, number);
			thumb.y = 300;
			this.addChild(thumb);
		}
		
		public function dmodel():String
		{
			return JSON.stringify(player.viewerModel);
		}
		
		public function dcomment(targetLength:Number = 100):String
		{
			return Comments.generate(targetLength);
		}
	}

}
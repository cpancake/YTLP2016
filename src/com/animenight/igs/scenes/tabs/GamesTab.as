package com.animenight.igs.scenes.tabs 
{
	import com.animenight.igs.REVIEW_VIDEO_TYPE;
	import com.animenight.igs.VideoProject;
	import com.animenight.igs.components.EasyButton;
	import com.animenight.igs.components.EasyTextField;
	import com.animenight.igs.components.LineChart;
	import com.animenight.igs.components.NewVideoBox;
	import com.animenight.igs.data.Genres;
	import com.animenight.igs.events.MessageChoiceEvent;
	import com.animenight.igs.events.MessageEvent;
	import com.animenight.igs.events.NewVideoEvent;
	import com.animenight.igs.events.UIEvent;
	import com.animenight.igs.Game;
	import com.animenight.igs.Player;
	import com.animenight.igs.Util;
	import com.animenight.igs.VideoSeries;
	import com.animenight.igs.VideoProject;
	import com.animenight.igs.scenes.GameScene;
	import com.bit101.components.List;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class GamesTab extends Sprite
	{
		private var _onStage:Boolean = false;
		private var _player:Player;
		private var _currentGameContainer:Sprite;
		private var _games:List;
		private var _gameQuality:Sprite;
		private var _currentGame:Game;
		private var _currentlyCreatingLPSeries:Boolean = false;
		
		private var _title:EasyTextField;
		private var _company:EasyTextField;
		private var _price:EasyTextField;
		private var _daysAgo:EasyTextField;
		private var _qualityLabel:EasyTextField;
		private var _buyButton:EasyButton;
		private var _reviewButton:EasyButton;
		private var _videoButton:EasyButton;
		private var _popChart:LineChart = null;
		
		[Embed(source="../../../../../../resources/star.png")]
		private var _starClass:Class;
		[Embed(source="../../../../../../resources/star_dim.png")]
		private var _starDimClass:Class;
		
		private var _star:Bitmap = new _starClass();
		private var _starDim:Bitmap = new _starDimClass();
		
		public function get currentGame():Game
		{
			return _currentGame;
		}
		
		public function get currentlyCreatingLPSeries():Boolean
		{
			return _currentlyCreatingLPSeries;
		}
		
		public function GamesTab(player:Player) 
		{
			_player = player;
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function update():void
		{
			if (!_onStage) return;
			var _currentGameCount = _games.items.length;
			_currentGameContainer.removeChildren();
			if (!_currentGame)
				_currentGame = _player.games.allGames[0];
			var game:Game = _currentGame;
			_currentGameContainer.addChild(game.poster);
			updateGame(game);
			
			_games.removeAll();
			var allGames:Array = _player.games.allGames;
			for (var i = 0; i < allGames.length; i++)
			{
				var game:Game = allGames[i];
				_games.addItem({
					label: (game.owned ? '[OWNED] ' : '') + Util.trim(game.name),
					data: i.toString()
				});
			}
			if(_currentGameCount - _games.items.length > 0)
				_games.selectedIndex = 0;
		}
		
		private function addedToStage(e:Event):void
		{
			_onStage = true;
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			_currentGameContainer = new Sprite();
			_currentGameContainer.x = 20;
			_currentGameContainer.y = 20;
			this.addChild(_currentGameContainer);
			
			_title = new EasyTextField("");
			_title.bold = true;
			_title.size = 20;
			_title.x = 200;
			_title.y = 20;
			this.addChild(_title);
			
			_company = new EasyTextField("");
			_company.size = 16;
			_company.x = 200;
			_company.y = _title.y + _title.textHeight;
			this.addChild(_company);
			
			_price = new EasyTextField("");
			_price.size = 16;
			_price.x = 200;
			this.addChild(_price);
			
			_daysAgo = new EasyTextField("");
			_daysAgo.size = 16;
			_daysAgo.x = 200;
			this.addChild(_daysAgo);
			
			_games = new List();
			_games.defaultColor = 0xffffff;
			_games.x = 540;
			_games.y = 20;
			_games.width = 250;
			_games.height = 400;
			_games.setSize(250, 400);
			_games.selectedIndex = 0;
			_games.addEventListener(Event.SELECT, gameSelectionChanged);
			this.addChild(_games);
			
			_qualityLabel = new EasyTextField("Reviews:");
			_qualityLabel.x = 200;
			_qualityLabel.y = 20;
			_qualityLabel.size = 16;
			this.addChild(_qualityLabel);
			
			_gameQuality = new Sprite();
			_gameQuality.x = 540;
			this.addChild(_gameQuality);
			
			_buyButton = new EasyButton("Buy Game");
			_buyButton.x = 200;
			_buyButton.addEventListener(MouseEvent.CLICK, buyGame);
			this.addChild(_buyButton);
			
			_reviewButton = new EasyButton("Start Review");
			_reviewButton.x = 200;
			_reviewButton.addEventListener(MouseEvent.CLICK, makeReview);
			this.addChild(_reviewButton);
			
			_videoButton = new EasyButton("Start LP Series");
			_videoButton.x = _reviewButton.x + _reviewButton.width + 10;
			_videoButton.addEventListener(MouseEvent.CLICK, makeVideo);
			this.addChild(_videoButton);
			
			update();
		}
		
		private function gameSelectionChanged(e:Event):void
		{
			_currentGameContainer.removeChildren();
			var game:Game = _player.games.allGames[_games.selectedItem.data];
			updateGame(game);
			_currentGameContainer.addChild(game.poster);
		}
		
		private function buyGame(e:MouseEvent):void
		{
			if (_currentGame.price > _player.cash)
				return;
			_player.cash -= _currentGame.price;
			_currentGame.owned = true;
			var changeEvt:UIEvent = new UIEvent(UIEvent.CASH_CHANGE);
			changeEvt.cashAmount = -_currentGame.price;
			changeEvt.cashSource = "Game";
			this.dispatchEvent(changeEvt);
			this.dispatchEvent(new UIEvent(UIEvent.SHOULD_UPDATE));
		}
		
		private function makeReview(e:MouseEvent):void
		{
			var messageEvt:MessageEvent = new MessageEvent(MessageEvent.SHOW_NEW_VIDEO);
			messageEvt.receiver = this;
			var name = _currentGame.name + " Review";
			messageEvt.placeholder = name;
			var that:GamesTab = this;
			this.addEventListener(MessageChoiceEvent.CHOICE, function reviewInput(e:MessageChoiceEvent):void {
				that.removeEventListener(MessageChoiceEvent.CHOICE, reviewInput);
				if (e.choice == "Cancel") return;
				if (Util.trim(e.input) == '')
				{
					var evt:MessageEvent = new MessageEvent(MessageEvent.SHOW_MESSAGE);
					evt.title = "Error";
					evt.message = "You need to provide a name for your review!";
					that.dispatchEvent(evt);
				}
				else
				{
					var video:VideoProject = new VideoProject(true, Util.trim(e.input), _currentGame);
					video.id = Util.generateUniqueId(_player);
					video.day = GameScene.player.daysPlayed;
					video.recordTimeSpecified = Math.ceil(e.recordTime);
					video.editingTimeSpecified = Math.ceil(e.editTime);
					_player.videoProjects.push(video);
				
					var videoEvt:NewVideoEvent = new NewVideoEvent(NewVideoEvent.NEW_VIDEO);
					videoEvt.video = video;
					that.dispatchEvent(videoEvt);
					
					_currentGame.reviewed = true;
					_reviewButton.enabled = false;
					that.dispatchEvent(new UIEvent(UIEvent.GO_TO_UNRELEASED));
				}
			});
			this.dispatchEvent(messageEvt);
		}
		
		private function makeVideo(e:MouseEvent):void
		{
			_currentlyCreatingLPSeries = true;
			var messageEvt:MessageEvent = new MessageEvent(MessageEvent.SHOW_INPUT);
			messageEvt.message = "Please enter the name for a new video series based on \"" + _currentGame.name + "\"";
			messageEvt.title = "New Video";
			messageEvt.buttons = [ "OK", "Cancel" ];
			messageEvt.receiver = this;
			var placeholder = "Let's Play " + _currentGame.name;
			var num = 1;
			while (_player.series.filter(function(v, _, __) { return v.name == placeholder; } ).length > 0)
			{
				placeholder = "Let's Play " + _currentGame.name + " " + Util.stringMult("Again", num);
				num++;
			}
			messageEvt.placeholder = placeholder;
			var that = this;
			this.addEventListener(MessageChoiceEvent.CHOICE, function videoInput(e:MessageChoiceEvent):void {
				that.removeEventListener(MessageChoiceEvent.CHOICE, videoInput);
				if (e.choice == "Cancel") return;
				
				if (Util.trim(e.input) == '')
				{
					var evt:MessageEvent = new MessageEvent(MessageEvent.SHOW_MESSAGE);
					evt.title = "Error";
					evt.message = "You need to provide a name for your new series!";
					that.dispatchEvent(evt);
				}
				else
				{
					var series:VideoProject = new VideoProject(false, Util.trim(e.input), _currentGame);
					series.isSeries = true;
					series.day = _player.daysPlayed;
					series.id = Util.generateUniqueId(_player);
					_player.series.push(series);
					
					var videoEvt:NewVideoEvent = new NewVideoEvent(NewVideoEvent.NEW_VIDEO_SERIES);
					videoEvt.videoSeries = series;
					that.dispatchEvent(videoEvt);
					
					_currentGame.lped = true;
					_videoButton.enabled = false;
					that.dispatchEvent(new UIEvent(UIEvent.GO_TO_SERIES));
				}
			});
			
			this.dispatchEvent(messageEvt);
		}
		
		private function updateGame(game:Game):void
		{
			game.poster.smoothing = true;
			game.poster.width = 171;
			game.poster.height = 237;
			
			_title.width = 320;
			_title.wordWrap = true;
			_title.text = Util.trim(game.name);
			_title.update();
			_company.y = _title.y + _title.textHeight;
			_company.width = 320;
			_company.wordWrap = true;
			_company.text = game.company + (game.tripleA ? " (AAA)" : " (Indie)");
			_company.update();
			_price.text = "Price: $" + game.price + " / Genre: " + Genres.OBJECT[game.genre].name;
			_price.width = 320;
			_price.wordWrap = true;
			_price.y = _company.y + _company.textHeight;
			_price.update();
			_daysAgo.text = "Released " + Util.daysAgo(_player.daysPlayed, game.dayReleased) + ".";
			_daysAgo.y = _price.y + _price.textHeight;
			_daysAgo.update();
			
			_qualityLabel.y = _daysAgo.y + _daysAgo.textHeight;
			
			_gameQuality.x = _qualityLabel.x + _qualityLabel.textWidth + 5;
			_gameQuality.y = _qualityLabel.y + 1;
			_gameQuality.graphics.clear();
			_gameQuality.graphics.beginBitmapFill(_starDim.bitmapData, null, true, false);
			_gameQuality.graphics.drawRect(0, 0, 5 * _starDim.width, _starDim.height);
			_gameQuality.graphics.endFill();
			_gameQuality.graphics.beginBitmapFill(_star.bitmapData, null, true, false);
			_gameQuality.graphics.drawRect(0, 0, game.quality * _star.width, _star.height);
			_gameQuality.graphics.endFill();
			
			_gameQuality.width = 5 * _starDim.width / 2;
			_gameQuality.height = _starDim.height / 2;
			
			if (game.owned)
			{
				_buyButton.enabled = false;
				_buyButton.alpha = 0;
				_videoButton.y = _qualityLabel.y + _qualityLabel.height;
				_videoButton.alpha = 1;
				_videoButton.enabled = true;
				_reviewButton.y = _videoButton.y;
				_reviewButton.alpha = 1;
				_reviewButton.enabled = !game.reviewed;
				_videoButton.enabled = !game.lped;
			}
			else
			{
				_buyButton.alpha = 1;
				_buyButton.y = _qualityLabel.y + _qualityLabel.height;
				_buyButton.enabled = game.price <= _player.cash;
				_videoButton.enabled = false;
				_videoButton.alpha = 0;
				_reviewButton.alpha = 0;
				_reviewButton.enabled = false;
			}
			
			_currentGame = game;
		}
	}
}
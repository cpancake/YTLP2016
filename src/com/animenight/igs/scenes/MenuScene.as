package com.animenight.igs.scenes 
{
	import com.animenight.igs.GraphicsExtensions;
	import com.animenight.igs.Patterns;
	import com.animenight.igs.Player;
	import com.animenight.igs.Util;
	import com.animenight.igs.components.EasyButton;
	import com.animenight.igs.components.EasyInputField;
	import com.animenight.igs.components.EasyTextField;
	import com.animenight.igs.events.UIEvent;
	import com.tweenman.Easing;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class MenuScene extends Sprite
	{
		[Embed(source = "../../../../../resources/money.png")]
		private var _cashIconEmbed:Class;
		
		[Embed(source="../../../../../resources/logo.png")]
		private var _logoEmbed:Class;
		
		[Embed(source="../../../../../resources/an logo.png")]
		private var _anLogoEmbed:Class;
		
		[Embed(source="../../../../../resources/an logo bw.png")]
		private var _anLogoBWEmbed:Class;
		
		private const _youtubeRed:uint = 0xcd201f;
		
		private var _cashBackground:Sprite;
		private var _cashIcon:Bitmap;
		private var _logo:Bitmap;
		private var _anLogo:Sprite;
		private var _anLogoBW:Sprite;
		private var _cashChildren:Array = [];
		private var _cashSpeed:Array = [];
		private var _menuSprite:Sprite;
		private var _creditSprite:Sprite;
		private var _newLoadGameSprite:Sprite;
		private var _newGameSprite:Sprite;
		private var _isNewGame:Boolean = false;
		private var _playerSlot:Number = 0;
		private var _loadingText:EasyTextField;
		
		public function MenuScene() 
		{
			_cashBackground = new Sprite();
			_cashBackground.graphics.beginFill(0xdddddd);
			_cashBackground.graphics.drawRect(0, 0, 800, 600);
			_cashBackground.graphics.endFill();
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.ENTER_FRAME, updateBackground);
		}
	
		private function addedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			this.addChild(_cashBackground);
			
			_cashIcon = new _cashIconEmbed() as Bitmap;
			for (var i:Number = 0; i < 40; i++)
			{
				var icon:Sprite = new Sprite();
				icon.graphics.beginBitmapFill(_cashIcon.bitmapData);
				icon.graphics.drawRect(0, 0, _cashIcon.width, _cashIcon.height);
				icon.graphics.endFill();
				
				icon.x = Util.randomRange(icon.width, 800);
				icon.y = Util.randomRange(icon.height, 600);
				icon.rotation = Math.random() * 360;
				
				var depth:Number = Util.randomRange(0.2, 1);
				icon.scaleX = icon.scaleY = icon.scaleZ = depth;
				icon.alpha = depth;
				
				_cashBackground.addChild(icon);
				_cashChildren.push(icon);
				_cashSpeed.push(depth);
			}
			
			_logo = new _logoEmbed() as Bitmap;
			this.addChild(_logo);
			
			_menuSprite = new Sprite();
			this.addChild(_menuSprite);
			
			_loadingText = new EasyTextField("Loading...");
			_loadingText.size = 72;
			_loadingText.alpha = 0.5;
			_loadingText.update();
			_loadingText.x = 400 - (_loadingText.textWidth / 2);
			_loadingText.y = 300 - (_loadingText.textHeight / 2);
			_loadingText.visible = false;
			this.addChild(_loadingText);
			
			GraphicsExtensions.drawRoundedBorderedRect(_menuSprite.graphics, 250, 235, 300, 280, 0x000000, 0xeeeeee);
			
			var newGameButton:EasyButton = new EasyButton("New Game");
			newGameButton.resizeBox(250, 45);
			newGameButton.x = 275;
			newGameButton.y = 235 + 20;
			_menuSprite.addChild(newGameButton);
			newGameButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				_isNewGame = true;
				transitionScreens(_menuSprite, _newLoadGameSprite);
			});
			
			var loadGameButton:EasyButton = new EasyButton("Load Game");
			loadGameButton.resizeBox(250, 45);
			loadGameButton.x = 275;
			loadGameButton.y = newGameButton.y + 45 + 20;
			_menuSprite.addChild(loadGameButton);
			loadGameButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				_isNewGame = false;
				transitionScreens(_menuSprite, _newLoadGameSprite);
			});
			
			var creditButton:EasyButton = new EasyButton("Credits");
			creditButton.resizeBox(250, 45);
			creditButton.x = 275;
			creditButton.y = loadGameButton.y + 45 + 20;
			_menuSprite.addChild(creditButton);
			creditButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				transitionScreens(_menuSprite, _creditSprite);
			});
			
			var logoBitmap:Bitmap = new _anLogoEmbed() as Bitmap;
			var logoBWBitmap:Bitmap = new _anLogoBWEmbed() as Bitmap;
			
			_anLogo = new Sprite();
			_anLogo.graphics.beginBitmapFill(logoBitmap.bitmapData);
			_anLogo.graphics.drawRect(0, 0, logoBitmap.width, logoBitmap.height);
			_anLogo.graphics.endFill();
			
			_anLogoBW = new Sprite();
			_anLogoBW.graphics.beginBitmapFill(logoBWBitmap.bitmapData);
			_anLogoBW.graphics.drawRect(0, 0, logoBWBitmap.width, logoBWBitmap.height);
			_anLogoBW.graphics.endFill();
			_anLogoBW.alpha = 0.5;
			_anLogo.visible = false;
			_anLogo.mouseEnabled = true;
			_anLogo.useHandCursor = true;
			_anLogo.buttonMode = true;
			
			_anLogo.x = _anLogoBW.x = creditButton.x;
			_anLogo.y = _anLogoBW.y = creditButton.y + 45 + 20;
			
			_anLogoBW.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
				_anLogo.visible = true;
				_anLogoBW.visible = false;
			});
			
			_anLogo.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent): void {
				_anLogo.visible = false;
				_anLogoBW.visible = true;
			});
			
			_anLogo.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				var request:URLRequest = new URLRequest("https://www.anime-night.com/");
				navigateToURL(request, "_blank");
			});
			
			_menuSprite.addChild(_anLogo);
			_menuSprite.addChild(_anLogoBW);
			
			_creditSprite = new Sprite();
			GraphicsExtensions.drawRoundedBorderedRect(_creditSprite.graphics, 250, 235, 300, 280, 0x000000, 0xeeeeee);
			_creditSprite.x = 800;
			
			var creditLabel:EasyTextField = new EasyTextField("Developed by Anime Night.\n\n\"Kawai Kitsune\", \"Chipper Doodle v2\",\nand \"Disco Medusae\" by Kevin MacLeod,\nused under a CC-BY license.\n\n\"Close My Mouth\" by Silent Parner,\nfrom the YouTube Audio Library.\n\n\"Mind Over Matter\" by JewelBeat.com.");
			creditLabel.x = 260;
			creditLabel.y = 245;
			creditLabel.width = 280;
			creditLabel.height = 260;
			_creditSprite.addChild(creditLabel);
			
			var creditExitButton:EasyButton = new EasyButton("Go Back");
			creditExitButton.x = _anLogo.x;
			creditExitButton.y = _anLogo.y;
			creditExitButton.resizeBox(250, 45);
			creditExitButton.addEventListener(MouseEvent.CLICK, function(e:Event):void {
				transitionScreens(_creditSprite, _menuSprite);
			});
			_creditSprite.addChild(creditExitButton);
			
			this.addChild(_creditSprite);
			
			_newLoadGameSprite = new Sprite();
			GraphicsExtensions.drawRoundedBorderedRect(_newLoadGameSprite.graphics, 250, 235, 300, 280, 0x000000, 0xeeeeee);
			_newLoadGameSprite.x = 800;
			
			function createButton(i:Number):void
			{
				var button:EasyButton = new EasyButton(getSlotLabel(i));
				button.x = newGameButton.x;
				button.y = newGameButton.y + (45 + 20) * i;
				button.resizeBox(250, 45);
				button.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
					if (_isNewGame)
					{
						_playerSlot = i;
						transitionScreens(_newLoadGameSprite, _newGameSprite);
					}
					else if (button.text != ("Slot " + (i + 1)))
					{
						_loadingText.visible = true;
						that.removeChild(_loadingText);
						that.addChild(_loadingText);
						stage.invalidate();
						var event:UIEvent = new UIEvent(UIEvent.PLAYER_START);
						event.player = Player.load(i);
						_loadingText.visible = false;
						resetScreens(_newLoadGameSprite, _menuSprite);
						that.dispatchEvent(event);
					}
				});
				
				_newLoadGameSprite.addChild(button);
				slotButtons.push(button);
			}
			
			var slotButtons:Array = [];
			var that:MenuScene = this;
			for (var i = 0; i < 3; i++)
			{
				createButton(i);
			}
			
			var newLoadExitButton:EasyButton = new EasyButton("Go Back");
			newLoadExitButton.x = _anLogo.x;
			newLoadExitButton.y = _anLogo.y;
			newLoadExitButton.resizeBox(250, 45);
			newLoadExitButton.addEventListener(MouseEvent.CLICK, function(e:Event):void {
				transitionScreens(_newLoadGameSprite, _menuSprite);
			});
			_newLoadGameSprite.addChild(newLoadExitButton);
			
			this.addEventListener(Event.ADDED_TO_STAGE, function(e:Event):void {
				for (var i = 0; i < 3; i++)
				{
					var button:EasyButton = slotButtons[i];
					button.text = getSlotLabel(i);
				}
			});
			
			this.addChild(_newLoadGameSprite);
			
			_newGameSprite = new Sprite();
			GraphicsExtensions.drawRoundedBorderedRect(_newGameSprite.graphics, 250, 235, 300, 280, 0x000000, 0xeeeeee);
			_newGameSprite.x = 800;
			
			var nameLabel:EasyTextField = new EasyTextField("Player Name");
			nameLabel.bold = true;
			nameLabel.size = 18;
			nameLabel.x = 260;
			nameLabel.y = 245;
			_newGameSprite.addChild(nameLabel);
			
			var nameInput:EasyInputField = new EasyInputField(280);
			nameInput.size = 18;
			nameInput.x = 260;
			nameInput.y = nameLabel.y + nameLabel.textHeight + 5;
			nameInput.text = Patterns.Username();
			nameInput.backgroundColor = 0xffffff;
			_newGameSprite.addChild(nameInput);
			
			var doneButton:EasyButton = new EasyButton("Start Game");
			doneButton.x = creditButton.x;
			doneButton.y = creditButton.y;
			doneButton.resizeBox(250, 45);
			doneButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				if (Util.trim(nameInput.text).length == 0) return;
				
				_loadingText.visible = true;
				that.removeChild(_loadingText);
				that.addChild(_loadingText);
				setTimeout(function():void {
					var player:Player = new Player(Util.trim(nameInput.text));
					GameScene.player = player;
					player.saveSlot = _playerSlot;
					player.aiPlayers.calculateDay();
					var event = new UIEvent(UIEvent.PLAYER_START);
					event.player = player;
					_loadingText.visible = false;
					resetScreens(_newGameSprite, _menuSprite);
					that.dispatchEvent(event);
				}, 100);
			});
			_newGameSprite.addChild(doneButton);
			
			var newGameExitButton:EasyButton = new EasyButton("Go Back");
			newGameExitButton.x = _anLogo.x;
			newGameExitButton.y = _anLogo.y;
			newGameExitButton.resizeBox(250, 45);
			newGameExitButton.addEventListener(MouseEvent.CLICK, function(e:Event):void {
				transitionScreens(_newGameSprite, _menuSprite);
			});
			_newGameSprite.addChild(newGameExitButton);
			
			this.addChild(_newGameSprite);
		}
		
		private function transitionScreens(a:Sprite, b:Sprite):void
		{
			a.x = 0;
			b.x = 800;
			
			var counter:Number = 0;
			var that:MenuScene = this;
			this.addEventListener(Event.ENTER_FRAME, function update(e:Event):void {
				counter++;
				
				a.x = Easing.easeInOutBack(counter, 0, -800, 30);
				b.x = 800 - Easing.easeInOutBack(counter, 0, 800, 30);
				
				if (counter >= 30)
				{
					that.removeEventListener(Event.ENTER_FRAME, update);
				}
			});
		}
		
		private function resetScreens(a:Sprite, b:Sprite)
		{
			a.x = -800;
			b.x = 0;
		}
		
		private function getSlotLabel(i:Number):String
		{
			return Player.readName(i);
		}
		
		private function updateBackground(e:Event):void
		{
			for (var i:Number = 0; i < _cashChildren.length; i++)
			{
				var speed:Number = _cashSpeed[i];
				var money:Sprite = _cashChildren[i];
				
				money.x -= speed * 3;
				money.rotation += speed;
				
				if (money.x < -_cashIcon.width)
				{
					_cashBackground.removeChild(money);
					
					var icon = new Sprite();
					icon.graphics.beginBitmapFill(_cashIcon.bitmapData);
					icon.graphics.drawRect(0, 0, _cashIcon.width, _cashIcon.height);
					icon.graphics.endFill();
					
					icon.x = 800 + _cashIcon.width;
					icon.y = Util.randomRange(icon.height, 600);
					icon.rotation = Math.random() * 360;
					
					var depth:Number = _cashSpeed[i];
					icon.scaleX = icon.scaleY = icon.scaleZ = depth;
					icon.alpha = depth;
					
					_cashChildren[i] = icon;
					_cashSpeed[i] = depth;
					_cashBackground.addChild(icon);
				}
			}
		}
	}

}
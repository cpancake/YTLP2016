package
{
	import com.animenight.igs.Comments;
	import com.animenight.igs.Games;
	import com.animenight.igs.MusicManager;
	import com.animenight.igs.components.EasyButton;
	import com.animenight.igs.Patterns;
	import com.animenight.igs.Player;
	import com.animenight.igs.PosterGenerator;
	import com.animenight.igs.events.UIEvent;
	import com.animenight.igs.scenes.GameScene;
	import com.animenight.igs.StaticProfiler;
	import com.animenight.igs.Util;
	import com.animenight.igs.scenes.MenuScene;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.text.Font;
	import com.torrunt.DeveloperConsole;
	import flash.text.engine.FontWeight;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * ...
	 * @author Andrew Rogers
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		[Embed(
			source = "../resources/opensans.ttf", 
			embedAsCFF = "false", 
			fontFamily = "Open Sans", 
			fontName = "Open Sans")]
		private static var _openSans:Class;
		[Embed(
			source = "../resources/opensans-bold.ttf", 
			embedAsCFF = "false", 
			fontFamily = "Open Sans", 
			fontName = "Open Sans",
			fontWeight="bold")]
		private static var _openSansBold:Class;
		[Embed(
			source = "../resources/opensans-italic.ttf", 
			embedAsCFF = "false", 
			fontFamily = "Open Sans", 
			fontName = "Open Sans",
			fontStyle="italic")]
		private static var _openSansItalic:Class;
		[Embed(
			source = "../resources/opensans-bolditalic.ttf", 
			embedAsCFF = "false", 
			fontFamily = "Open Sans", 
			fontName = "Open Sans",
			fontWeight = "bold",
			fontStyle="italic")]
		private static var _openSansBoldItalic:Class;
		private static var _instance:Main;
		private static var _traces:Array = [];
		
		private var _console:DeveloperConsole;
		private var _gameScene:GameScene;
		
		public static var OpenSans:Font = new _openSans();
		public static var musicManager:MusicManager = new MusicManager();
		
		public function Main() 
		{
			Font.registerFont(_openSans);
			Font.registerFont(_openSansBold);
			_instance = this;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public static function echo(msg:String):void
		{
			if (_instance == null || _instance._console == null)
			{
				_traces.push(msg);
				return;
			}
			_instance._console.echo(msg);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var menuScene:MenuScene = new MenuScene();
			var that:Main = this;
			var menuItem:ContextMenuItem = new ContextMenuItem("Return To Menu");
			menuScene.addEventListener(UIEvent.PLAYER_START, function(pe:UIEvent):void {
				_gameScene = new GameScene(pe.player);
				_gameScene.addEventListener(UIEvent.RETURN_TO_MENU, function(e:UIEvent):void {
					that.removeChild(_gameScene);
					menuItem.enabled = false;
					musicManager.switchToMenu();
					that.addChild(menuScene);
				});
				menuItem.enabled = true;
				musicManager.switchToGame();
				that.removeChild(menuScene);
				that.addChild(_gameScene);
			});
			this.addChild(menuScene);
			
			/*var player:Player = new Player();
			GameScene.player = player;
			player.aiPlayers.calculateDay();
			_gameScene = new GameScene(player);
			this.addChild(_gameScene);*/
			
			musicManager.start();
			
			var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			menuItem.enabled = false;
			menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent):void {
				that.removeChild(_gameScene);
				musicManager.switchToMenu();
				that.addChild(menuScene);
			});
			var muteItem:ContextMenuItem = new ContextMenuItem("Toggle Music");
			muteItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent):void {
				musicManager.toggleMute();
			});
			var nextItem:ContextMenuItem = new ContextMenuItem("Next Song");
			nextItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent):void {
				musicManager.nextSong();
			});
			menu.customItems.push(muteItem, nextItem, menuItem);
			contextMenu = menu;
			
			if (false)
			{
				_console = new DeveloperConsole(_gameScene);
				addChild(_console);
				
				stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void
				{
					if (e.keyCode == 192)
						_console.toggle();
				});
				
				_traces.forEach(function(m:String, _, __) {
					Main.echo(m);
				});
			}
		}

	}

}
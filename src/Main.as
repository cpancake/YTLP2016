package
{
	import com.animenight.igs.Comments;
	import com.animenight.igs.components.EasyButton;
	import com.animenight.igs.Patterns;
	import com.animenight.igs.Player;
	import com.animenight.igs.PosterGenerator;
	import com.animenight.igs.scenes.GameScene;
	import com.animenight.igs.StaticProfiler;
	import com.animenight.igs.Util;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.text.Font;
	import com.torrunt.DeveloperConsole;
	import flash.text.engine.FontWeight;

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
		
		public static var OpenSans:Font = new _openSans();
		
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
			var player:Player = new Player();
			player.generateName();
			
			var gameScene:GameScene = new GameScene(player);
			this.addChild(gameScene);
			
			if (true)
			{
				_console = new DeveloperConsole(gameScene);
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
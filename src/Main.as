package
{
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
	import flash.events.MouseEvent;
	import flash.text.Font;
	import profiler.ProfilerConfig;

	/**
	 * ...
	 * @author Andrew Rogers
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		[Embed(source = "../resources/opensans.ttf", embedAsCFF = "false", fontFamily = "Open Sans")]
		private static var _openSans:Class;
		
		public static var OpenSans:Font = new _openSans();
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var player:Player = new Player();
			player.generateName();
			
			this.addChild(new GameScene(player));
			/*ProfilerConfig.Width = this.stage.stageWidth;
			ProfilerConfig.ShowMinMax = true;
			this.addChild(StaticProfiler.GetInstance());
			var btn = new EasyButton("image");
			btn.x = 200;
			btn.y = 200;
			var img:Bitmap;
			img = PosterGenerator.generatePoster(Util.toTitleCase(Patterns.Run("gameName")));
			var that = this;
			btn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				that.removeChild(img);
				img = PosterGenerator.generatePoster(Util.toTitleCase(Patterns.Run("gameName")));
				that.addChild(img);
			});
			this.addChild(img);
			this.addChild(btn);*/
		}

	}

}
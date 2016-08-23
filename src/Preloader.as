package
{
	import com.animenight.igs.components.EasyTextField;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class Preloader extends MovieClip 
	{
		private var _loader:TextField;
		private var _bg:Sprite;
		
		public function Preloader() 
		{
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			var format:TextFormat = new TextFormat("Arial", 16, 0xdddddd);
			format.align = TextFormatAlign.CENTER;
			format.letterSpacing = 1;
			
			_bg = new Sprite();
			addChild(_bg);
			
			_bg.graphics.beginFill(0xeeeeee);
			_bg.graphics.drawRect(0, 0, 800, 600);
			_bg.graphics.endFill();
			_bg.graphics.beginFill(0x000000);
			_bg.graphics.drawRect(274, 279, 252, 42);
			_bg.graphics.endFill();
			
			_loader = new TextField();
			_loader.text = "0/0 bytes loaded";
			_loader.defaultTextFormat = format;
			_loader.autoSize = TextFieldAutoSize.CENTER;
			_loader.x = 400 - _loader.width / 2;
			_loader.y = 300 - _loader.height / 2;
			_loader.filters = [new GlowFilter(0x000000, 1, 2, 2, 10, 1)];
			addChild(_loader);
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			var total:Number = Math.floor(e.bytesTotal / 100000) / 10;
			var needed:Number = Math.floor(e.bytesLoaded / 100000) / 10;
			_loader.text = needed + " MB / " + total + " MB loaded";
			
			_bg.graphics.beginFill(0xe6ffd1);
			_bg.graphics.drawRect(275, 280, 250 * (e.bytesLoaded / e.bytesTotal), 40);
			_bg.graphics.endFill();
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			startup();
		}
		
		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
			removeChild(_loader);
			removeChild(_bg);
		}
		
	}
	
}
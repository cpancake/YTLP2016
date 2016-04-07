package com.animenight.igs 
{
	import com.animenight.igs.components.EasyButton;
	import com.animenight.igs.components.EasyTextField;
	import com.animenight.igs.data.PosterSeeds;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Shader;
	import flash.display.ShaderData;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.engine.BreakOpportunity;
	import flash.text.Font;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class PosterGenerator 
	{
		//these fonts are really annoying me
		//this is just a list of non-alphanumeric fonts on my computer
		private static var _fontBlacklist:Array = [
			'wingdings',
			'webdings',
			'broadway copyist',
			'broadway copyist perc',
			'engraverfontextras',
			'engraverfontset',
			'engravertexth',
			'engravertextncs',
			'engravertextt',
			'engravertime',
			'finale alphanotes',
			'finale mallets',
			'finale numerics',
			'finale percussion',
			'jazz',
			'jazzcord',
			'jazzperc',
			'maestro',
			'maestro percussion',
			'maestro wide',
			'musicalsymbols',
			'opensymbol',
			'petrucci',
			'seville',
			'tamburo',
			'symbol',
			'sf fedora symbols',
			'avant garde alternates',
			'final fantasy'
		];
		
		private static var _operations:Array = [
			opBrightness,
			opInvert,
			opSolarize,
			opDisplace,
			opBlur,
			opSepia,
			opPixelate,
			opEdgeDetect,
			opNoiseDisplace,
			opHeatmapOrXray,
			opBlend
		];
		
		[Embed(source="../../../../resources/shaders/sepia.pbj", mimeType="application/octet-stream")]
		private static var _sepiaShader:Class;
		
		[Embed(source = "../../../../resources/shaders/pixelate.pbj", mimeType = "application/octet-stream")]
		private static var _pixelateShader:Class;
		
		[Embed(source="../../../../resources/shaders/edge-detect.pbj", mimeType="application/octet-stream")]
		private static var _edgeDetectShader:Class;
		
		[Embed(source="../../../../resources/shaders/invert.pbj", mimeType="application/octet-stream")]
		private static var _invertShader:Class;
		
		[Embed(source="../../../../resources/shaders/solarize.pbj", mimeType="application/octet-stream")]
		private static var _solarizeShader:Class;
		
		[Embed(source="../../../../resources/shaders/brightness.pbj", mimeType="application/octet-stream")]
		private static var _brightnessShader:Class;
		
		[Embed(source="../../../../resources/shaders/contrast.pbj", mimeType="application/octet-stream")]
		private static var _contrastShader:Class;
		
		[Embed(source = "../../../../resources/shaders/heatmap.pbj", mimeType = "application/octet-stream")]
		private static var _heatmapShader:Class;
		
		[Embed(source = "../../../../resources/shaders/scanlines.pbj", mimeType = "application/octet-stream")]
		private static var _scanlinesShader:Class;
		
		[Embed(source = "../../../../resources/shaders/xray.pbj", mimeType = "application/octet-stream")]
		private static var _xrayShader:Class;
		
		public function PosterGenerator() 
		{
			
		}
		
		public static function generatePoster(title:String):Bitmap
		{
			var base:Bitmap = randomImage();
			var data:BitmapData = base.bitmapData.clone();
			
			var operationCount = Math.floor(Util.randomer() * 5) + 1;
			for (var i = 0; i < operationCount; i++)
			{
				var operation:Function = _operations[Math.floor(Util.randomer() * _operations.length)];
				data = operation(data);
			}
			
			var font:Font = randomFont();
			var textField:EasyTextField = new EasyTextField("");
			var words = title.split(" ");
			textField.embedFonts = false;
			textField.font = font.fontName;
			textField.bold = true;
			textField.size = 36;
			textField.alignment = TextFormatAlign.CENTER;
			textField.width = 270;
			textField.height = 381;
			textField.multiline = true;
			for (var i = 0; i < words.length; i++)
			{
				var word:String = words[i];
				textField.text += word + " ";
				textField.update();
				if (textField.textWidth > 260)
				{
					textField.text = textField.text.substr(0, textField.text.length - word.length - 2);
					textField.text += "\n";
					textField.text += Util.trim(word) + " ";
					textField.update();
				}
			}
			textField.text = Util.trim(textField.text);
			while (textField.textHeight > 370 || textField.textWidth > 200)
				textField.size = (textField.size as Number) - 1;
			textField.color = Math.floor((Math.random() * 0xffffff + 0xffffff) / 2);
			textField.filters = [ new DropShadowFilter(0, 45, 0xffffff - textField.color, 1, 4, 4, 10) ];
			textField.update();
			
			var xPos = (270 / 2) - (textField.textWidth / 2) - 5;
			data.draw(textField, new Matrix(1, 0, 0, 1, xPos, 10), null, BlendMode.NORMAL, new Rectangle(0, 0, 270, 381), true);
			
			return new Bitmap(data);
		}
		
		private static function randomImage():Bitmap
		{
			return PosterSeeds.IMAGES[Math.floor(Util.randomer() * PosterSeeds.IMAGES.length)];
		}
		
		private static function randomFont():Font
		{
			var fonts = Font.enumerateFonts(true);
			var font:Font;
			do
			{
				font = fonts[Math.floor(Math.random() * fonts.length)];
			} while (_fontBlacklist.indexOf(font.fontName.toLowerCase()) != -1);
			return font;
		}
		
		// operations
		private static function opBrightness(data:BitmapData):BitmapData
		{
			data.lock();
			var shader:Shader = new Shader(new _brightnessShader());
			var filter = new ShaderFilter(shader);
			data.applyFilter(data, data.rect, new Point(0, 0), filter);
			data.unlock();
			return data;
		}
		
		// this doesn't work right but it actually looks better than if it did
		private static function opContrast(data:BitmapData):BitmapData
		{
			data.lock();
			var shader:Shader = new Shader(new _contrastShader());
			shader.data.c.value = [ Math.random() ];
			var filter = new ShaderFilter(shader);
			data.applyFilter(data, data.rect, new Point(0, 0), filter);
			data.unlock();
			return data;
		}
		
		private static function opInvert(data:BitmapData):BitmapData
		{
			data.lock();
			var shader:Shader = new Shader(new _invertShader());
			var filter = new ShaderFilter(shader);
			data.applyFilter(data, data.rect, new Point(0, 0), filter);
			data.unlock();
			return data;
		}
		
		private static function opSolarize(data:BitmapData):BitmapData
		{
			data.lock();
			var shader:Shader = new Shader(new _solarizeShader());
			shader.data.below.value = [ (Math.random() > 0.5 ? 1 : 0) ];
			var filter = new ShaderFilter(shader);
			data.applyFilter(data, data.rect, new Point(0, 0), filter);
			data.unlock();
			return data;
		}
		
		private static function opDisplace(data:BitmapData):BitmapData
		{
			data.lock();
			var dispImage:Bitmap = randomImage();
			var filter = new DisplacementMapFilter(
				dispImage.bitmapData, 
				new Point(0, 0), 
				BitmapDataChannel.RED, 
				BitmapDataChannel.GREEN, 
				100, 
				100);
			data.applyFilter(data, data.rect, new Point(0, 0), filter);
			data.unlock();
			return data;
		}
		
		private static function opNoiseDisplace(data:BitmapData):BitmapData
		{
			data.lock();
			var dispData:BitmapData = new BitmapData(data.width, data.height, false);
			if (Math.random() > 0.1)
				dispData.perlinNoise(data.width, data.height, 8, Util.randomSeed(), true, false);
			else
				dispData.noise(Util.randomSeed());
			var filter = new DisplacementMapFilter(
				dispData, 
				new Point(0, 0), 
				BitmapDataChannel.RED, 
				BitmapDataChannel.GREEN, 
				100, 
				100);
			data.applyFilter(data, data.rect, new Point(0, 0), filter);
			data.unlock();
			return data;
		}
		
		private static function opBlur(data:BitmapData):BitmapData
		{
			data.lock();
			var filter = new BlurFilter(Math.random() * 60, Math.random() * 60);
			data.applyFilter(data, data.rect, new Point(0, 0), filter);
			data.unlock();
			return data;
		}
		
		private static function opSepia(data:BitmapData):BitmapData
		{
			data.lock();
			var shader:Shader = new Shader(new _sepiaShader());
			shader.data.intensity.value = [ 0.2 ];
			var filter = new ShaderFilter(shader);
			data.applyFilter(data, data.rect, new Point(0, 0), filter);
			data.unlock();
			return data;
		}
		
		private static function opPixelate(data:BitmapData):BitmapData
		{
			data.lock();
			var shader:Shader = new Shader(new _pixelateShader());
			shader.data.dimension.value = [ 4 ];
			var filter = new ShaderFilter(shader);
			data.applyFilter(data, data.rect, new Point(0, 0), filter);
			data.unlock();
			return data;
		}
		
		private static function opEdgeDetect(data:BitmapData):BitmapData
		{
			data.lock();
			var shader:Shader = new Shader(new _edgeDetectShader());
			shader.data.threshold.value = [ 0.1 ];
			var filter = new ShaderFilter(shader);
			data.applyFilter(data, data.rect, new Point(0, 0), filter);
			data.unlock();
			return data;
		}
		
		private static function opHeatmap(data:BitmapData):BitmapData
		{
			data.lock();
			var shader:Shader = new Shader(new _heatmapShader());
			var filter = new ShaderFilter(shader);
			data.applyFilter(data, data.rect, new Point(0, 0), filter);
			data.unlock();
			return data;
		}
		
		private static function opScanlines(data:BitmapData):BitmapData
		{
			data.lock();
			var shader:Shader = new Shader(new _scanlinesShader());
			var filter = new ShaderFilter(shader);
			data.applyFilter(data, data.rect, new Point(0, 0), filter);
			data.unlock();
			return data;
		}
		
		private static function opXray(data:BitmapData):BitmapData
		{
			data.lock();
			var shader:Shader = new Shader(new _xrayShader());
			var filter = new ShaderFilter(shader);
			data.applyFilter(data, data.rect, new Point(0, 0), filter);
			data.unlock();
			return data;
		}
		
		private static function opHeatmapOrXray(data:BitmapData):BitmapData
		{
			return Math.random() > 0.5 ? opHeatmap(data) : opXray(data);
		}
		
		private static function opBlend(data:BitmapData):BitmapData
		{
			data.lock();
			var image:Bitmap = randomImage();
			var blendModes:Array = [
				BlendMode.ADD,
				BlendMode.ALPHA,
				BlendMode.DARKEN,
				BlendMode.DIFFERENCE,
				BlendMode.ERASE,
				BlendMode.HARDLIGHT,
				BlendMode.INVERT,
				BlendMode.LAYER,
				BlendMode.LIGHTEN,
				BlendMode.MULTIPLY,
				BlendMode.OVERLAY,
				BlendMode.SCREEN,
				BlendMode.SUBTRACT
			];
			image.alpha = Math.random() * 0.5 + 0.5;
			data.draw(image, null, null, Util.randomArrayItem(blendModes) as String);
			image.alpha = 1;
			data.unlock();
			return data;
		}
	}
}
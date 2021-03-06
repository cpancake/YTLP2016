package com.animenight.igs 
{
	import flash.display3D.textures.RectangleTexture;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import com.animenight.igs.components.EasyTextField;
	import com.animenight.igs.data.PosterSeeds;
	import com.animenight.igs.data.ThumbnailSeeds;
	import flash.display.Bitmap;
	import flash.text.Font;
	import flash.text.TextFormatAlign;
	import flash.filters.DropShadowFilter;
	import flash.display.BlendMode;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class ThumbnailGenerator 
	{
		public static const THUMBNAIL_RECT:Rectangle = new Rectangle(0, 0, 250, 150);
		
		private static var _numberFonts:Array = [
			"Arial",
			"Arial Black",
			"Calibri",
			"Comic Sans",
			"Comic Sans MS",
			"Consolas",
			"Impact",
			"Tahoma",
			"Trebuchet MS",
			"Verdana",
			"Open Sans"
		];
		
		public function ThumbnailGenerator() 
		{
			
		}
		
		public static function generateThumbnail(isLP:Boolean, number:Number = 1, face:Bitmap = null, faceSide:String = null):Bitmap
		{
			var gameImage:Bitmap = ThumbnailSeeds.IMAGES[Math.floor(Util.randomer() * ThumbnailSeeds.IMAGES.length)];
			var finalImage:Bitmap = new Bitmap(gameImage.bitmapData.clone());
			
			var hasFace:Boolean = Math.random() > 0.2;
			var numberSide:String = "left";
			if (hasFace)
			{
				var person:Number = Math.floor(Util.randomer() * ThumbnailSeeds.PEOPLE.length);
				var faceImage:Bitmap = (face == null ? ThumbnailSeeds.PEOPLE[person] : face);
				numberSide = (faceSide == null ? ThumbnailSeeds.PEOPLE_SIDES[person] : faceSide);
				// 50% chance to flip
				var rotation:Matrix = new Matrix(); // (Math.random() > 0.5 ? new Matrix() : new Matrix( -1, 0, 0, 1, faceImage.width, 0));
				// rotate a little bit randomly
				//rotation.rotate((0.05 * Math.PI) - Math.random() * 0.1 * Math.PI);
				faceImage.smoothing = true;
				finalImage.bitmapData.draw(faceImage, rotation, null, null, null, true);
			}
			
			if (isLP)
			{
				var textField:EasyTextField = new EasyTextField(number.toString());
				textField.embedFonts = false;
				textField.font = randomFont();
				textField.bold = true;
				textField.size = 72;
				textField.alignment = TextFormatAlign.RIGHT;
				textField.color = Math.floor((Math.random() * 0xffffff + 0xffffff) / 2);
				textField.filters = [ new DropShadowFilter(0, 45, 0xffffff - textField.color, 1, 4, 4, 10) ];
				textField.update();
				
				var xPos = (numberSide == "left" ? 0 : (250 - textField.textWidth - 10));
				finalImage.bitmapData.draw(textField, new Matrix(1, 0, 0, 1, xPos, 150 - textField.textHeight), null, BlendMode.NORMAL, new Rectangle(0, 0, 250, 150), true);
			}
			
			return finalImage;
		}
		
		private static function randomFont():String
		{
			return PosterGenerator.randomFont().fontName;
			var fonts:Array = Font.enumerateFonts(true).map(function(f, _, __) { return f.fontName.toLowerCase(); });
			var fontsPresent = _numberFonts.filter(function(font:String, _, __) { return fonts.indexOf(font.toLowerCase()) != -1; });
			if (fontsPresent.length == 0)
				return "Open Sans";
			return fontsPresent[Math.floor(Util.randomer() * fontsPresent.length)];
		}
	}

}
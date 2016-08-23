package com.animenight.igs 
{
	import flash.display.Graphics;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class GraphicsExtensions 
	{
		public static function drawBorderedRect(graphics:Graphics, x:int, y:int, width:int, height:int, borderColor:uint, bgColor:uint)
		{
			graphics.beginFill(borderColor);
			graphics.drawRect(x, y, width, height);
			graphics.endFill();
			
			graphics.beginFill(bgColor);
			graphics.drawRect(x + 1, y + 1, width - 2, height - 2);
			graphics.endFill();
		}
		
		public static function drawRoundedBorderedRect(graphics:Graphics, x:int, y:int, width:int, height:int, borderColor:uint, bgColor:uint)
		{
			graphics.beginFill(borderColor);
			graphics.drawRoundRect(x, y, width, height, 10, 10);
			graphics.endFill();
			
			graphics.beginFill(bgColor);
			graphics.drawRoundRect(x + 1, y + 1, width - 2, height - 2, 8, 8);
			graphics.endFill();
		}
	}

}
package com.animenight.igs.components 
{
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class EasyTextField extends TextField
	{
		private var _format:TextFormat;
		
		public function EasyTextField(text:String) 
		{
			_format = new TextFormat('Open Sans', 14, 0x000000, false);
			_format.align = TextFormatAlign.LEFT;
			
			this.embedFonts = true;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.defaultTextFormat = _format;
			this.x = 0;
			this.y = 0;
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.sharpness = 100;
			this.thickness = 100;
			this.gridFitType = GridFitType.SUBPIXEL;
			this.selectable = false;
			this.text = text;
		}
		
		public function update():void
		{
			this.setTextFormat(_format);
		}
		
		public function get bold():Boolean
		{
			return _format.bold;
		}
		
		public function set bold(value:Boolean):void
		{
			_format.bold = value;
			this.setTextFormat(_format);
		}
		
		public function get size():Object
		{
			return _format.size;
		}
		
		public function set size(value:Object):void
		{
			_format.size = value;
			this.setTextFormat(_format);
		}
		
		public function get color():uint
		{
			return this.textColor;
		}
		
		public function set color(value:uint):void
		{
			_format.color = value;
			this.textColor = value;
			this.setTextFormat(_format);
		}
		
		public function get alignment():String
		{
			return _format.align;
		}
		
		public function set alignment(value:String):void
		{
			_format.align = value;
			this.setTextFormat(_format);
		}
		
		public function get font():String
		{
			return _format.font;
		}
		
		public function set font(value:String):void
		{
			_format.font = value;
			this.update();
		}
		
		public function get italics():Boolean
		{
			return _format.italic;
		}
		
		public function set italics(value:Boolean)
		{
			_format.italic = value;
			this.update();
		}
	}

}
package com.animenight.igs.components 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class ChangeIndicator extends Sprite
	{
		private var _field:EasyTextField;
		private var _timer:Number = 100;
		
		public function ChangeIndicator(text:String, color:uint) 
		{
			_field = new EasyTextField(text);
			_field.color = color;
			_field.size = 16;
			_field.alignment = TextFormatAlign.RIGHT;
			_field.autoSize = TextFieldAutoSize.RIGHT;
			_field.bold = true;
			_field.update();
			
			this.addChild(_field);
			
			this.graphics.beginFill(0xffffff, 0);
			this.graphics.drawRect(0, 0, _field.width, _field.height);
			this.graphics.endFill();
		}
		
		public function get textWidth():Number
		{
			return _field.textWidth;
		}
		
		public function get textHeight():Number
		{
			return _field.textHeight;
		}
		
		public function get timer():Number
		{
			return _timer;
		}
		
		public function set timer(value:Number):void
		{
			_timer = value;
			_field.alpha = value / 100;
		}
	}

}
package com.animenight.igs.components 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class EasyButton extends Sprite
	{
		private const PADDING:Number = 10;
		
		private var _label:EasyTextField;
		private var _color:uint = 0xffffff;
		private var _enabled:Boolean = true;
		
		public function EasyButton(text:String)
		{
			_label = new EasyTextField(text);
			_label.update();
			_label.x = PADDING;
			_label.alignment = TextFormatAlign.CENTER;
			_label.y = PADDING;
			this.addChild(_label);
			
			this.mouseEnabled = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
				if (!_enabled) return;
				_color = 0xffffaa;
				draw();
			});
			
			this.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
				if (!_enabled) return;
				_color = 0xffffff;
				draw();
			});
			
			draw();
		}
		
		public function get text():String
		{
			return _label.text;
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			this.mouseEnabled = value;
			
			if (value)
			{
				_color = 0xffffff;
			}
			else
			{
				_color = 0xdddddd;
			}
			
			draw();
		}
		
		public function resize(width:Number, height:Number):void
		{
			_label.autoSize = TextFieldAutoSize.NONE;
			_label.width = width;
			_label.height = height;
			_label.alignment = TextFormatAlign.CENTER;
			draw();
		}
		
		private function draw():void
		{
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0, 0, _label.width + PADDING * 2, _label.height + PADDING * 2);
			this.graphics.endFill();
			this.graphics.beginFill(_color);
			this.graphics.drawRect(1, 1, (_label.width + PADDING * 2) - 2, (_label.height + PADDING * 2) - 2);
			this.graphics.endFill();
		}
	}

}
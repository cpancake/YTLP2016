package com.animenight.igs.components 
{
	import com.animenight.igs.*;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class TabButton extends Sprite
	{
		public static const WIDTH = 100;
		public static const HEIGHT = 40;
		
		public var badge:String = "";
		
		private var _bg:Shape;
		private var _badge:Sprite;
		private var _badgeLabel:EasyTextField;
		private var _lastBadgeUpdate:String;
		private var _label:TextField;
		private var _mouseIn:Boolean = false;
		
		public var active:Boolean = false;
		public var text:String;
		
		public function TabButton(text:String) 
		{
			this.text = text;
			
			this.mouseEnabled = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
				_mouseIn = true;
				drawBg(0xffffaa);
			});
			
			this.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
				_mouseIn = false;
				drawBg(0xffffff);
			});
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function SetActive(active:Boolean):void
		{
			this.active = active;
			if (_mouseIn)
				drawBg(0xffffaa);
			else
				drawBg(0xffffff);
		}
		
		public function update():void
		{
			if (badge == "")
			{
				_lastBadgeUpdate = "";
				_badge.graphics.clear();
				_badgeLabel.alpha = 0;
			}
			else if (badge != _lastBadgeUpdate)
			{
				_lastBadgeUpdate = badge;
				_badgeLabel.text = badge;
				_badgeLabel.alpha = 1;
				_badgeLabel.update();
				_badge.x = this.x + WIDTH - _badgeLabel.textWidth;
				_badge.y = this.y - 5;
				_badge.graphics.clear();
				_badge.graphics.beginFill(0xCE0000);
				_badge.graphics.drawRoundRect(0, 0, _badgeLabel.textWidth + 4, _badgeLabel.textHeight + 4, 10);
				_badge.graphics.endFill();
			}
		}
		
		private function addedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			_bg = new Shape();
			drawBg(0xffffff);
			this.addChild(_bg);
			
			_badge = new Sprite();
			_badge.mouseEnabled = false;
			_badge.mouseChildren = false;
			this.parent.addChild(_badge);
			
			_badgeLabel = new EasyTextField("0");
			_badgeLabel.bold = true;
			_badgeLabel.color = 0xffffff;
			_badgeLabel.x = 0;
			_badgeLabel.y = 0;
			_badge.addChild(_badgeLabel);
			
			var textFormat:TextFormat = new TextFormat('Open Sans', 14, 0x000000, false);
			textFormat.align = TextFormatAlign.CENTER;
			
			_label = new TextField();
			_label.embedFonts = true;
			_label.autoSize = TextFieldAutoSize.CENTER;
			_label.defaultTextFormat = textFormat;
			_label.text = text;
			_label.selectable = true;
			_label.x = (WIDTH / 2) - (_label.width / 2);
			_label.y = (HEIGHT / 2) - (_label.height / 2);
			
			this.addChild(_label);
			
			this.update();
		}
		
		private function drawBg(color:uint):void
		{
			if (active)
				color = 0xeeeeee;
			_bg.graphics.clear();
			GraphicsExtensions.drawBorderedRect(_bg.graphics, 0, 0, WIDTH, HEIGHT, 0x000000, color);
		}
	}

}
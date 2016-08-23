package com.animenight.igs.components 
{
	import com.animenight.igs.*;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class StatBar extends Sprite
	{
		[Embed(source="../../../../../resources/play.png")]
		private var _playButtonClass:Class;
		
		private var _playButton:Bitmap;
		private var _player:Player;
		private var _bgRect:Shape;
		private var _cashLabel:TextField;
		private var _timeLabel:EasyTextField;
		private var _nextDayLabel:EasyTextField;
		private var _subsLabel:EasyTextField;
		private var _warnFilter:DropShadowFilter;
		private var _warnTimer:Number = 100;
		
		public function StatBar(player:Player) 
		{
			_player = player;
			_playButton = new _playButtonClass();
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void
			{
				drawBackground(0xffffaa);
			});
			this.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void
			{
				drawBackground(0xffffff);
			});
			
			this.mouseEnabled = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			this.buttonMode = true;
		}
		
		public function update():void
		{
			_cashLabel.text = '$' + Util.formatMoney(_player.cash);
			_subsLabel.text = Util.formatNumber(_player.subs) + " Subscribers";
			_subsLabel.x = this.stage.stageWidth - 30 - _cashLabel.textWidth - _subsLabel.textWidth;
			_subsLabel.update();
			_timeLabel.text = Util.formatTime(8 + (16 - _player.hoursLeft));
			_timeLabel.x = _subsLabel.x - 30 - _timeLabel.textWidth;
			_timeLabel.update();
		}
		
		public function get cashXPosition():Number
		{
			return this.stage.stageWidth - 10 - _cashLabel.textWidth;
		}
		
		public function get topPosition():Number
		{
			return this.stage.stageHeight - 30 - 1;
		}
		
		public function warnShadow():void
		{
			_warnFilter = new DropShadowFilter(0, 45, 0xff0000, 1, 2, 2, 5);
			_warnTimer = 100;
			
			_timeLabel.filters = [ _warnFilter ];
			this.removeEventListener(Event.ENTER_FRAME, checkWarnShadow);
			this.addEventListener(Event.ENTER_FRAME, checkWarnShadow);
		}
		
		private function drawBackground(color:uint):void
		{
			_bgRect.graphics.beginFill(color);
			_bgRect.graphics.drawRect(0, 1, width, 30);
			_bgRect.graphics.endFill();
		}
		
		private function addedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			var width:int = this.stage.stageWidth;
			var barHeight:int = 30;
			
			_bgRect = new Shape();
			_bgRect.graphics.beginFill(0x000000);
			_bgRect.graphics.drawRect(0, 0, width, 1);
			_bgRect.graphics.endFill();
			_bgRect.x = 0;
			_bgRect.y = this.stage.stageHeight - barHeight - 1;
			this.addChild(_bgRect);
			
			var cashLabelFormat:TextFormat = new TextFormat('Open Sans', 16, 0x000000, true);
			cashLabelFormat.align = TextFieldAutoSize.RIGHT;
			
			_cashLabel = new TextField();
			_cashLabel.embedFonts = true;
			_cashLabel.autoSize = TextFieldAutoSize.RIGHT;
			_cashLabel.defaultTextFormat = cashLabelFormat;
			_cashLabel.y = this.stage.stageHeight - 27;
			_cashLabel.x = width - 10;
			_cashLabel.selectable = false;
			this.addChild(_cashLabel);
			
			_timeLabel = new EasyTextField("08:00 AM");
			_timeLabel.y = this.stage.stageHeight - 27;
			_timeLabel.bold = true;
			_timeLabel.size = 16;
			_timeLabel.alignment = TextFormatAlign.RIGHT;
			_timeLabel.autoSize = TextFieldAutoSize.RIGHT;
			_timeLabel.update();
			this.addChild(_timeLabel);
			
			_subsLabel = new EasyTextField("0 Subscribers");
			_subsLabel.y = _timeLabel.y;
			_subsLabel.bold = true;
			_subsLabel.size = 16;
			_subsLabel.alignment = TextFormatAlign.RIGHT;
			_subsLabel.autoSize = TextFieldAutoSize.RIGHT;
			_subsLabel.update();
			this.addChild(_subsLabel);
			
			_playButton.x = 0;
			_playButton.y = _bgRect.y + 1;
			this.addChild(_playButton);
			
			_nextDayLabel = new EasyTextField("Next Day");
			_nextDayLabel.y = _playButton.y;
			_nextDayLabel.x = _playButton.width;
			_nextDayLabel.size = 20;
			_nextDayLabel.bold = true;
			_nextDayLabel.update();
			this.addChild(_nextDayLabel);
			drawBackground(0xffffff);
			
			update();
		}
		
		private function checkWarnShadow(e:Event):void
		{
			_warnTimer -= 4;
			_warnFilter.alpha = _warnTimer / 100;
			_timeLabel.filters = [ _warnFilter ];
			if (_warnTimer < 0)
			{
				_timeLabel.filters = [];
				this.removeEventListener(Event.ENTER_FRAME, checkWarnShadow);
			}
		}
	}

}
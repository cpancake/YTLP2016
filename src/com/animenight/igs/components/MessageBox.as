package com.animenight.igs.components 
{
	import com.animenight.igs.events.KillMeEvent;
	import com.animenight.igs.events.MessageChoiceEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class MessageBox extends Sprite
	{
		private var _titleField:EasyTextField;
		private var _field:EasyTextField;
		private var _buttons:Array = [];
		private var _message:String;
		private var _title:String;
		private var _bgSprite:Sprite;
		private var _boxSprite:Sprite;
		private var _okButton:EasyButton;
		
		public function MessageBox(title:String, message:String, buttons:Array = null) 
		{
			_buttons = buttons;
			_message = message;
			_title = title;
			this.mouseEnabled = true;
			this.mouseChildren = true;
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			var height:Number = 250;
			var width:Number = 400;
			var xPos:Number = (this.stage.stageWidth - width) / 2;
			var yPos:Number = (this.stage.stageHeight - height) / 2;
			
			_bgSprite = new Sprite();
			_bgSprite.graphics.beginFill(0x000000, 0.5);
			_bgSprite.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			_bgSprite.graphics.endFill();
			_bgSprite.mouseEnabled = true;
			_bgSprite.mouseChildren = true;
			_bgSprite.useHandCursor = true;
			_bgSprite.buttonMode = true;
			this.addChild(_bgSprite);
			
			//_bgSprite.addEventListener(MouseEvent.CLICK, killMyself);
			
			var boxSprite = new Sprite();
			boxSprite.graphics.beginFill(0x000000);
			boxSprite.graphics.drawRect(xPos, yPos, width, height);
			boxSprite.graphics.endFill();
			
			boxSprite.graphics.beginFill(0xffffff);
			boxSprite.graphics.drawRect(xPos + 1, yPos + 1, width - 2, height - 2);
			boxSprite.graphics.endFill();
			
			boxSprite.graphics.beginFill(0x999999);
			boxSprite.graphics.drawRect(xPos + 1, yPos + 1, width - 2, 30);
			boxSprite.graphics.endFill();
			this.addChild(boxSprite);
			
			_field = new EasyTextField(_message);
			_field.autoSize = TextFieldAutoSize.NONE;
			_field.width = 390;
			_field.height = height - 10;
			_field.wordWrap = true;
			_field.x = xPos + 5;
			_field.y = yPos + 5 + 30;
			this.addChild(_field);
			
			_titleField = new EasyTextField(_title);
			_titleField.autoSize = TextFieldAutoSize.NONE;
			_titleField.width = width - 2;
			_titleField.height = 30;
			_titleField.size = 20;
			_titleField.color = 0xffffff;
			_titleField.bold = true;
			_titleField.x = xPos + 5;
			_titleField.y = yPos;
			this.addChild(_titleField);
			
			if (_buttons == null || _buttons.length == 0)
			{
				_okButton = new EasyButton("OK");
				_okButton.resize(width - 10 - 20, _okButton.height - 20);
				_okButton.x = xPos + 5;
				_okButton.y = yPos + height - _okButton.height - 5;
				_okButton.addEventListener(MouseEvent.CLICK, killMyself);
				this.addChild(_okButton);
			}
			else
			{
				var buttonWidth = (width - 10 - (_buttons.length - 1) * 10) / _buttons.length;
				for (var i = 0; i < _buttons.length; i++)
				{
					var btn:EasyButton = new EasyButton(_buttons[i]);
					btn.resize(buttonWidth - 20, btn.height - 20);
					btn.x = xPos + 5 + (i * buttonWidth + i * 10);
					btn.y = yPos + height - btn.height - 5;
					var that = this;
					btn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
						var evt:MessageChoiceEvent = new MessageChoiceEvent(MessageChoiceEvent.CHOICE);
						evt.choice = (e.target as EasyButton).text;
						that.dispatchEvent(evt);
					});
					this.addChild(btn);
				}
			}
		}
		
		private function killMyself(e:MouseEvent):void
		{
			var evt:KillMeEvent = new KillMeEvent(KillMeEvent.KILL_ME);
			evt.me = this;
			this.dispatchEvent(evt);
		}
	}

}
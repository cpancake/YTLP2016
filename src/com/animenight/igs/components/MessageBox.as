package com.animenight.igs.components 
{
	import com.animenight.igs.GraphicsExtensions;
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
		private var _isInput:Boolean = false;
		private var _inputBox:EasyInputField;
		
		public var placeholder:String = "";
		
		public function MessageBox(title:String, message:String, buttons:Array = null, isInput:Boolean = false) 
		{
			_buttons = buttons == null ? ["OK"] : buttons;
			_message = message;
			_isInput = isInput;
			_title = title;
			this.mouseEnabled = true;
			this.mouseChildren = true;
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function get input():String
		{
			return _isInput ? _inputBox.text : "";
		}
		
		private function addedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			var width:Number = 400;
			var xPos:Number = (this.stage.stageWidth - width) / 2;
			var totalHeightSoFar:Number = 0;
			
			_bgSprite = new Sprite();
			_bgSprite.graphics.beginFill(0x000000, 0.5);
			_bgSprite.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			_bgSprite.graphics.endFill();
			/*_bgSprite.mouseEnabled = true;
			_bgSprite.mouseChildren = true;
			_bgSprite.useHandCursor = true;
			_bgSprite.buttonMode = true;*/
			this.addChild(_bgSprite);
			
			//_bgSprite.addEventListener(MouseEvent.CLICK, killMyself);
			
			var boxSprite = new Sprite();
			this.addChild(boxSprite);
			
			var container:Sprite = new Sprite();
			container.graphics.beginFill(0x000000, 0);
			container.graphics.drawRect(0, 0, 800, 600);
			container.graphics.endFill();
			this.addChild(container);
			
			_field = new EasyTextField(_message);
			_field.width = 390;
			_field.wordWrap = true;
			_field.x = xPos + 5;
			_field.y = 5 + 30;
			totalHeightSoFar += _field.textHeight + 5 + 30;
			container.addChild(_field);
			
			if (_isInput)
			{
				_inputBox = new EasyInputField(_field.width - 10);
				_inputBox.text = placeholder;
				_inputBox.x = _field.x + 5;
				_inputBox.y = _field.y + _field.textHeight + 10;
				stage.focus = _inputBox;
				container.addChild(_inputBox);
				totalHeightSoFar += _inputBox.textHeight + 10;
			}
			
			_titleField = new EasyTextField(_title);
			_titleField.width = width - 2;
			_titleField.height = 30;
			_titleField.size = 20;
			_titleField.color = 0xffffff;
			_titleField.bold = true;
			_titleField.x = xPos + 5;
			_titleField.y = 0;
			container.addChild(_titleField);
			totalHeightSoFar += 30;
			
			if (totalHeightSoFar < 200)
				totalHeightSoFar = 200;
			
			for (var i = 0; i < _buttons.length; i++)
			{
				var btn:EasyButton = new EasyButton(_buttons[i]);
				btn.resize(width - 10 - 20, btn.height - 20);
				btn.x = xPos + 5;
				btn.y = totalHeightSoFar;
				var that = this;
				btn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
					var evt:MessageChoiceEvent = new MessageChoiceEvent(MessageChoiceEvent.CHOICE);
					evt.choice = (e.target as EasyButton).text;
					if(_inputBox)
						evt.input = _inputBox.text;
					that.dispatchEvent(evt);
				});
				container.addChild(btn);
				totalHeightSoFar += btn.height + 5;
			}
			
			var yPos:Number = stage.stageHeight / 2 - totalHeightSoFar / 2;
			
			GraphicsExtensions.drawBorderedRect(boxSprite.graphics, xPos, yPos, width, totalHeightSoFar, 0x000000, 0xffffff);
			
			boxSprite.graphics.beginFill(0x999999);
			boxSprite.graphics.drawRect(xPos + 1, yPos + 1, width - 2, 30);
			boxSprite.graphics.endFill();
			
			container.x = 0;
			container.y = yPos;
		}
		
		private function killMyself(e:MouseEvent):void
		{
			var evt:KillMeEvent = new KillMeEvent(KillMeEvent.KILL_ME);
			evt.me = this;
			this.dispatchEvent(evt);
		}
	}

}
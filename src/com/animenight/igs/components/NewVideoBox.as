package com.animenight.igs.components 
{
	import com.animenight.igs.GraphicsExtensions;
	import com.animenight.igs.VideoProject;
	import com.animenight.igs.events.KillMeEvent;
	import com.animenight.igs.events.MessageChoiceEvent;
	import com.animenight.igs.scenes.GameScene;
	import com.bit101.components.HUISlider;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class NewVideoBox extends Sprite
	{
		private var _titleField:EasyTextField;
		private var _field:EasyTextField;
		private var _buttons:Array = [];
		private var _message:String;
		private var _title:String;
		private var _bgSprite:Sprite;
		private var _boxSprite:Sprite;
		private var _okButton:EasyButton;
		private var _inputBox:EasyInputField;
		
		public var placeholder:String = "";
		
		public function NewVideoBox() 
		{
			_buttons = ["Create", "Cancel"];
			_title = "New Video";
			this.mouseEnabled = true;
			this.mouseChildren = true;
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function get input():String
		{
			return _inputBox.text;
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
			this.addChild(_bgSprite);
			
			var boxSprite = new Sprite();
			this.addChild(boxSprite);
			
			var container:Sprite = new Sprite();
			container.graphics.beginFill(0x000000, 0);
			container.graphics.drawRect(0, 0, 800, 600);
			container.graphics.endFill();
			this.addChild(container);
			
			_field = new EasyTextField("Enter a name for your new video:");
			_field.width = 390;
			_field.wordWrap = true;
			_field.x = xPos + 5;
			_field.y = 5 + 30;
			totalHeightSoFar += _field.textHeight + 5 + 30;
			container.addChild(_field);
			
			_inputBox = new EasyInputField(_field.width - 10);
			_inputBox.text = placeholder;
			_inputBox.x = _field.x + 5;
			_inputBox.y = _field.y + _field.textHeight + 10;
			stage.focus = _inputBox;
			container.addChild(_inputBox);
			totalHeightSoFar += _inputBox.textHeight + 10;
			
			var timeInfo:EasyTextField = new EasyTextField("Enter the amount of time you want to dedicate to each task:");
			timeInfo.width = 390;
			timeInfo.wordWrap = true;
			timeInfo.x = xPos + 5;
			timeInfo.y = _inputBox.y + _inputBox.textHeight + 10;
			container.addChild(timeInfo);
			totalHeightSoFar += timeInfo.textHeight + 10;
			
			var recordingLabel:EasyTextField = new EasyTextField("Recording:");
			recordingLabel.bold = true;
			recordingLabel.x = timeInfo.x;
			recordingLabel.y = timeInfo.y + timeInfo.textHeight + 10;
			recordingLabel.size = 12;
			container.addChild(recordingLabel);
			
			var recordingSlider:HUISlider = new HUISlider();
			recordingSlider.width = 310;
			recordingSlider.x = recordingLabel.x + recordingLabel.textWidth + 10;
			recordingSlider.y = recordingLabel.y;
			recordingSlider.minimum = 1;
			recordingSlider.maximum = 20;
			recordingSlider.value = GameScene.player.lastRecordTimeChoice;
			recordingSlider.labelPrecision = 0;
			container.addChild(recordingSlider);
			totalHeightSoFar += recordingSlider.height + 10;
			
			var editingLabel:EasyTextField = new EasyTextField("Editing:");
			editingLabel.bold = true;
			editingLabel.x = recordingLabel.x;
			editingLabel.y = recordingLabel.y + recordingLabel.textHeight + 10;
			editingLabel.size = 12;
			container.addChild(editingLabel);
			
			var editingSlider:HUISlider = new HUISlider();
			editingSlider.width = 310;
			editingSlider.x = recordingSlider.x;
			editingSlider.y = editingLabel.y;
			editingSlider.minimum = 1;
			editingSlider.maximum = 20;
			editingSlider.value = GameScene.player.lastEditTimeChoice;
			editingSlider.labelPrecision = 0;
			container.addChild(editingSlider);
			totalHeightSoFar += editingSlider.height + 10;
			
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
					GameScene.player.lastRecordTimeChoice = evt.recordTime = Math.max(1, Math.ceil(recordingSlider.value));
					GameScene.player.lastEditTimeChoice = evt.editTime = Math.max(1, Math.ceil(editingSlider.value));
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
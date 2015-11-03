package com.animenight.igs.scenes.tabs 
{
	import adobe.utils.CustomActions;
	import com.animenight.igs.components.*;
	import com.animenight.igs.data.Jobs;
	import com.animenight.igs.Player;
	import com.animenight.igs.events.*;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class WorkTab extends Sprite
	{
		private var _player:Player;
		
		private var _hasJobContainer:Sprite;
		private var _workButton:EasyButton;
		private var _quitButton:EasyButton;
		private var _jobField:EasyTextField;
		private var _jobPerformanceTitle:EasyTextField;
		private var _jobPerformance:Sprite;
		
		private var _noJobContainer:Sprite;
		private var _getJobButton:EasyButton;
		private var _noJobTitle:EasyTextField;
		
		public function WorkTab(player:Player) 
		{
			_player = player;
			this.addEventListener(Event.ADDED_TO_STAGE, addToStage);
		}
		
		public function update():void
		{
			if (_player.hasJob)
			{
				_hasJobContainer.alpha = 1;
				_hasJobContainer.mouseChildren = true;
				_hasJobContainer.mouseEnabled = true;
				_noJobContainer.alpha = 0;
				_noJobContainer.mouseChildren = false;
				_noJobContainer.mouseEnabled = false;
				_jobField.text = "Job: " + _player.currentJob.name + "\nPay: $" + _player.currentJob.pay;
				_jobField.update();
			
				drawPerformanceBar();
			}
			else
			{
				_hasJobContainer.alpha = 0;
				_hasJobContainer.mouseChildren = false;
				_hasJobContainer.mouseEnabled = false;
				_noJobContainer.alpha = 1;
				_noJobContainer.mouseChildren = true;
				_noJobContainer.mouseEnabled = true;
			}
		}
		
		private function addToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			
			_hasJobContainer = new Sprite();
			_hasJobContainer.graphics.beginFill(0x000000, 0);
			_hasJobContainer.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			_hasJobContainer.graphics.endFill();
			
			_jobField = new EasyTextField("");
			_jobField.size = 24;
			_jobField.x = 25;
			_jobField.update();
			_hasJobContainer.addChild(_jobField);
			
			_workButton = new EasyButton("Go To Work (8 hours)");
			_workButton.x = 25;
			_workButton.y = 75;
			_workButton.addEventListener(MouseEvent.CLICK, goToWork);
			_hasJobContainer.addChild(_workButton);
			
			_quitButton = new EasyButton("Quit Job");
			_quitButton.x = _workButton.x + _workButton.width + 10;
			_quitButton.y = _workButton.y;
			_quitButton.addEventListener(MouseEvent.CLICK, quitJob);
			_hasJobContainer.addChild(_quitButton);
			
			_jobPerformanceTitle = new EasyTextField("Job Performance:");
			_jobPerformanceTitle.x = 25;
			_jobPerformanceTitle.y = 150;
			_jobPerformanceTitle.size = 24;
			_jobPerformanceTitle.update();
			_hasJobContainer.addChild(_jobPerformanceTitle);
			
			_jobPerformance = new Sprite();
			_jobPerformance.x = 25;
			_jobPerformance.y = _jobPerformanceTitle.y + _jobPerformanceTitle.height;
			_hasJobContainer.addChild(_jobPerformance);
			
			// draw indicator lines
			_jobPerformance.graphics.beginFill(0x000000);
			_jobPerformance.graphics.drawRect(0, 32, 1, 15);
			_jobPerformance.graphics.drawRect(430, 32, 1, 15);
			_jobPerformance.graphics.endFill();
			
			// indicator labels
			var leftLabel:EasyTextField = new EasyTextField("Fired");
			leftLabel.x = _jobPerformance.x - (leftLabel.width / 2);
			leftLabel.y = _jobPerformance.y + _jobPerformance.height + 30;
			_hasJobContainer.addChild(leftLabel);
			
			var rightLabel:EasyTextField = new EasyTextField("Promoted");
			rightLabel.x = (_jobPerformance.x + _jobPerformance.width) - (rightLabel.width / 2);
			rightLabel.y = leftLabel.y;
			_hasJobContainer.addChild(rightLabel);
			
			_noJobContainer = new Sprite();
			_noJobContainer.graphics.beginFill(0x000000, 0);
			_noJobContainer.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			_noJobContainer.graphics.endFill();
			
			_noJobTitle = new EasyTextField("You have no job!");
			_noJobTitle.x = _jobField.x;
			_noJobTitle.y = _jobField.y;
			_noJobTitle.size = 24;
			_noJobContainer.addChild(_noJobTitle);
			
			_getJobButton = new EasyButton("Find a Job");
			_getJobButton.x = 25;
			_getJobButton.y = _noJobTitle.y + _noJobTitle.textHeight + 10;
			_getJobButton.addEventListener(MouseEvent.CLICK, getJob);
			_noJobContainer.addChild(_getJobButton);
			
			this.addChild(_hasJobContainer);
			this.addChild(_noJobContainer);
			
			this.update();
		}
		
		private function drawPerformanceBar():void
		{
			var innerBarWidth:Number = 428 * (_player.workPerformance / 200);
			_jobPerformance.graphics.beginFill(0x000000, 1);
			_jobPerformance.graphics.drawRect(0, 0, 431, 32);
			_jobPerformance.graphics.endFill();
			_jobPerformance.graphics.beginFill(0xffffff, 1);
			_jobPerformance.graphics.drawRect(1, 1, 429, 30);
			_jobPerformance.graphics.endFill();
			_jobPerformance.graphics.beginFill(performanceColor(_player.workPerformance), 1);
			_jobPerformance.graphics.drawRect(1, 1, innerBarWidth, 30);
			_jobPerformance.graphics.endFill();
		}
		
		private function performanceColor(performance:Number):uint
		{
			if (performance < 75)
				return 0xff0000;
			if (performance > 150)
				return 0x00ff00;
			return 0x0000ff;
		}
		
		private function quitJob(e:MouseEvent):void
		{
			var msgEvt:MessageEvent = new MessageEvent(MessageEvent.SHOW_CHOICE);
			msgEvt.title = "Quit Job?";
			msgEvt.message = "Are you sure you want to quit your job?";
			msgEvt.buttons = [ "Yes", "No" ];
			msgEvt.receiver = this;
			
			var that = this;
			function quitJobChoice(e:MessageChoiceEvent):void
			{
				that.removeEventListener(MessageChoiceEvent.CHOICE, quitJobChoice);
				if (e.choice == "Yes")
				{
					_player.hasJob = false;
					that.dispatchEvent(new UIEvent(UIEvent.SHOULD_UPDATE));
				}
			}
			
			this.addEventListener(MessageChoiceEvent.CHOICE, quitJobChoice);
			this.dispatchEvent(msgEvt);
		}
		
		private function getJob(e:MouseEvent):void
		{
			var msgEvent:MessageEvent = new MessageEvent(MessageEvent.SHOW_MESSAGE);
			msgEvent.title = "Hired!";
			msgEvent.message = "You've been rehired by your previous employer.";
			this.dispatchEvent(msgEvent);
			
			_player.hasJob = true;
			_player.workPerformance = 100;
			_player.workPosition = 0;
			_player.workedToday = false;
			this.dispatchEvent(new UIEvent(UIEvent.SHOULD_UPDATE));
		}
		
		private function goToWork(e:MouseEvent):void
		{
			if (_player.hoursLeft < 8)
			{
				this.dispatchEvent(new UIEvent(UIEvent.TIME_NEEDED));
				return;
			}
			_player.hoursLeft -= 8;
			_player.workedToday = true;
			_player.cash += _player.currentJob.pay;
			
			var evt:UIEvent = new UIEvent(UIEvent.CASH_CHANGE);
			evt.cashAmount = _player.currentJob.pay;
			evt.cashSource = "Work";
			_player.workPerformance += _player.jobPerformanceIncrease();
			if (_player.workPerformance >= 200)
			{
				if (Jobs.Positions.length <= _player.workPosition + 1)
					_player.workPerformance = 200;
				else
				{
					_player.workPosition++;
					_player.workPerformance = 100;
					var msgEvt:MessageEvent = new MessageEvent(MessageEvent.SHOW_MESSAGE);
					msgEvt.title = "Promoted!";
					msgEvt.message = "Your performance at work has earned you a promotion!\n";
					msgEvt.message += "You are now a " + _player.currentJob.name;
					msgEvt.message += ", with a salary of $" + _player.currentJob.pay + ".";
					this.dispatchEvent(msgEvt);
				}
			}
			this.dispatchEvent(evt);
			this.dispatchEvent(new UIEvent(UIEvent.SHOULD_UPDATE));
		}
	}

}
package com.animenight.igs.scenes.tabs 
{
	import adobe.utils.CustomActions;
	import com.animenight.igs.components.*;
	import com.animenight.igs.data.Jobs;
	import com.animenight.igs.Player;
	import com.animenight.igs.events.*;
	import com.animenight.igs.data.Upgrades;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class PlayerTab extends Sprite
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
		
		private var _recordUpgradeTitle:EasyTextField;
		private var _currentRecordUpgrade:UpgradeBlock;
		private var _nextRecordUpgrade:UpgradeBlock;
		private var _editUpgradeTitle:EasyTextField;
		private var _currentEditUpgrade:UpgradeBlock;
		private var _nextEditUpgrade:UpgradeBlock;
		
		public function PlayerTab(player:Player) 
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
			_nextEditUpgrade.update();
			_nextRecordUpgrade.update();
			
			_workButton.enabled = !_player.workedToday;
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
			
			_recordUpgradeTitle = new EasyTextField("Recording Upgrades");
			_recordUpgradeTitle.bold = true;
			_recordUpgradeTitle.size = 24;
			_recordUpgradeTitle.x = 20;
			_recordUpgradeTitle.y = _quitButton.y + _quitButton.height + 20;
			this.addChild(_recordUpgradeTitle);
			
			this.graphics.moveTo(_recordUpgradeTitle.x, _recordUpgradeTitle.y + _recordUpgradeTitle.textHeight + 5);
			this.graphics.lineStyle(1, 0xdddddd);
			this.graphics.lineTo(775, _recordUpgradeTitle.y + _recordUpgradeTitle.textHeight + 5);
			
			_currentRecordUpgrade = new UpgradeBlock(Upgrades.RecordingUpgrades[_player.recordUpgrade], true);
			_currentRecordUpgrade.x = 25;
			_currentRecordUpgrade.y = _recordUpgradeTitle.y + _recordUpgradeTitle.textHeight + 10;
			this.addChild(_currentRecordUpgrade);
			
			_nextRecordUpgrade = new UpgradeBlock(Upgrades.RecordingUpgrades[_player.recordUpgrade + 1], false);
			_nextRecordUpgrade.x = _currentRecordUpgrade.x + _currentRecordUpgrade.width + 20;
			_nextRecordUpgrade.y = _currentRecordUpgrade.y;
			_nextRecordUpgrade.addEventListener(UIEvent.UPGRADE_BOUGHT, upgradeBought);
			this.addChild(_nextRecordUpgrade);
			
			_editUpgradeTitle = new EasyTextField("Editing Upgrades");
			_editUpgradeTitle.bold = true;
			_editUpgradeTitle.size = 24;
			_editUpgradeTitle.x = 20;
			_editUpgradeTitle.y = _currentRecordUpgrade.y + _currentRecordUpgrade.height + 5;
			this.addChild(_editUpgradeTitle);
			
			this.graphics.moveTo(_editUpgradeTitle.x, _editUpgradeTitle.y + _editUpgradeTitle.textHeight + 5);
			this.graphics.lineStyle(1, 0xdddddd);
			this.graphics.lineTo(775, _editUpgradeTitle.y + _editUpgradeTitle.textHeight + 5);
			
			_currentEditUpgrade = new UpgradeBlock(Upgrades.EditingUpgrades[_player.editUpgrade], true);
			_currentEditUpgrade.x = _currentRecordUpgrade.x;
			_currentEditUpgrade.y = _editUpgradeTitle.y + _editUpgradeTitle.textHeight + 10;
			this.addChild(_currentEditUpgrade);
			
			_nextEditUpgrade = new UpgradeBlock(Upgrades.EditingUpgrades[_player.editUpgrade + 1], false);
			_nextEditUpgrade.x = _currentRecordUpgrade.x + _currentRecordUpgrade.width + 20;
			_nextEditUpgrade.addEventListener(UIEvent.UPGRADE_BOUGHT, upgradeBought);
			_nextEditUpgrade.y = _currentEditUpgrade.y;
			this.addChild(_nextEditUpgrade);
			
			this.update();
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
			_player.cash += (_player.currentJob.pay * 8);
			
			var evt:UIEvent = new UIEvent(UIEvent.CASH_CHANGE);
			evt.cashAmount = (_player.currentJob.pay * 8);
			evt.cashSource = "Work";
			_player.workPerformance += _player.jobPerformanceIncrease();
			if (_player.workPerformance >= 200)
			{
				if (Jobs.FastFoodPositions.length <= _player.workPosition + 1)
					_player.workPerformance = 200;
				else
				{
					_player.workPosition++;
					_player.workPerformance = 100;
					var msgEvt:MessageEvent = new MessageEvent(MessageEvent.SHOW_MESSAGE);
					msgEvt.title = "Promoted!";
					msgEvt.message = "Your performance at work has earned you a promotion!\n";
					msgEvt.message += "You are now a " + _player.currentJob.name;
					msgEvt.message += ", with a salary of $" + _player.currentJob.pay + " an hour.";
					this.dispatchEvent(msgEvt);
				}
			}
			this.dispatchEvent(evt);
			this.dispatchEvent(new UIEvent(UIEvent.SHOULD_UPDATE));
			
			_workButton.enabled = false;
		}
		
		private function upgradeBought(e:UIEvent):void
		{
			_currentEditUpgrade.updateUpgrade(Upgrades.EditingUpgrades[_player.editUpgrade], true);
			_nextEditUpgrade.updateUpgrade(Upgrades.EditingUpgrades[_player.editUpgrade + 1], false);
			_currentRecordUpgrade.updateUpgrade(Upgrades.RecordingUpgrades[_player.recordUpgrade], true);
			_nextRecordUpgrade.updateUpgrade(Upgrades.RecordingUpgrades[_player.recordUpgrade + 1], false);
			
			dispatchEvent(new UIEvent(UIEvent.SHOULD_UPDATE));
		}
	}

}
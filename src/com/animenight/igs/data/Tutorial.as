package com.animenight.igs.data 
{
	import com.animenight.igs.GraphicsExtensions;
	import com.animenight.igs.components.EasyButton;
	import com.animenight.igs.components.EasyTextField;
	import com.animenight.igs.events.MessageChoiceEvent;
	import com.animenight.igs.events.MessageEvent;
	import com.animenight.igs.scenes.GameScene;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class Tutorial extends Sprite
	{
		private var _steps:Array = [
			{ text: "To start out, let's go over the\nsections of the user interface.", x: 410, y: 410, next: true }, 
			{ text: "This is the current day.", x: 110, y: 15, next: true },
			{ text: "These tabs can be used to access different sections\nof the game.", x: 350, y: 70, next: true },
			{ text: "You can click this bar to continue to the next day.\nAt the end of the day, your video view count and subscriber count\nwill update, and you will be paid for your views.", x: 20, y: 450, next: true },
			{ text: "This is the time of the day.\nYou have sixteen hours in a day.", x: 520, y: 450, next: true },
			{ text: "This is your subscriber count.", x: 570, y: 450, next: true },
			{ text: "This is your current funds.\nAt the end of each week, weekly expenses of\n$200 will be removed from your account.\nMake sure you have enough!", x: 450, y: 420, next: true },
			{ text: "This is the player tab. Here, you can manage your job\nand upgrades.\n\nThis is your current job. If you don’t show up to work\neach day, you might get fired! Your job sucks right now,\nbut work enough and you’ll get promoted.\n\nOne day, you might make enough from your channel\nto quit your job!", x: 310, y: 70, next: true },
			{ text: "These are your upgrades. By buying better\nequipment, the quality of your videos will\nincrease.\n\nTo continue, head to the Games tab.", x: 20, y: 100, next: false, condition: function() { return GameScene.gameScene.currentTab == "Games"; } },
			{ text: "These are the games currently available. More games\nwill be released as you play. Some games are better than\nothers, and some games are more popular than others.\n\nYou will notice that you already own a game. Click on it\nto continue.", x: 20, y: 350, next: false, condition: function() { return GameScene.gameScene.currentGameSelected != null && GameScene.gameScene.currentGameSelected.owned } },
			{ text: "Because you own this game, you can create a review\nor LP series from it.\n\nContinue by clicking on \"Start LP Series\"", x: 340, y: 350, next: false, condition: function() { return GameScene.gameScene.currentlyCreatingLPSeries; } },
			{ text: "Choose a name for this series and click \"OK.\"", x: 370, y: 300, next: false, condition: function() { return GameScene.player.series.length > 0; } },
			{ text: "Click on the newly-created series and press the\n\"New Video\" button.", x: 170, y: 270, next: false, condition: function() { return GameScene.gameScene.currentlyCreatingNewSeriesVideo; } },
			{ text: "Here, you dedicate the amount of time you want to spend\non each aspect of the video. The effect of spending more time\non each portion will change with upgrades and the amount of\nexperience you have in that area.\n\nTo continue, allocate time and create the video.", x: 20, y: 450, next: false, condition: function() { return GameScene.player.videoProjects.length > 0; } },
			{ text: "Here you can see all your unreleased videos.\nClicking on the button below will automatically put an hour of work\ninto your oldest project. Once you’ve finished, you can click on the video\nand select \"Release Video\" to release it.", x: 20, y: 370, next: true },
			{ text: "Now, let's check out the last tab we haven't explored.\nlick on the \"Community\" tab.", x: 350, y: 70, next: false, condition: function() { return GameScene.gameScene.currentTab == "Community"; } },
			{ text: "On this screen, you can see stats about your videos\nand how successful they are.\n\nClick on the Internet tab to continue.", x: 20, y: 250, next: false, condition: function() { return GameScene.gameScene.currentCommunityTab == "Internet"; } },
			{ text: "In this section, you can advertise your latest\nvideo on a variety of online communities.\n\nClick on the \"Top Videos\" tab to continue.", x: 20, y: 450, next: false, condition: function() { return GameScene.gameScene.currentCommunityTab == "Top Videos"; } },
			{ text: "These are the top videos right now. If you do well,\nmaybe you'll find your videos on here!\n\nThat's the end of the tutorial! Good luck, and have fun!", x: 200, y: 400, next: true, nextLabel: "Done" }
		];
		
		private var _currentStep:Number = 0;
		private var _stepSprite:Sprite = new Sprite();
		
		public function Tutorial() 
		{
			this.addChild(_stepSprite);
		}
		
		public function prompt():void
		{
			this.addEventListener(MessageChoiceEvent.CHOICE, function(e:MessageChoiceEvent) {
				if (e.choice == "Yes, please!")
				{
					showStep(_currentStep);
				}
				else
				{
					GameScene.player.tutorialCompleted = true;
				}
			});
			
			var msgEvent:MessageEvent = new MessageEvent(MessageEvent.SHOW_CHOICE);
			msgEvent.message = "Welcome to YouTube Let's Play Simulator 2016! There's a tutorial you can go through if you don't already know how to play the game. Do you want to try it out?";
			msgEvent.buttons = [ "Yes, please!", "No, I've got it." ];
			msgEvent.title = "Tutorial";
			msgEvent.receiver = this;
			
			dispatchEvent(msgEvent);
		}
		
		public function showStep(num:Number):void
		{
			var step:Object = _steps[num];
			_stepSprite.removeChildren();
			_stepSprite.graphics.clear();
			
			var label:EasyTextField = new EasyTextField(step.text);
			label.size = 16;
			_stepSprite.addChild(label);
			
			var height:Number = label.textHeight + 20;
			
			if (step.next || step.condition())
			{
				var nextButton:EasyButton = new EasyButton(step.nextLabel || "Next");
				nextButton.y = label.textHeight + 5;
				nextButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
					_currentStep++;
					if (_currentStep >= _steps.length)
					{
						_stepSprite.visible = false;
						GameScene.player.tutorialCompleted = true;
						return;
					}
					showStep(_currentStep);
				});
				_stepSprite.addChild(nextButton);
				height = nextButton.y + nextButton.height + 10;
			}
			else
			{
				var that:Tutorial = this;
				this.addEventListener(Event.ENTER_FRAME, function conditionCheck(e:Event):void {
					if (step.condition())
					{
						that.removeEventListener(Event.ENTER_FRAME, conditionCheck);
						_currentStep++;
						showStep(_currentStep);
					}
				});
			}
			
			_stepSprite.x = step.x;
			_stepSprite.y = step.y;
			GraphicsExtensions.drawRoundedBorderedRect(_stepSprite.graphics, -5, -5, label.textWidth + 15, height, 0x000000, 0xffffff);
		}
	}
}
package com.animenight.igs 
{
	import com.animenight.igs.data.Jobs;
	import com.animenight.igs.data.Upgrades;
	import flash.media.Video;
	/**
	 * Player class.
	 * @author Andrew Rogers
	 */
	public class Player 
	{
		public const HOURS_AVAILABLE = 16;
		
		public var name:String;
		public var cash:Number = 50;
		public var subs:Number = 0;
		public var daysPlayed:Number = 0;
		public var hoursLeft:Number = HOURS_AVAILABLE;
		
		public var rentPrice:Number = 80;
		
		public var recordExperience:Number = 0;
		public var editExperience:Number = 0;
		
		public var recordUpgrade:Number = 0;
		public var editUpgrade:Number = 0;
		
		public var workExperience:Number = 0;
		public var workPerformance:Number = 100;
		public var workedToday:Boolean = false;
		public var workPosition:Number = 0;
		public var hasJob:Boolean = true;
		
		public var games:Games = new Games();
		public var series:Array = [];
		public var videoProjects:Array = [];
		
		public var aiPlayers:AIPlayers;
		
		public var aiVideoProjects:RollingArray = new RollingArray(10);
		
		public var subscriberHistory:RollingArray = new RollingArray(7, [0,0,0,0,0,0,0]);
		public var viewHistory:RollingArray = new RollingArray(7, [0, 0, 0, 0, 0, 0, 0]);
		
		public var viewerModel:Object = {
			'children': 1/6,
			'teens': 1/6,
			'young_adults': 1 / 6,
			'adults': 1 / 6,
			'middle_aged': 1 / 6,
			'elderly': 1 / 6
		};
		
		public function Player(name:String = 'Default', isAi:Boolean = false) 
		{
			this.name = name;
			if (!isAi)
			{
				this.games.generateGames();
				aiPlayers = new AIPlayers(this);
			}
		}
		
		public function generateName():void
		{
			this.name = Patterns.Username();
		}
		
		public function get currentJob():Object
		{
			return Jobs.FastFoodPositions[workPosition];
		}
		
		public function get recordMult():Number
		{
			return Upgrades.RecordingUpgrades[recordUpgrade].mult;
		}
		
		public function get editMult():Number
		{
			return Upgrades.EditingUpgrades[editUpgrade].mult;
		}
		
		public function get totalViews():Number
		{
			var totalViews:Number = 0;
			videoProjects.forEach(function(v:VideoProject, _, __) {
				totalViews += v.views;
			});
			return totalViews;
		}
		
		public function get totalIncome():Number
		{
			var totalMoney:Number = 0;
			videoProjects.forEach(function(v:VideoProject, _, __) {
				totalMoney += v.income(v.views);
			});
			return totalMoney;
		}
		
		public function jobPerformanceIncrease():Number
		{
			return 10 - (9 * workPosition) / 11;
		}
		
		public function jobPerformanceDecrease():Number
		{
			return (45 * workPosition) / 11 + 5;
		}
	}

}
package com.animenight.igs 
{
	import com.animenight.igs.data.Jobs;
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
		
		public var intelligence:Number = 0;
		public var creativity:Number = 0;
		public var humor:Number = 0;
		
		public var workExperience:Number = 0;
		public var workPerformance:Number = 100;
		public var workedToday:Boolean = false;
		public var workPosition:Number = 0;
		public var hasJob:Boolean = true;
		
		public var games:Games = new Games();
		public var series:Array = [];
		
		public function Player(name:String = 'Default') 
		{
			this.name = name;
		}
		
		public function generateName():void
		{
			this.name = Patterns.Username();
		}
		
		public function get currentJob():Object
		{
			return Jobs.Positions[workPosition];
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
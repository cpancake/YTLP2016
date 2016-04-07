package com.animenight.igs 
{
	import com.animenight.igs.components.LineChart;
	import com.animenight.igs.data.Genres;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class Game 
	{
		public var name:String;
		public var isSequel:Boolean;
		public var number:Number;
		public var genre:String;
		public var tripleA:Boolean;
		public var company:String;
		public var dayReleased:Number;
		public var quality:Number;
		public var poster:Bitmap;
		public var price:Number;
		public var owned:Boolean = false;
		
		private var _genreEffect:Number = Math.random();
		private var _qualityEffect:Number = Math.random();
		private var _genreEffectChance:Number = Math.random();
		
		public function Game(
			name:String, 
			isSequel:Boolean, 
			sequelNumber:Number, 
			tripleA:Boolean, 
			dayReleased:Number, 
			genre:String, 
			quality:Number) 
		{
			this.name = name;
			this.isSequel = isSequel;
			this.number = sequelNumber;
			this.tripleA = tripleA;
			this.dayReleased = dayReleased;
			this.genre = genre;
			this.quality = quality;
		}
		
		public function getPopularity(day:Number):Number
		{
			var daysSinceRelease = day - dayReleased;
			// quintic regression of {0, 0}, {3, 10}, {4, 10}, {8, 8}, {14, 0}
			var pop:Number = 
				-0.006 * Math.pow(daysSinceRelease, 4) + 
				0.188258 * Math.pow(daysSinceRelease, 3) -
				1.91288 * Math.pow(daysSinceRelease, 2) +
				7.55152 * daysSinceRelease;
			
			// calculate genre effect on popularity
			var popDifference:Number = Genres.OBJECT[genre].popularity - pop;
			if (_genreEffectChance < 0.8)
				pop += _genreEffect * popDifference;
				
			// calculate the quality effect on popularity;
			pop += _qualityEffect * quality - 2.5;
			return Math.min(10, pop);
		}
		
		public function getSaturation(day:Number):Number
		{
			return getPopularity(day + 1);
		}
	}

}
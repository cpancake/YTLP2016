package com.animenight.igs 
{
	import com.animenight.igs.data.Genres;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class Games 
	{
		public var indieGames:Array = [];
		public var bigGames:Array = [];
		public var bigCompanies:Array = [];
		public var indieCompanies:Array = [];
		public var companyQualities:Object = { };
		
		public function Games() 
		{
		}
		
		public function generateGames():void
		{
			for (var i = 0; i < 15; i++)
			{
				var name = uniqueCompanyName();
				bigCompanies.push(name);
				
				// company quality on a scale from 0 to 5
				var rand = Math.random();
				var quality = 0.175281 + 8.30674 * rand - 3.58427 * Math.pow(rand, 2);
				companyQualities[name] = quality;
			}
			for (var i = 0; i < 50; i++)
			{
				var name = uniqueCompanyName();
				indieCompanies.push(name);
				var rand = Math.random();
				var quality = 0.0928433 + 3.23985 * rand + 1.6441 * Math.pow(rand, 2);
				companyQualities[name] = quality;
			}
			
			for (var i = 0; i < 4; i++)
				generateGame(Math.random() < 0.1, -(Math.floor(Math.random() * 20)), false);
			generateGame(true, -(Math.floor(Math.random() * 20)), false);
			
			Util.randomArrayItem(allGames).owned = true;
		}
		
		public function get allGames():Array
		{
			return bigGames.concat(indieGames).sortOn(['dayReleased'], Array.NUMERIC | Array.DESCENDING);
		}
		
		public function hasNewGame(day:Number):Boolean
		{
			var rand:Number = Math.random();
			if (rand > 0.5)
				return false;
			if (rand > 0.1)
				generateGame(false, day);
			else
				generateGame(true, day);
			return true;
		}
		
		public function generateGame(aaa:Boolean, day:Number, generateSequels:Boolean = true):void
		{
			var sequelRand:Number = Math.random();
			if (generateSequels && sequelRand < 0.2 && ((aaa && bigGames.length > 0) || (!aaa && indieGames.length > 0)))
			{
				if (generateSequel(aaa, day))
					return;
			}
			
			var name = Util.trim(Util.toTitleCase(Patterns.Run("gameName")));
			var company:String = randomCompany(aaa);
			var game:Game = new Game(name, false, 1, aaa, day, randomGenre(), calculateGameQuality(company));
			game.company = company;
			game.genre = randomGenre();
			game.poster = PosterGenerator.generatePoster(game.name);
			game.price = generatePrice(game);
			if (aaa)
				bigGames.push(game);
			else
				indieGames.push(game);
		}
		
		private function generateSequel(aaa:Boolean, day:Number):Boolean
		{
			var games:Array = (aaa ? bigGames : indieGames);
			// find games older than 1 week
			var oldGames:Array = [];
			for (var i = 0; i < games.length; i++)
				if (day - Math.max(0, games[i].dayReleased) > 13)
					oldGames.push(games[i]);
			if (oldGames.length == 0)
				return false;
			var randomGame:Game = Util.randomArrayItem(oldGames) as Game;
			var number:Number = 2;
			var name = Util.trim(randomGame.name);
			if (randomGame.isSequel)
				number = randomGame.number + 1;
			if (Math.random() > 0.4)
			{
				name += " " + number;
				if (Math.random() > 0.7)
					name += Patterns.Run("gameSequel");
			}
			else
				name += Patterns.Run("gameSequel");
			var genre:String = (Math.random() > 0.9 ? randomGenre() : randomGame.genre);
			var company:String = (Math.random() > 0.95 ? randomCompany(aaa) : randomGame.company);
			var game:Game = new Game(Util.trim(Util.toTitleCase(name)), true, number, aaa, day, genre, calculateGameQuality(company));
			game.company = company;
			game.poster = PosterGenerator.generatePoster(game.name);
			game.price = generatePrice(game);
			if (aaa)
				bigGames.push(game);
			else
				indieGames.push(game);
			return true;
		}
		
		private function randomGenre():String
		{
			return Genres.KEYS[Math.floor(Math.random() * Genres.KEYS.length)];
		}
		
		private function randomCompany(aaa:Boolean):String
		{
			var arr = (aaa ? bigCompanies : indieCompanies);
			return arr[Math.floor(Math.random() * arr.length)];
		}
		
		private function generatePrice(game:Game):Number
		{
			if (game.tripleA)
				return 60;
			var rand = Math.floor(Math.random() * 6);
			var priceIndex:Number = 
				0.0333333 * Math.pow(rand, 5) - 
				0.458333 * Math.pow(rand, 4) +
				2.25 * Math.pow(rand, 3) -
				4.54167 * Math.pow(rand, 2) +
				3.71667 * rand;
			return [5, 10, 15, 20, 30][Math.floor(priceIndex)];
		}
		
		private function uniqueCompanyName():String
		{
			var name:String;
			do
			{
				name = Util.toTitleCase(Patterns.Run("company"));
			} while (bigCompanies.indexOf(name) != -1 || indieCompanies.indexOf(name) != -1);
			return Util.trim(name);
		}
		
		private function calculateGameQuality(company:String):Number
		{
			// calculate quality
			var rand = Math.random();
			var quality:Number = 12.1429 * rand - 7.14286 * Math.pow(rand, 2);
			
			// calculate company influence on quality
			var qualityDiff = companyQualities[company] - quality;
			quality += Math.random() * qualityDiff;
			
			return quality;
		}
	}
}
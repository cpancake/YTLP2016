package com.animenight.igs 
{
	import com.adobe.images.PNGEncoder;
	import com.animenight.igs.data.Genres;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
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
		
		public function gameFromId(id:String):Game
		{
			var games:Array = allGames;
			for (var i:Number = 0; i < games.length; i++)
			{
				if (games[i].gameId == id)
				{
					return games[i];
				}
			}
			return null;
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
		
		public static function read(input:ByteArray):Games
		{
			var games:Games = new Games();
			
			var bigCompanyCount = input.readUnsignedInt();
			for (var i:Number = 0; i < bigCompanyCount; i++)
			{
				games.bigCompanies.push(input.readUTF());
			}
			
			var indieCompanyCount = input.readUnsignedInt();
			for (var i:Number = 0; i < indieCompanyCount; i++)
			{
				games.indieCompanies.push(input.readUTF());
			}
			
			var bigGameCount = input.readUnsignedInt();
			for (var i:Number = 0; i < bigGameCount; i++)
			{
				games.bigGames.push(readGame(input));
			}
			
			var indieGameCount = input.readUnsignedInt();
			for (var i:Number = 0; i < indieGameCount; i++)
			{
				games.indieGames.push(readGame(input));
			}
			
			games.companyQualities = {};
			var keyCount:Number = input.readUnsignedInt();
			for (var i:Number = 0; i < keyCount; i++)
			{
				var key:String = input.readUTF();
				var value:Number = input.readDouble();
				games.companyQualities[key] = value;
			}
			
			return games;
		}
		
		public function export(output:ByteArray):void
		{
			// aaa companies
			output.writeUnsignedInt(bigCompanies.length);
			for (var i:Number = 0; i < bigCompanies.length; i++)
			{
				output.writeUTF(bigCompanies[i]);
			}
			
			// indie companies
			output.writeUnsignedInt(indieCompanies.length);
			for (var i:Number = 0; i < indieCompanies.length; i++)
			{
				output.writeUTF(indieCompanies[i]);
			}
			
			// aaa games
			output.writeUnsignedInt(bigGames.length);
			for (var i:Number = 0; i < bigGames.length; i++)
			{
				writeGame(bigGames[i], output);
			}
			
			// indie games
			output.writeUnsignedInt(indieGames.length);
			for (var i:Number = 0; i < indieGames.length; i++)
			{
				writeGame(indieGames[i], output);
			}
			
			var companyKeys:Array = Util.objectKeys(companyQualities);
			output.writeUnsignedInt(companyKeys.length);
			for (var i:Number = 0; i < companyKeys.length; i++)
			{
				output.writeUTF(companyKeys[i]);
				output.writeDouble(companyQualities[companyKeys[i]]);
			}
		}
		
		private static function readGame(input:ByteArray):Game
		{
			var id:String = input.readUTF();
			var name:String = input.readUTF();
			var company:String = input.readUTF();
			var genre:String = input.readUTF();
			var tripleA:Boolean = input.readBoolean();
			var isSequel:Boolean = input.readBoolean();
			var owned:Boolean = input.readBoolean();
			var reviewed:Boolean = input.readBoolean();
			var lped:Boolean = input.readBoolean();
			var dayReleased:Number = input.readInt();
			var quality:Number = input.readDouble();
			var price:Number = input.readDouble();
			var number:Number = input.readDouble();
			var dataLength:uint = input.readUnsignedInt();
			var data:BitmapData = new BitmapData(PosterGenerator.POSTER_RECT.width, PosterGenerator.POSTER_RECT.height);
			var pixelData:ByteArray = new ByteArray();
			input.readBytes(pixelData, 0, dataLength);
			data.setPixels(PosterGenerator.POSTER_RECT, pixelData);
			var poster:Bitmap = new Bitmap(data);
			
			var game:Game = new Game(name, isSequel, number, tripleA, dayReleased, genre, quality);
			game.quality = quality;
			game.company = company;
			game.gameId = id;
			game.owned = owned;
			game.reviewed = reviewed;
			game.lped = lped;
			game.price = price;
			game.poster = poster;
			return game;
		}
		
		private function writeGame(game:Game, output:ByteArray):void
		{
			output.writeUTF(game.gameId);
			output.writeUTF(game.name);
			output.writeUTF(game.company);
			output.writeUTF(game.genre);
			output.writeBoolean(game.tripleA);
			output.writeBoolean(game.isSequel);
			output.writeBoolean(game.owned);
			output.writeBoolean(game.reviewed);
			output.writeBoolean(game.lped);
			output.writeInt(game.dayReleased);
			output.writeDouble(game.quality);
			output.writeDouble(game.price);
			output.writeDouble(game.number);
			//output.writeBytes(PNGEncoder.encode(game.poster.bitmapData));
			var pixels:ByteArray = game.poster.bitmapData.getPixels(PosterGenerator.POSTER_RECT);
			output.writeUnsignedInt(pixels.length);
			output.writeBytes(pixels);
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
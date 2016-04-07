package com.animenight.igs 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class Comments 
	{
		[Embed(source="../../../../resources/comments.json", mimeType="application/octet-stream")]
		private static var _databaseClass:Class;
		
		private static var _database:Object;
		
		public function Comments() 
		{
		}
		
		private static function selectKey(population:Object)
		{
			var sum = 0, probSum = 0, probabilities = [];
			Util.objectKeys(population).forEach(function(key, _, __) {
				sum += population[key];
			});
			Util.objectKeys(population).forEach(function(key, i, __) {
				probabilities[i] = sum + (population[key] / sum);
				probSum = probabilities[i];
			});
			var rand = Math.random();
			for (var i = 0; i < population.length; i++)
			{
				if (!probabilities[i + 1] || rand < probabilities[i + 1])
					return Util.objectKeys(population)[i];
			}
			return Util.objectKeys(population)[0];
		}
		
		public static function generate(targetLength:Number):String
		{
			if (!_database)
				_database = JSON.parse((new _databaseClass() as ByteArray).toString())['gaming'];
				
			var keys:Array = Util.shuffle(Util.objectKeys(_database));
			var totalLength = 0;
			
			function generatePortion(start)
			{
				var startKeys = Util.objectKeys(_database[start]).filter(function(obj:Object, _, __) {
					return typeof _database[start] !== 'undefined';
				});
				var key;
				if (startKeys.length == 0)
				{
					var newKey = Util.shuffle(Util.objectKeys(_database))[0];
					key = { };
					key[newKey] = 1;
				}
				else
				{
					key = { };
					startKeys.forEach(function(k, _, __) {
						key[k] = _database[start][k];
					});
				}
				
				var nextKey = null;
				var timesThrough = 0;
				while (!nextKey)
				{
					nextKey = selectKey(key);
					if (timesThrough++ > 100) nextKey = Util.shuffle(keys)[0];
				}
				
				var text = start + ' ';
				totalLength += text.length;
				if (totalLength >= targetLength)
					return text + nextKey;
				return text + generatePortion(nextKey);
			}
			
			return generatePortion(keys[0]);
		}
	}

}
package com.animenight.rantlite 
{
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class RantFunctions 
	{
		private var functions:Object;
		
		public function RantFunctions()
		{
			functions = {
				n: this.num,
				num: this.num,
				'case': this.caseFunction
			};
		}
		
		public function hasFunction(name:String):Boolean
		{
			return functions.hasOwnProperty(name);
		}
		
		public function getFunction(name:String):Function
		{
			return functions[name];
		}
		
		private function num(min:Function, max:Function):Number
		{
			var minN = parseInt(min());
			var maxN = parseInt(max()) - minN;
			
			return Math.floor(Math.random() * maxN) + minN;
		}
		
		private function caseFunction(mode:Function, pattern:Function):String
		{
			var modeS:String = mode();
			var resultS:String = pattern();
			if (modeS == 'lower')
				return resultS.toLowerCase();
			if (modeS == 'upper')
				return resultS.toUpperCase();
			if (modeS == 'first')
			{
				var cap = resultS.charAt(0).toUpperCase();
				return cap + resultS.substr(1).toLowerCase();
			}
			if (modeS == 'word')
			{
				var words = resultS.split(' ');
				words = words.map(function(word:String, index:int, array:Array) {
					if (word.length == 0) return '';
					var cap = word.charAt(0).toUpperCase();
					return cap + resultS.substr(1).toLowerCase();
				});
			}
			return resultS;
		}
	}

}
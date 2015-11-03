package com.animenight.rantlite 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class Rant 
	{
		[Embed(source="../../../../resources/rantionary.rantpkg", mimeType="application/octet-stream")]
		private var _rantpkg:Class;
		
		private var _vocab:RantVocab;
		
		public function Rant() 
		{
			var byteArray:ByteArray = new _rantpkg();
			_vocab = new RantVocab(byteArray);
		}
		
		public function Do(code:String):String
		{
			var tree = new RantParser(code, _vocab).getTree();
			return runTree(tree);
		}
		
		public function Compile(code:String):Function
		{
			var tree = new RantParser(code, _vocab).getTree();
			return function() {
				return runTree(tree);
			}
		}
		
		private function runTree(tree:Array):String
		{
			var result = '';
			tree.forEach(function(d) { result += d(); } );
			return result;
		}
	}

}
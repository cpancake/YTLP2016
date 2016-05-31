package com.animenight.rantlite 
{
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class RantParser 
	{
		private var _vocab:RantVocab;
		private var _code:String;
		private var _functions:RantFunctions = new RantFunctions();
		
		public function RantParser(code:String, vocab:RantVocab) 
		{
			_vocab = vocab;
			_code = code;
		}
		
		public function getTree():Array
		{
			var grammar = new RantGrammar();
			var tree:Array = grammar.parse(_code);
			return tree.map(parseTreeItem);
		}
		
		private function parseTreeItem(item:*, index:int, array:Array):Function
		{
			if (item == null) return makeTextAction('');
			if (item is String)
				return makeTextAction(item);
			if (item is Array)
			{
				var items = item.map(parseTreeItem);
				return makeSequenceAction(items);
			}
			if (item.type == 'text')
				return makeTextAction(item.value);
			if (item.type == 'query')
				return makeQueryAction(item.name, item.subtype, item.classes);
			if (item.type == 'block')
			{
				var items = item.items.map(parseTreeItem);
				return makeBlockAction(items, item.weights);
			}
			if (item.type == 'function')
			{
				var args = item.args.map(parseTreeItem);
				return makeFunctionAction(item.name, args);
			}
			throw new Error("Unknown parser item type: " + item.type);
		}
		
		private function makeTextAction(text:String):Function
		{
			return function() { return text; }
		}
		
		private function makeQueryAction(name:String, subtype:String, classes:Array):Function
		{
			var query = new RantQuery(name, subtype, classes, _vocab);
			return function() {
				return query.getResult();
			}
		}
		
		private function makeBlockAction(items:Array, weights:Array):Function
		{
			var weightsTotal:Number = 0;
			for (var i = 0; i < weights.length; i++)
				weightsTotal += weights[i];
			return function() {
				var randomWeight:Number = Math.random() * weightsTotal;
				weightsTotal = 0;
				var randomItem:Function;
				for (var i = 0; i < weights.length; i++)
				{
					weightsTotal += weights[i];
					if (randomWeight < weightsTotal)
					{
						randomItem = items[i];
						break;
					}
				}
				if(!randomItem)
					randomItem = items[items.length - 1];
				return randomItem();
			}
		}
		
		private function makeSequenceAction(items:Array):Function
		{
			return function() {
				var content:String = '';
				items.forEach(function(i) { content += i(); } );
				return content;
			}
		}
		
		private function makeFunctionAction(name:String, args:Array):Function
		{
			return function() {
				if (!_functions.hasFunction(name)) throw new Error('Unknown function ' + name);
				return _functions.getFunction(name).apply(this, args);
			};
		}
	}

}
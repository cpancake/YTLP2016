package com.animenight.rantlite 
{
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class RantQuery 
	{
		private var name:String;
		private var subtype:String;
		private var classes:Array;
		private var vocab:RantVocab;
		
		public function RantQuery(name:String, subtype:String, classes:Array, vocab:RantVocab)
		{
			this.name = name;
			this.subtype = subtype;
			this.classes = classes;
			this.vocab = vocab;
		}
		
		public function getResult():String
		{
			if(!vocab.hasTable(name)) return '[Missing Table]';
			var table:Object = vocab.getTable(name);
			var subtypeIndex:Number = subtype == '' ? 0 : table.subs.indexOf(subtype);
			if(subtypeIndex == -1) return '[Missing Subtype]';
			var entries:Array = table.entries;
			// find things that have the classes we want
			classes.forEach(function(c) {
				entries = entries.filter(function(f) {
					return f.classes.indexOf(c) != -1;
				});
			});
			// find things that don't have the classes we don't want
			table.hiddenClasses.forEach(function(c) {
				if (classes.indexOf(c) != -1) return;
				entries = entries.filter(function(f) {
					return f.classes.indexOf(c) == -1;
				});
			});
			if(entries.length == 0) return '[?]';
			return entries[Math.floor(Math.random() * entries.length)].terms[subtypeIndex].value;
		}
	}

}
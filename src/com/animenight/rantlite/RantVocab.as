package com.animenight.rantlite 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import com.probertson.utils.GZIPBytesEncoder;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class RantVocab 
	{
		private const MAGIC:uint = 0x474b5052;
		
		private var _patterns:Object;
		private var _dictionaries:Object;
		
		public function RantVocab(bytes:ByteArray) 
		{
			bytes.endian = Endian.LITTLE_ENDIAN;
			var decompressed:ByteArray = new GZIPBytesEncoder().uncompressToByteArray(bytes);
			decompressed.endian = Endian.LITTLE_ENDIAN;
			readPackage(decompressed);
		}
		
		public function getTable(name:String):Object
		{
			return _dictionaries[name];
		}
		
		public function hasTable(name:String):Boolean
		{
			return _dictionaries.hasOwnProperty(name);
		}
		
		private function readPackage(buffer:ByteArray):void
		{
			var possiblyMagic:uint = buffer.readUnsignedInt();
			if (possiblyMagic != MAGIC)
				throw new Error("Invalid magic number.");
			var numPatterns:uint = buffer.readUnsignedInt();
			var numTables:uint = buffer.readUnsignedInt();
			_patterns = { };
			for (var i = 0; i < numPatterns; i++)
			{
				var name:String = readString(buffer);
				var code:String = readString(buffer);
				_patterns[name] = code;
			}
			
			_dictionaries = { };
			for (var i = 0; i < numTables; i++)
			{
				var name:String = readString(buffer);
				var subs:Array = readStringArray(buffer);
				var numEntries:uint = buffer.readUnsignedInt();
				var hiddenClasses:Array = readStringArray(buffer);
				var entries = [];
				for (var j = 0; j < numEntries; j++)
				{
					var weight:uint = buffer.readUnsignedInt();
					buffer.readUnsignedByte();
					var numTerms:uint = buffer.readUnsignedInt();
					var terms:Array = [];
					for (var k = 0; k < numTerms; k++)
					{
						var val:String = readString(buffer);
						var pron:String = readString(buffer);
						terms.push( {
							value: val,
							pronunciation: pron
						});
					}
					
					var classes:Array = readStringArray(buffer);
					
					entries.push( {
						terms: terms,
						classes: classes,
						weight: weight
					});
				}
				
				_dictionaries[name] = {
					name: name,
					subs: subs,
					entries: entries,
					hiddenClasses: hiddenClasses
				};
			}
		}
		
		private function readString(buffer:ByteArray):String
		{
			var length:uint = buffer.readUnsignedInt();
			if (length == 0) return "";
			return buffer.readMultiByte(length, "utf-16");
		}
		
		private function readStringArray(buffer:ByteArray):Array
		{
			var length:uint = buffer.readUnsignedInt();
			var strs:Array = [];
			for (var i = 0; i < length; i++)
				strs.push(readString(buffer));
			return strs;
		}
	}

}
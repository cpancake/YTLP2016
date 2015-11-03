package com.animenight.rantlite 
{
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class RantSyntaxError extends Error
	{
		public var expected:String;
		public var found:String;
		public var offset:Number;
		public var line:Number;
		public var column:Number;
		
		public function RantSyntaxError(message:String, expected:String, found:String, offset:Number, line:Number, column:Number) {
			this.message  = message;
			this.expected = expected;
			this.found    = found;
			this.offset   = offset;
			this.line     = line;
			this.column   = column;
		}
	}

}
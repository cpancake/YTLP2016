package com.animenight.igs.data 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Job 
	{
		public var name:String;
		public var desc:String;
		public var pay:Number;
		public var expNeeded:Number;
		public var intNeeded:Number;
		public var crNeeded:Number;
		
		public function Job(name:String, desc:String, pay:Number, expNeeded:Number, intNeeded:Number, crNeeded:Number) 
		{
			this.name = name;
			this.desc = desc;
			this.pay = pay;
			this.expNeeded = expNeeded;
			this.intNeeded = intNeeded;
			this.crNeeded = crNeeded;
		}
		
	}

}
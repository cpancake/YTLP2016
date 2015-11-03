package com.animenight.igs.events 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class KillMeEvent extends Event 
	{
		public static const KILL_ME:String = "killMe";
		public var me:DisplayObject;
		
		public function KillMeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new KillMeEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("KillMeEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
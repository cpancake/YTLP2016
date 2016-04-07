package com.animenight.igs.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class MessageChoiceEvent extends Event 
	{
		public static const CHOICE:String = "choice";
		
		public var choice:String = "";
		public var input:String = "";
		
		public function MessageChoiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new MessageChoiceEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MessageChoiceEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
package com.animenight.igs.events 
{
	import com.animenight.igs.Player;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class UIEvent extends Event 
	{
		public static const SHOULD_UPDATE:String = "shouldUpdate";
		public static const CASH_CHANGE:String = "cashChange";
		public static const TIME_NEEDED:String = "timeNeeded";
		public static const UPGRADE_BOUGHT:String = "upgradeBought";
		public static const GO_TO_UNRELEASED:String = "goToUnreleased";
		public static const GO_TO_SERIES:String = "goToSeries";
		public static const PLAYER_START:String = "playerStart";
		public static const RETURN_TO_MENU:String = "returnToMenu";
		
		public var cashAmount:Number = 0;
		public var cashSource:String = "none";
		public var player:Player = null;
		
		public function UIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new UIEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("UIShouldUpdateEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
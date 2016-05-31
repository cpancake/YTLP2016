package com.animenight.igs.events 
{
	import com.animenight.igs.VideoProject;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class MessageEvent extends Event 
	{
		public static const SHOW_MESSAGE = "showMessage";
		public static const SHOW_CHOICE = "showChoice";
		public static const SHOW_INPUT = "showInput";
		public static const SHOW_VIDEO = "showVideo";
		
		public var title:String = "title";
		public var message:String = "";
		public var buttons:Array = [];
		public var receiver:DisplayObject = null;
		public var placeholder:String = "";
		public var video:VideoProject;
		
		public function MessageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new MessageEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GameEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
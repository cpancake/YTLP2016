package com.animenight.igs.events 
{
	import com.animenight.igs.VideoProject;
	import com.animenight.igs.VideoSeries;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class NewVideoEvent extends Event 
	{
		public static const NEW_VIDEO:String = "newVideo";
		public static const NEW_VIDEO_SERIES:String = "newVideoSeries";
		public static const RELEASE_VIDEO:String = "releaseVideo";
		public var video:VideoProject;
		public var videoSeries:VideoProject;
		
		public function NewVideoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new NewVideoEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("NewVideoEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
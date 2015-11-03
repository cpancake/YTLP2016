package com.animenight.igs 
{
	import flash.crypto.generateRandomBytes;
	import flash.globalization.NumberFormatter;
	import flash.system.System;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class Util 
	{
		private static var _numberFormatter:NumberFormatter = null;
		
		public static function formatNumber(number:Number):String
		{
			if (_numberFormatter == null)
				_numberFormatter = new NumberFormatter('en-US');
			return _numberFormatter.formatNumber(number);
		}
		
		public static function formatTime(hour:Number):String
		{
			if (hour == 0 || hour == 24)
				return "12:00 AM";
			if (hour == 12)
				return "12:00 PM";
			if (hour < 12)
				return hour + ":00 AM";
			return (hour % 12) + ":00 PM";
		}
		
		public static function lerp(amount:Number, start:Number, end:Number):Number 
		{
			if (start == end)
				return start;
			return ((1 - amount) * start) + (amount * end);
		}
		
		[Inline]
		public static function trim(str:String):String
		{
			return str.replace(/^\s+|\s+$/g, '');
		}
		
		[Inline]
		public static function randomArrayItem(a:Array):Object
		{
			return a[Math.floor(Math.random() * a.length)];
		}
		
		public static function toTitleCase(string):String
		{
			return string.toLowerCase().replace(/_/g, ' ').replace(/(\s(?:de|a|o|from|in|the|e|da|do|em|ou|[\u00C0-\u00ff]))\b/ig, function (_, match) {
				return match.toLowerCase();
			}).replace(/\b([a-z\u00C0-\u00ff])/g, function (_, initial) {
				return initial.toUpperCase();
			}).replace(/'S/g, '\'s');
		}
		
		public static function daysAgo(today:Number, day:Number):String
		{
			var daysAgo:Number = (today - day);
			if (daysAgo == 0)
				return "today";
			return daysAgo + " days ago";
		}
		
		[Inline]
		public static function randomSeed():Number
		{
			return generateRandomBytes(4).readUnsignedInt();
		}
		
		[Inline]
		public static function randomer():Number
		{
			return randomSeed() / 0xffffffff;
		}
		
		[Inline]
		public static function extractColorComponents(color:uint):Array
		{
			return [ ((color >> 16) & 0xff), ((color >> 8) & 0xff), (color & 0xff) ];
		}
		
		[Inline]
		public static function red(color:uint):uint
		{
			return (color >> 16) & 0xff;
		}
		
		[Inline]
		public static function green(color:uint):uint
		{
			return (color >> 8) & 0xff;
		}
		
		[inline]
		public static function blue(color:uint):uint
		{
			return color & 0xff;
		}
		
		[Inline]
		public static function combineColorComponents(red:uint, green:uint, blue:uint):uint
		{
			return ((red << 16) | (green << 8) | blue);
		}
	}
}
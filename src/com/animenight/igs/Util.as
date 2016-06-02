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
		
		public static function formatMoney(number:Number):String
		{
			if (_numberFormatter == null)
				_numberFormatter = new NumberFormatter('en-US');
			return _numberFormatter.formatNumber(number);
		}
		
		public static function formatNumber(number:Number):String
		{
			if (_numberFormatter == null)
				_numberFormatter = new NumberFormatter('en-US');
			var cash:String = _numberFormatter.formatInt(int(number));
			return cash.substr(0, cash.indexOf("."));
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
		
		public static function generateRandomString(length:Number):String
		{
			var chars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
			var num_chars:Number = chars.length - 1;
			var randomChar:String = "";

			for (var i:Number = 0; i < length; i++)
			{
				randomChar += chars.charAt(Math.floor(Util.randomer() * num_chars));
			}
			return randomChar;
		}
		
		public static function generateUniqueId(player:Player):String
		{
			var id:String = "";
			do
			{			
				id = generateRandomString(10);
			}
			while (player.videoProjects.filter(function(v:VideoProject, _, __) { return v.id == id; }).length > 0);
			return id;
		}
		
		public static function toTitleCase(string):String
		{
			return string.toLowerCase().replace(/_/g, ' ').replace(/(\s(?:de|a|o|from|in|the|e|da|do|em|ou|[\u00C0-\u00ff]))\b/ig, function (_, match) {
				return match.toLowerCase();
			}).replace(/(\b|^)([a-z\u00C0-\u00ff])/g, function (_, _, initial) {
				return initial.toUpperCase();
			}).replace(/'S/g, '\'s').replace(/\^/g, "");
		}
		
		public static function daysAgo(today:Number, day:Number):String
		{
			var daysAgo:Number = (today - day);
			if (daysAgo == 0)
				return "today";
			return daysAgo + " days ago";
		}
		
		public static function dimret(x:Number, max:Number):Number
		{
			var realMax:Number = max - 1;
			return Math.max(0, realMax + (1 - 1 / ((1 / realMax) * x)));
		}
		
		public static function dimretScale(x:Number, max:Number, scale:Number):Number
		{
			var xIntercept:Number = scale / max;
			return max - scale / (x + xIntercept);
		}
		
		public static function objectKeys(obj:Object):Array
		{
			var keys = [];
			for (var k in obj)
				keys.push(k);
			return keys;
		}
		
		public static function shuffle(o:Array):Array
		{
			for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
			return o;
		}
		
		public static function shuffleTwo(obj1, obj2):void 
		{
			var l = obj1.length,
				i = 0,
				rnd,
				tmp1,
				tmp2;

			while (i < l) {
				rnd = Math.floor(Math.random() * i);
				tmp1 = obj1[i];
				tmp2 = obj2[i];
				obj1[i] = obj1[rnd];
				obj2[i] = obj2[rnd];
				obj1[rnd] = tmp1;
				obj2[rnd] = tmp2;
				i += 1;
			}
		}
		
		public static function stringMult(s:String, m:Number):String
		{
			var a:Array = [];
			for (var i = 0; i < m; i++)
				a.push(s);
			return a.join(" ");
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
		
		[Inline]
		public static function blue(color:uint):uint
		{
			return color & 0xff;
		}
		
		[Inline]
		public static function combineColorComponents(red:uint, green:uint, blue:uint):uint
		{
			return ((red << 16) | (green << 8) | blue);
		}
		
		public static function shallowClone(obj:Object):Object
		{
			var newObj:Object = {};
			for (var k in obj)
			{
				newObj[k] = obj[k];
			}
			return newObj;
		}
		
		public static function maxLength(s:String, l:Number):String
		{
			if (s.length < l) return s;
			return s.substr(0, l - 3) + "...";
		}
		
		public static function keyOrDefault(obj:Object, k:String, d:Object):Object
		{
			if (obj.hasOwnProperty(k))
				return obj[k];
			return d;
		}
	}
}
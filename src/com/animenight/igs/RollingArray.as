package com.animenight.igs 
{
	/**
	 * An array that holds a fixed number of items, where the older items will be forced off as new ones come in.
	 * @author Andrew Rogers
	 */
	public class RollingArray 
	{
		private var _array:Array = [];
		private var _length:Number;
		
		public function RollingArray(length:Number = 1, initialData:Array = null) 
		{
			_length = length;
			_array = (initialData || []);
		}
		
		public function push(obj:Object):void
		{
			_array.push(obj);
			while (_array.length > _length)
			{
				_array.shift();
			}
		}
		
		public function get data():Array
		{
			return _array;
		}
	}

}
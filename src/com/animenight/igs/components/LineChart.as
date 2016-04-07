package com.animenight.igs.components 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class LineChart extends Sprite
	{
		private var _width:int;
		private var _height:int;
		private var _maxX:int;
		private var _maxY:int;
		private var _color:uint;
		private var _thickness:int;
		
		private var _points:Array = [];
		
		public function LineChart(width:int, height:int, maxX:int, maxY:int, color:uint, thickness:int = 1) 
		{
			this._width = width;
			this._height = height;
			this._maxX = maxX;
			this._maxY = maxY;
			this._color = color;
			this._thickness = thickness;
		}
		
		public function update():void
		{
			this.graphics.clear();
			
			if (_points.length > 1)
			{
				for (var i = 1; i < _points.length; i++)
				{
					var point1:Point = getPointXY(i - 1);
					var point2:Point = getPointXY(i);
					this.graphics.lineStyle(_thickness, _color);
					this.graphics.moveTo(point1.x, point1.y);
					this.graphics.lineTo(point2.x, point2.y);
				}
			}
			
			var lastPoint = getPointXY(_points.length - 1);
			this.graphics.beginFill(_color);
			this.graphics.drawCircle(lastPoint.x, lastPoint.y, _thickness + 2);
			this.graphics.endFill();
		}
		
		public function addPoint(point:Number):void
		{
			_points.push(point);
			update();
		}
		
		private function getPointXY(x:Number):Point
		{
			return new Point((x / _maxX) * width, (_points[x] / _maxY) * height);
		}
	}

}
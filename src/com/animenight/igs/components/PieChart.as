package com.animenight.igs.components 
{
	import com.terrypaton.graphics.DrawPieChart;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class PieChart extends Sprite
	{
		private var _radius:Number = 0;
		private var _segments:Array = [];
		private var _title:String = "";
		
		public function PieChart(radius:Number, title:String) 
		{
			_radius = radius;
			_title = title;
		}
		
		public function update(segments:Array)
		{
			this.removeChildren();
			this.graphics.clear();
			
			var baseX:Number = _radius;
			var baseY:Number = _radius;
			
			var title:EasyTextField = new EasyTextField(_title);
			title.autoSize = TextFieldAutoSize.CENTER;
			title.alignment = TextFormatAlign.CENTER;
			title.size = 20;
			title.x = _radius - (title.textWidth / 2);
			title.update();
			this.addChild(title);
			
			baseY += title.textHeight + 10;
			
			// draw border
			this.graphics.beginFill(0x000000);
			this.graphics.drawCircle(baseX, baseY, _radius + 1);
			this.graphics.endFill();
			
			var offset:Number = -90;
			var nextLabelPos:Number = _radius;
			segments.forEach(function(s:Object, _, __) {
				var percent:Number = s.percent;
				var color:uint = s.color;
				var label:String = s.label;
				var segment:Shape = new Shape();
				segment.x = baseX;
				segment.y = baseY;
				addChild(segment);
				DrawPieChart.drawChart(segment, _radius, percent, color, offset);
				offset += 360 * percent;
				
				// draw label
				if (label != null)
				{
					graphics.beginFill(color);
					graphics.drawRect(baseX + _radius + 10, baseY + nextLabelPos - 10, 10, 10);
					graphics.endFill();
					var textField:EasyTextField = new EasyTextField(label);
					textField.size = 9;
					textField.x = baseX + _radius + 25;
					textField.y = baseY + nextLabelPos - 12;
					addChild(textField);
					nextLabelPos -= 15;
				}
			});
		}
	}

}
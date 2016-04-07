package com.animenight.igs.components 
{
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class EasyInputField extends EasyTextField
	{
		
		public function EasyInputField(width:Number) 
		{
			super("");
			this.multiline = false;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.text = "W";
			var height:Number = this.textHeight;
			this.autoSize = TextFieldAutoSize.NONE;
			this.type = TextFieldType.INPUT;
			this.width = width;
			this.height = height + 5;
			this.borderColor = 0x000000;
			this.border = true;
			this.mouseEnabled = true;
			this.selectable = true;
		}
	}
}
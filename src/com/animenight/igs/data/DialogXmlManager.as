package com.animenight.igs.data 
{
	import flash.xml.XMLNode;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class DialogXmlManager 
	{
		private var _xml:XML;
		private var _dialog:Object = {};
		
		public function DialogXmlManager(xml:XML) 
		{
			_xml = xml;
			
			for (var i:Number = 0; i < _xml.length(); i++) {
				_dialog[_xml.dialog[i].@id[0].toString()] = _xml.dialog[i][0].toString();
			}
			1 + 1;
		}
		
		public function getDialog(name:String):String
		{
			return _dialog[name];
		}
	}

}
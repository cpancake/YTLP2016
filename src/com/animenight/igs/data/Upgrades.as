package com.animenight.igs.data 
{
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class Upgrades 
	{
		[Embed(source="../../../../../resources/upgrades/record1.jpg")]
		private static var _recordIcon1:Class;
		[Embed(source="../../../../../resources/upgrades/record2.jpg")]
		private static var _recordIcon2:Class;
		[Embed(source="../../../../../resources/upgrades/record3.jpg")]
		private static var _recordIcon3:Class;
		[Embed(source="../../../../../resources/upgrades/record4.jpg")]
		private static var _recordIcon4:Class;
		[Embed(source="../../../../../resources/upgrades/record5.jpg")]
		private static var _recordIcon5:Class;
		[Embed(source="../../../../../resources/upgrades/record6.jpg")]
		private static var _recordIcon6:Class;
		
		[Embed(source = "../../../../../resources/upgrades/edit1.jpg")]
		private static var _editIcon1:Class;
		[Embed(source = "../../../../../resources/upgrades/edit2.jpg")]
		private static var _editIcon2:Class;
		[Embed(source = "../../../../../resources/upgrades/edit3.jpg")]
		private static var _editIcon3:Class;
		[Embed(source = "../../../../../resources/upgrades/edit4.jpg")]
		private static var _editIcon4:Class;
		[Embed(source = "../../../../../resources/upgrades/edit5.jpg")]
		private static var _editIcon5:Class;
		[Embed(source = "../../../../../resources/upgrades/edit6.jpg")]
		private static var _editIcon6:Class;
		
		public static var RecordingUpgrades = [
			{ type: "record", name: "Camcorder", desc: "Just point it at your screen and press play. High quality!" , price: 0, mult: 1, icon: new _recordIcon1() },
			{ type: "record", name: "Cheap Headset", desc: "Sure, the microphone is held on by duct tape, and there's a constant high-pitched whine - but it's cheap!", price: 500, mult: 1.25, icon: new _recordIcon2() },
			{ type: "record", name: "Unregistered Supercam 2", desc: "You might wonder 'if it's unregistered, why does it cost so much?' And the answer is 'shut up.'", price: 2000, mult: 2, icon: new _recordIcon3() },
			{ type: "record", name: "Overpriced Headset", desc: "They might be pricey, but they've got Dr. Dre's name on them!", price: 10000, mult: 3, icon: new _recordIcon4() },
			{ type: "record", name: "Capture Card", desc: "Think of all the things you can record now! Consoles, a computer... that's about it, I guess.", price: 50000, mult: 5, icon: new _recordIcon5() },
			{ type: "record", name: "Studio Microphone", desc: "Now everyone can listen to your gross mouth noises.", price: 100000, mult: 10, icon: new _recordIcon6() }
		];
		
		public static var EditingUpgrades = [
			{ type: "edit", name: "Windows Movie Maker", desc: "Why would you ever need anything more?", price: 0, mult: 1, icon: new _editIcon1() },
			{ type: "edit", name: "Pirated Software: A How-To", desc: "Presented for educational purposes only.", price: 500, mult: 1.25, icon: new _editIcon2() },
			{ type: "edit", name: "1,000 Clip Art Images on CD", desc: "This is exactly what you need to make your videos 'pop'!", price: 2000, mult: 2, icon: new _editIcon3() },
			{ type: "edit", name: "Sony Reno", desc: "Think of all the new transitions you'll be able to use!", price: 10000, mult: 3, icon: new _editIcon4() },
			{ type: "edit", name: "Scarecam: The Definitive Guide", desc: "Now this is what being a YouTube star is all about!", price: 50000, mult: 5, icon: new _editIcon5() },
			{ type: "edit", name: "Adobe Khrushchev", desc: "Nobody is going to get this joke.", price: 100000, mult: 10, icon: new _editIcon6() }
		];
		
		public function Upgrades() 
		{
			
		}
		
	}

}
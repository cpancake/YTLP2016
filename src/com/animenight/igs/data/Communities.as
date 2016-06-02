package com.animenight.igs.data 
{
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class Communities 
	{
		[Embed(source="../../../../../resources/communities/builddigforums.png")]
		private static var _buildDigForumsIcon:Class;
		[Embed(source = "../../../../../resources/communities/chestkick.png")]
		private static var _chestkickIcon:Class;
		[Embed(source = "../../../../../resources/communities/clover6.png")]
		private static var _clover6Icon:Class;
		[Embed(source = "../../../../../resources/communities/everything_terrible.png")]
		private static var _everythingTerribleIcon:Class;
		[Embed(source = "../../../../../resources/communities/hipoldz.png")]
		private static var _hipOldzIcon:Class;
		[Embed(source = "../../../../../resources/communities/loddit.png")]
		private static var _lodditIcon:Class;
		
		public static const KEYS:Array = [
			'loddit',
			'builddigforums',
			'everything_terrible',
			'hipoldz',
			'chestkick',
			'clover6'
		];
		
		public static const OBJECT:Object = {
			'loddit': {
				name: 'Loddit',
				icon: new _lodditIcon(),
				ages: {
					teens: 10,
					young_adults: 7
				},
				genres: {
					fps: 10,
					rpg: 8,
					simulation: 4,
					moba: 4,
					sports: -2,
					puzzle: -6
				},
				description: 'This self-styled "homezone of the information superhighway" is made up of predominately 13-24 year olds, with tastes ranging from "trash" to "absolute trash."'
			},
			'builddigforums': {
				name: 'BuildDigForums',
				icon: new _buildDigForumsIcon(),
				ages: {
					children: 10,
					teens: 5
				},
				genres: {
					sandbox: 10,
					fps: 5,
					rts: -2, 
					puzzle: -6
				},
				description: 'A forum for fans of the popular voxel-based sandbox game "BuildDig."'
			},
			'everything_terrible': {
				name: 'Everything Terrible',
				icon: new _everythingTerribleIcon(),
				ages: {
					young_adults: 4,
					adults: 10,
					middle_aged: 7
				},
				genres: {
					rts: 10,
					rpg: 8,
					fps: 6,
					puzzle: 6,
					sports: 3,
					simulation: -2,
					mmo: -6
				},
				description: 'The internet makes you smarter!'
			},
			'hipoldz': {
				name: 'HipOldz',
				icon: new _hipOldzIcon(),
				ages: {
					middle_aged: 6,
					elderly: 10
				},
				genres: {
					puzzle: 10,
					rts: 6,
					sports: 5,
					simulation: 3,
					moba: -2,
					mmo: -6,
					horror: -10
				},
				description: 'This is where all the old people can hang out and complain about you never calling.'
			},
			'chestkick': {
				name: 'Chestkick',
				icon: new _chestkickIcon(),
				ages: {
					children: 6,
					teens: 10
				},
				genres: {
					sandbox: 10,
					fps: 8,
					rpg: 4,
					fighting: 2,
					simulation: -4
				},
				description: "It's sort of like Everything Terrible, but for stingy people."
			},
			'clover6': {
				name: 'clover6',
				icon: new _clover6Icon(),
				ages: {
					teens: 8,
					young_adults: 10
				},
				genres: {
					fps: 10,
					simulation: 8,
					rpg: 6,
					racing: 2,
					horror: 2
				},
				description: "It would be a good idea to stay away from this one."
			}
		};
		
		public function Communities() 
		{
			
		}
		
	}

}
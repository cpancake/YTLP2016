package com.animenight.igs.data 
{
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class Genres 
	{
		public static const KEYS = [
			'fps',
			'rpg',
			'fighting',
			'puzzle',
			'rts',
			'simulation',
			'sports',
			'sandbox',
			'horror',
			'mmo',
			'racing',
			'moba'
		];
		
		public static const OBJECT = {
			'fps': {
				name: 'First Person Shooter',
				popularity: 10,
				age_popularity: {
					'children': 5,
					'teens': 10,
					'young_adults': 7,
					'adults': 3,
					'middle_aged': -1,
					'elderly': -5
				}
			},
			'rpg': {
				name: 'RPG',
				popularity: 8,
				age_popularity: {
					'children': 0,
					'teens': 3,
					'young_adults': 6,
					'adults': 8,
					'middle_aged': 4,
					'elderly': -3
				}
			},
			'fighting': {
				name: 'Fighting',
				popularity: 2,
				age_popularity: {
					'children': 3,
					'teens': 5,
					'young_adults': 7,
					'adults': 3,
					'middle_aged': 3,
					'elderly': -4
				}
			},
			'puzzle': {
				name: 'Puzzle',
				popularity: 5,
				age_popularity: {
					'children': -5,
					'teens': -1,
					'young_adults': 2,
					'adults': 5,
					'middle_aged': 7,
					'elderly': 10
				}
			},
			'rts': {
				name: 'Real-time Strategy',
				popularity: 4,
				age_popularity: {
					'children': -2,
					'teens': 1,
					'young_adults': 3,
					'adults': 7,
					'middle_aged': 8,
					'elderly': 4
				}
			},
			'simulation': {
				name: 'Simulation',
				popularity: 6,
				age_popularity: {
					'children': 2,
					'teens': -2,
					'young_adults': -4,
					'adults': 5,
					'middle_aged': 8,
					'elderly': 2
				}
			},
			'sports': {
				name: 'Sports',
				popularity: 6,
				age_popularity: {
					'children': 2,
					'teens': 5,
					'young_adults': 6,
					'adults': 7,
					'middle_aged': 4,
					'elderly': 3
				}
			},
			'sandbox': {
				name: 'Sandbox',
				popularity: 7,
				age_popularity: {
					'children': 5,
					'teens': 7,
					'young_adults': 8,
					'adults': 4,
					'middle_aged': 1,
					'elderly': 1
				}
			},
			'horror': {
				name: 'Horror',
				popularity: 8,
				age_popularity: {
					'children': 0,
					'teens': 10,
					'young_adults': 7,
					'adults': -1,
					'middle_aged': -4,
					'elderly': -10
				}
			},
			'mmo': {
				name: 'MMO',
				popularity: 7,
				age_popularity: {
					'children': 0,
					'teens': 3,
					'young_adults': 8,
					'adults': 3,
					'middle_aged': -4,
					'elderly': -5
				}
			},
			'racing': {
				name: 'Racing',
				popularity: 5,
				age_popularity: {
					'children': 6,
					'teens': 2,
					'young_adults': 3,
					'adults': 6,
					'middle_aged': 6,
					'elderly': 2
				}
			},
			'moba': {
				name: 'MOBA',
				popularity: 2,
				age_popularity: {
					'children': -5,
					'teens': 4,
					'young_adults': 10,
					'adults': 5,
					'middle_aged': 2,
					'elderly': -2
				}
			}
		};
	}

}
package com.animenight.igs.data 
{
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class Jobs 
	{
		public function Jobs() { }
		
		public static const Positions:Object = {
			// Fast Food
			"fry_fryer": new Job(
				"Fry Fryer",
				"A very prestigious position. Your duties include: frying fries.",
				6,
				0, // exp (days)
				0, // int
				0  // creativity
			),
			"meat_flipper": new Job(
				"Meat Flipper",
				"Flipping meat! It's all you've ever dreamed about.",
				8,
				3, // exp (days)
				0, // int
				0  // creativity
			),
			"shake_shaker": new Job(
				"Shake Shaker",
				"There actually isn't any shaking involved in making milkshakes at a fast food place. But it's your job title nonetheless.",
				10,
				7, // exp (days)
				0, // int
				0  // creativity
			),
			"burger_meister": new Job(
				"Burger Meister",
				"Now you have to actually MAKE the burgers. Next thing you know, they'll be asking you to BAG them too.",
				11,
				12, // exp (days)
				0, // int
				0  // creativity
			),
			"manager": new Job(
				"Manager",
				"Congratulations, you're now the most important person in the store! There's nowhere up from here.",
				14,
				20, // exp (days)
				0, // int
				0  // creativity
			),
			
			// business co
			"mailroom_clerk": new Job(
				"Mailroom Clerk",
				"Mail goes in to boxes and mail comes out of boxes.",
				6,
				0, // exp (days)
				20, // int
				0  // creativity
			),
			"button_pusher": new Job(
				"Button Pusher",
				"I can't tell you exactly what these buttons do, but I can assure you that it's very important.",
				9,
				4, // exp (days)
				20, // int
				0  // creativity
			),
			"report_writer": new Job(
				"Report Writer",
				"Remember to use the correct cover sheets on the TPS reports.",
				14,
				10, // exp (days)
				40, // int
				0  // creativity
			),
			"spreadsheet_maintainer": new Job(
				"Spreadsheet Maintainer",
				"These spreadsheets contain macros last touched in 1999. Good luck!",
				16,
				18, // exp (days)
				60, // int
				0  // creativity
			),
			"salesman": new Job(
				"Salesman",
				"You're making the big bucks now. Plus, think of all the martinis you can expense!",
				24,
				30, // exp (days)
				80, // int
				20  // creativity
			),
			"lesser_executive": new Job(
				"Lesser Executive",
				"Slaying a lesser executive gives you 86.6 Slayer XP.",
				28,
				40, // exp (days)
				140, // int
				50  // creativity
			),
			"greater_executive": new Job(
				"Greater Executive",
				"Talk to Sumona in northern Pollnivneach to begin the quest.",
				35,
				60, // exp (days)
				200, // int
				70  // creativity
			),
			"president": new Job(
				"President",
				"Went to the stock market today. Did a business.",
				50,
				100, // exp (days)
				200, // int
				100  // creativity
			),
			
			// Tech
			"computer_janitor": new Job(
				"Computer Janitor",
				"These computers aren't going to janitor themselves!",
				15,
				0, // exp (days)
				60, // int
				30  // creativity
			),
			"code_monkey": new Job(
				"Code Monkey",
				"Bad news: you'll be working on a Rails app. Good news: the vending machine has Mountain Dew!",
				19,
				10, // exp (days)
				85, // int
				50  // creativity
			),
			"future_proofer": new Job(
				"Future Proofer",
				"You like to think your purpose in this job is to prevent the plot of Terminator from happening.",
				24,
				30, // exp (days)
				110, // int
				60  // creativity
			),
			"tech_salesman": new Job(
				"Tech Salesman",
				"If you add \"tech\" to any job, it automatically sounds more important.",
				30,
				40,
				130,
				75
			),
			"ceo": new Job(
				"CEO",
				"Well aren't you cool, with your big fancy title.",
				40,
				60,
				150,
				100
			),
			
			// Tech Bubble
			// You can only get here from Tech Salesman
			"investor_milker": new Job(
				"Investor Milker",
				"Disruptive. Synergistic. The sharing economy of the now.",
				25,
				0,
				0,
				0
			),
			"tech_unicorn": new Job(
				"Tech Unicorn",
				"This doesn't actually mean what you think it means. Unless you think it means what it does mean.",
				30,
				15,
				120,
				100
			),
			"bubble_ceo": new Job(
				"CEO",
				"If your company isn't worth $1B, I don't know what you're even doing here.",
				35,
				40,
				150,
				110
			),
		};
		
		public static const Companies:Array = [
			"fast_food",
			"business",
			"tech",
			"bubble"
		];
		
		public static const FastFood:Array = [
			"fry_fryer",
			"meat_flipper",
			"shake_shaker",
			"burger_meister",
			"manager"
		];
		
		public static const Business:Array = [
			"mailroom_clerk",
			"button_pusher",
			"report_writer",
			"spreadsheet_maintainer",
			"salesman",
			"lesser_executive",
			"greater_executive",
			"president"
		];
		
		public static const Equivalents:Object = {
			"meat_flipper": "mailroom_clerk",
			"manager": "report_writer",
			"spreadsheet_maintainer": "computer_janitor",
			"salesman": "future_proofer",
			"greater_executive": "ceo",
			"tech_salesman": "investor_milker"
		};
	}

}
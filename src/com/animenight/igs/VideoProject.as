package com.animenight.igs 
{
	import com.animenight.igs.data.Communities;
	import com.animenight.igs.data.FanGroups;
	import com.animenight.igs.data.Genres;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class VideoProject
	{
		public var game:Game;
		public var name:String;
		public var id:String;
		public var isReview:Boolean = false;
		public var isSeries:Boolean = false;
		public var day:Number = 1;
		public var released:Boolean = false;
		public var finishedRecording:Boolean = false;
		public var finishedEditing:Boolean = false;
		public var inSeries:Boolean = false;
		public var seriesNum:Number = 1;
		
		public var recordTime:Number = 0;
		public var editingTime:Number = 0;
		
		public var views:Number = 0;
		public var likes:Number = 0;
		public var dislikes:Number = 0;
		public var totalIncome:Number = 0;
		public var viewsToday:Number = 0;
		
		public var aiThumbnail:Bitmap;
		public var aiPlayer:Player;
		public var aiDescription:String;
		
		public var videos:Array = [];
		public var communities:Object = {};
		
		// the decimal points, rounded off until we can get a full number
		private var _withheldIncome:Number = 0;
		
		public function VideoProject(review:Boolean, name:String, game:Game) 
		{
			this.isReview = review;
			this.name = name;
			this.game = game;
		}
		
		public function get isLP():Boolean
		{
			return !this.isReview;
		}
		
		public function set isLP(val:Boolean):void
		{
			this.isReview = !val;
		}
		
		public function income(newViews:Number):Number
		{
			return newViews * 0.02;
		}
		
		public function quality(player:Player):Number
		{
			var recordingQuality = Util.dimretScale(recordTime, 5, (isLP ? 3 : 5)) + Util.dimretScale(player.recordExperience, 5, 100);
			var editingQuality = Util.dimretScale(editingTime, 5, (isLP ? 3 : 10)) + Util.dimretScale(player.editExperience, 5, 100);
			var subQuality = (recordingQuality * player.recordMult * 0.5) + (editingQuality * player.editMult * 0.5);
			var videoQuality = subQuality;
			if (isLP)
			{
				// if LP, game quality is 25% of video quality
				videoQuality *= 0.75;
				videoQuality += (game.quality * 0.25); 
			}
			return Math.max(0, videoQuality);
		}
		
		public function calculateDay(player:Player):Number
		{
			if (!released) return 0;
			var videoQuality:Number = quality(player) / 10;
			var daysSinceRelease:Number = player.daysPlayed - day;
			
			// construct new viewer model based on video genre
			var viewerModel:Object = Util.shallowClone(player.viewerModel);
			var genreAges:Object = Genres.OBJECT[game.genre].age_popularity;
			var totalMult:Number = 0;
			FanGroups.AGE_GROUPS.forEach(function(k:String, _, __) {
				viewerModel[k] += (genreAges[k] / 10);
				totalMult += viewerModel[k];
			});
			
			// handle community advertising
			var communityBoost:Number = 0;
			Util.objectKeys(communities).forEach(function(k:String, _, __) {
				var genreOpinion:Number = ((Util.keyOrDefault(Communities.OBJECT[k].genres, game.genre, 0) as Number) + 10) / 20;
				FanGroups.AGE_GROUPS.forEach(function(ak:String, _, __) {
					var ageOpinion:Number = (Util.keyOrDefault(Communities.OBJECT[k].ages, ak, 0) as Number) / 10;
					viewerModel[ak] += ageOpinion * genreOpinion;
					totalMult += ageOpinion * genreOpinion;
					communityBoost = 20 * ageOpinion * genreOpinion;
				});
			});
			
			var newViews:Number = 
				5 +
				communityBoost +
				(subsYetToSee(daysSinceRelease) * player.subs * (0.5 * (Math.random() * 0.25))) * 
				videoQuality * 
				totalMult * 
				(game.getPopularity(player.daysPlayed) / 5);
			if (inSeries)
			{
				if (game.tripleA)
				{
					// after 65 videos, no one will watch
					newViews *= (10 - 1.25 * Math.sqrt(seriesNum - 1));
				}
				else
				{
					// after 30 videos, no one will watch
					newViews *= (10 - 1.857 * Math.sqrt(seriesNum - 1));
				}
			}
			newViews += Math.random() * newViews;
			newViews += Math.random() * 10;
			newViews *= 1 / (player.daysPlayed - day + 1);
			newViews = Math.ceil(newViews);
			var subs:Number = Math.ceil(newViews * videoQuality * 0.2);
			
			var newIncomeFull:Number = income(newViews);
			var newIncome:Number = Math.floor(newIncomeFull);
			_withheldIncome += newIncomeFull - newIncome;
			if (_withheldIncome > 1)
			{
				newIncome += Math.floor(_withheldIncome);
				_withheldIncome -= Math.floor(_withheldIncome);
			}
			viewsToday = newViews;
			this.views += newViews;
			this.totalIncome += newIncome;
			player.subs += subs;
			player.cash += newIncome;
			
			var totalRatings:Number = Math.random() * newViews;
			this.likes += Math.ceil(videoQuality * totalRatings);
			this.dislikes += Math.ceil(Math.max(0.05, 1 - videoQuality) * totalRatings);
			
			// update the viewer model
			var modelSubs:Object = {};
			var totalSubs:Number = 0;
			FanGroups.AGE_GROUPS.forEach(function(k:String, _, __) {
				modelSubs[k] = player.subs * player.viewerModel[k];
				modelSubs[k] += subs * viewerModel[k];
				totalSubs += modelSubs[k];
			});
			FanGroups.AGE_GROUPS.forEach(function(k:String, _, __) {
				player.viewerModel[k] = Math.max(0, modelSubs[k] / totalSubs);
			});
			
			return newIncome;
		}
		
		// {0, 1}, {7, 0}
		private function subsYetToSee(days:Number):Number
		{
			return Math.max(0.05, (7 - days) / (days + 7));
		}
	}
}
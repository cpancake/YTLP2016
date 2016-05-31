package com.animenight.igs 
{
	import com.animenight.igs.VideoProject;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class AIPlayers 
	{
		public var topVideos:Array = [];
		
		private var _players:Array = [];
		private var _realPlayer:Player;
		
		public function AIPlayers(realPlayer:Player, count:Number = 100) 
		{
			_realPlayer = realPlayer;
			for (var i = 0; i < count; i++)
			{
				var player:Player = new Player("", true);
				player.generateName();
				player.subs = Math.floor(1000000 + (Math.random() * 9000000));
				player.recordExperience = 100;
				player.editExperience = 100;
				var video:VideoProject = makeNewVideo(player);
				video.calculateDay(player);
				player.aiVideoProjects.push(video);
				_players.push(player);
			}
			calculateDay();
		}
		
		public function calculateDay():void
		{
			var allVideos:Array = [];
			var currentMinimum:Number = 0;
			for (var i = 0; i < _players.length; i++)
			{
				var player:Player = _players[i];
				player.subs = Math.floor(1000000 + (Math.random() * 9000000));
				player.daysPlayed++;
				if (Math.random() > 0.5)
				{
					player.aiVideoProjects.push(makeNewVideo(player));
				}
				player.aiVideoProjects.data.forEach(function(v:VideoProject, _, __) {
					v.calculateDay(player);
					if (allVideos.length < 30 || v.viewsToday > currentMinimum)
					{
						allVideos.push(v);
						currentMinimum = (v.viewsToday < currentMinimum ? v.viewsToday : currentMinimum);
					}
				});
			}
			
			topVideos = allVideos
				.concat(
					_realPlayer.videoProjects.filter(function(v:VideoProject, _, __) { 
						return v.released; 
					}))
				.sortOn('viewsToday', Array.DESCENDING | Array.NUMERIC)
				.slice(0, 30);
		}
		
		private function makeNewVideo(player:Player):VideoProject
		{
			var games = _realPlayer.games.allGames.slice(0, Math.min(10, _realPlayer.games.allGames.length));
			var game:Game = games[Math.floor(Math.random() * games.length)];
			var video:VideoProject;
			
			if (Math.random() > 0.5)
			{
				var num:Number =  1 + Math.floor(Math.random() * (game.tripleA ? 65 : 30));
				video = new VideoProject(false, "Let's Play " + game.name + " Part " + num, game);
				video.aiThumbnail = ThumbnailGenerator.generateThumbnail(true, num);
			}
			else
			{
				video = new VideoProject(true, game.name + " Review", game);
				video.aiThumbnail = ThumbnailGenerator.generateThumbnail(false);
			}
			
			video.recordTime = 10;
			video.editingTime = 20;
			video.day = player.daysPlayed;
			video.released = true;
			video.aiPlayer = player;
			return video;
		}
	}
}
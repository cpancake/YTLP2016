package com.animenight.igs 
{
	import com.animenight.igs.VideoProject;
	import com.animenight.igs.data.ThumbnailSeeds;
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
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
			if (count == NaN) return;
			
			var takenNames:Array = [];
			for (var i = 0; i < count; i++)
			{
				var player:Player = new Player("", true);
				do
				{
					player.generateName();
				} while (takenNames.indexOf(player.name) != -1);
				takenNames.push(player.name);
				player.subs = Math.floor(1000000 + (Math.random() * 9000000));
				player.recordExperience = 100;
				player.editExperience = 100;
				var video:VideoProject = makeNewVideo(player);
				video.calculateDay(player);
				player.aiVideoProjects.push(video);
				_players.push(player);
			}
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
				
			var aiUsers = {};
			var thumbnailSeeds:Array = ThumbnailSeeds.PEOPLE.slice(0);
			var thumbnailSides:Array = ThumbnailSeeds.PEOPLE_SIDES.slice(0);
			Util.shuffleTwo(thumbnailSeeds, thumbnailSides);
			var i:Number = 0;
			topVideos.forEach(function(v:VideoProject, _, __) {
				if (v.aiPlayer == null) return;
				var face:Number;
				if (aiUsers.hasOwnProperty(v.aiPlayer.name))
				{
					face = aiUsers[v.aiPlayer.name];
				}
				else
				{
					face = aiUsers[v.aiPlayer.name] = i++;
				}
				
				v.aiThumbnail = (v.isLP ?
					ThumbnailGenerator.generateThumbnail(true, v.seriesNum, thumbnailSeeds[face], thumbnailSides[face]) :
					ThumbnailGenerator.generateThumbnail(false, 1, thumbnailSeeds[face], thumbnailSides[face]));
			});
		}
		
		public function playerFromName(name:String):Player
		{
			for (var i:Number = 0; i < _players.length; i++)
			{
				if (_players[i].name == name)
				{
					return _players[i];
				}
			}
			
			return null;
		}
		
		public function writePlayers(output:ByteArray):void
		{
			// write top videos
			output.writeUnsignedInt(topVideos.length);
			for (var i:Number = 0; i < topVideos.length; i++)
			{
				var video:VideoProject = topVideos[i];
				video.writeVideo(output);
			}
			
			// write players
			output.writeUnsignedInt(_players.length);
			for (var i:Number = 0; i < _players.length; i++)
			{
				var player:Player = _players[i];
				output.writeUTF(player.name);
				output.writeDouble(player.subs);
				output.writeDouble(player.recordExperience);
				output.writeDouble(player.editExperience);
				output.writeUnsignedInt(player.daysPlayed);
			}
		}
		
		public static function readPlayers(player:Player, input:ByteArray):AIPlayers
		{
			var aiPlayers:AIPlayers = new AIPlayers(player, NaN);
			aiPlayers.topVideos = [];
			aiPlayers._players = [];
			
			var topVideosCount:Number = input.readUnsignedInt();
			for (var i:Number = 0; i < topVideosCount; i++)
			{
				aiPlayers.topVideos.push(VideoProject.readVideo(player, input));
			}
			
			var playerCount:Number = input.readUnsignedInt();
			for (var i:Number = 0; i < playerCount; i++)
			{
				var player:Player = new Player(input.readUTF(), true);
				player.subs = input.readDouble();
				player.recordExperience = input.readDouble();
				player.editExperience = input.readDouble();
				player.daysPlayed = input.readUnsignedInt();
				aiPlayers._players.push(player);
			}
			
			return aiPlayers;
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
				video.seriesNum = num;
			}
			else
			{
				video = new VideoProject(true, game.name + " Review", game);
			}
			
			video.recordTime = 10;
			video.editingTime = 20;
			video.day = player.daysPlayed;
			video.released = true;
			video.aiPlayer = player;
			video.id = Util.generateRandomString(10);
			return video;
		}
	}
}
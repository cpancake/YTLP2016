package com.animenight.igs 
{
	import com.animenight.igs.VideoProject;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class AIPlayers 
	{
		private var _players:Array = [];
		private var _realPlayer:Player;
		
		public function AIPlayers(realPlayer:Player, count:Number = 100) 
		{
			_realPlayer = realPlayer;
			for (var i = 0; i < count; i++)
			{
				var player:Player = new Player();
				player.generateName();
				player.subs = Math.floor(Math.random() * 1000000);
				player.recordExperience = 100;
				player.editExperience = 100;
				_players.push(player);
			}
		}
		
		private function makeNewVideo(player:Player):void
		{
			var lpGamesAvailable = _realPlayer.games.allGames.filter(function(g:Game, _, __) { 
				return player.series.some(function(v:VideoProject, _, __) {
					return !(v.game == g && v.isSeries);
				});
			});
			
			var reviewGamesAvailable = _realPlayer.games.allGames.filter(function(g:Game, _, __) { 
				return player.series.some(function(v:VideoProject, _, __) {
					return !(v.game == g && !v.isLP);
				});
			});
		}
	}
}
package com.animenight.igs.scenes.tabs 
{
	import com.animenight.igs.Player;
	import com.animenight.igs.Util;
	import com.animenight.igs.VideoProject;
	import com.animenight.igs.components.EasyButton;
	import com.bit101.charts.LineChart;
	import com.animenight.igs.components.PieChart;
	import com.animenight.igs.data.Colors;
	import com.animenight.igs.data.FanGroups;
	import com.animenight.igs.data.Genres;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class CommunityTab extends Sprite
	{
		private const SIDEBAR_WIDTH:Number = 150;
		private const CONTENT_WIDTH:Number = 800 - (10 + SIDEBAR_WIDTH + 10) - 10;
		
		private var _player:Player;
		
		private var _channelButton:EasyButton;
		private var _internetButton:EasyButton;
		private var _topVideosButton:EasyButton;
		
		private var _yourChannelTab:Sprite;
		
		private var _ageGroupChart:PieChart;
		//private var _genreChart:PieChart;
		private var _viewChart:LineChart;
		private var _subChart:LineChart;
		
		public function CommunityTab(player:Player) 
		{
			_player = player;
			
			/*_genreChart = new PieChart(100, "Videos By Genre");
			_genreChart.x = 10;
			updateGenreChart();*/
			
			_ageGroupChart = new PieChart(100, "Audience Ages");
			_ageGroupChart.x = _genreChart.x + _genreChart.width + 10;
			updateAgeChart();
			
			_viewChart = new LineChart("Daily Views");
			_viewChart.x = 10;
			_viewChart.y = _ageGroupChart.y + _ageGroupChart.height + 10;
			_viewChart.lineColor = 0x0570b0;
			_viewChart.lineWidth = 3;
			updateViewChart();
			
			_subChart = new LineChart("Daily Subscribers");
			_subChart.x = 10;
			_subChart.y = _ageGroupChart.y + _ageGroupChart.height + 10;
			_subChart.lineColor = 0x0570b0;
			_subChart.lineWidth = 3;
			updateSubChart();
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function update():void
		{
			updateAgeChart();
			//updateGenreChart();
			updateViewChart();
			updateSubChart();
		}
		
		private function addedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			_channelButton = new EasyButton("Your Channel");
			_channelButton.enabled = false;
			_channelButton.x = 10;
			_channelButton.y = 10;
			_channelButton.resizeBox(SIDEBAR_WIDTH, _channelButton.height);
			_channelButton.addEventListener(MouseEvent.CLICK, channelButtonClicked);
			this.addChild(_channelButton);
			
			_internetButton = new EasyButton("Internet");
			_internetButton.enabled = true;
			_internetButton.x = 10;
			_internetButton.y = _channelButton.y + _channelButton.height + 10;
			_internetButton.resizeBox(SIDEBAR_WIDTH, _internetButton.height);
			_internetButton.addEventListener(MouseEvent.CLICK, internetButtonClicked);
			this.addChild(_internetButton);
			
			_topVideosButton = new EasyButton("Top Videos");
			_topVideosButton.enabled = true;
			_topVideosButton.x = 10;
			_topVideosButton.y = _internetButton.y + _internetButton.height + 10;
			_topVideosButton.resizeBox(SIDEBAR_WIDTH, _topVideosButton.height);
			_topVideosButton.addEventListener(MouseEvent.CLICK, topVideosButtonClicked);
			this.addChild(_topVideosButton);
			
			_yourChannelTab = new Sprite();
			_yourChannelTab.x = 10 + SIDEBAR_WIDTH + 10;
			_yourChannelTab.y = 10;
			this.addChild(_yourChannelTab);
			
			_yourChannelTab.addChild(_ageGroupChart);
			_yourChannelTab.addChild(_genreChart);
			_yourChannelTab.addChild(_viewChart);
			_yourChannelTab.addChild(_subChart);
		}
		
		private function updateAgeChart():void
		{
			var segments:Array = [];
			var i:Number = 0;
			FanGroups.AGE_GROUPS.forEach(function(k:String, _, __) {
				var percent:Number = _player.viewerModel[k];
				segments.push({
					percent: percent,
					color: Colors.COLORS[i++],
					label: FanGroups.AGE_NAMES[k]
				});
			});
			_ageGroupChart.update(segments.reverse());
		}
		
		/*private function updateGenreChart():void
		{
			var genreCounts:Object = {};
			var anyVideos:Boolean = false;
			_player.videoProjects.forEach(function(v:VideoProject, _, __) {
				if (!v.released) return;
				anyVideos = true;
				genreCounts[v.game.genre] = (genreCounts.hasOwnProperty(v.game.genre) ? genreCounts[v.game.genre] + 1 : 1);
			});
			
			var segments:Array = [];
			var i:Number = 0;
			
			if (!anyVideos)
			{
				segments = [{
					color: 0xffffff,
					percent: 1,
					label: null
				}];
			}
			
			Genres.KEYS.forEach(function(k:String, _, __) {
				segments.push({
					percent: (genreCounts[k] || 0) / _player.videoProjects.length,
					color: Colors.COLORS[i++],
					label: Genres.OBJECT[k].name
				});
			});
			_genreChart.update(segments);
		}*/
		
		private function updateViewChart():void
		{
			_viewChart.data = _player.viewHistory.data;
			_viewChart.x = 10 + _viewChart.negativeX;
			_viewChart.y = _ageGroupChart.y + _ageGroupChart.height + 10 + _viewChart.negativeY;
		}
		
		private function updateSubChart():void
		{
			_subChart.data = _player.subscriberHistory.data;
			_subChart.x = _ageGroupChart.x + _subChart.negativeX;
			_subChart.y = _ageGroupChart.y + _ageGroupChart.height + 10 + _subChart.negativeY;
		}
		
		private function channelButtonClicked(e:MouseEvent):void
		{
			_channelButton.enabled = false;
			_internetButton.enabled = true;
			_topVideosButton.enabled = true;
			
			_yourChannelTab.visible = true;
		}
		
		private function internetButtonClicked(e:MouseEvent):void
		{
			_channelButton.enabled = true;
			_internetButton.enabled = false;
			_topVideosButton.enabled = true;
			
			_yourChannelTab.visible = false;
		}
		
		private function topVideosButtonClicked(e:MouseEvent):void
		{
			_channelButton.enabled = true;
			_internetButton.enabled = true;
			_topVideosButton.enabled = false;
			
			_yourChannelTab.visible = false;
		}
	}

}
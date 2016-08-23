package com.animenight.igs 
{
	import com.adobe.tvsdk.mediacore.MediaPlayerItemConfig;
	import com.animenight.igs.data.Jobs;
	import com.animenight.igs.data.RandomEvents;
	import com.animenight.igs.data.Tutorial;
	import com.animenight.igs.data.Upgrades;
	import flash.media.Video;
	import flash.net.SharedObject;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	/**
	 * Player class.
	 * @author Andrew Rogers
	 */
	public class Player
	{
		public static const PLAYER_BIN_VERSION:uint = 1;
		public const HOURS_AVAILABLE:Number = 16;
		public const WEEKLY_EXPENSES:Number = 200;
		
		public var name:String;
		public var cash:Number = 50;
		public var subs:Number = 0;
		public var daysPlayed:Number = 0;
		public var hoursLeft:Number = HOURS_AVAILABLE;
		
		public var recordExperience:Number = 0;
		public var editExperience:Number = 0;
		
		public var recordUpgrade:Number = 0;
		public var editUpgrade:Number = 0;
		
		public var lastEditTimeChoice:Number = 1;
		public var lastRecordTimeChoice:Number = 1;
		
		public var workExperience:Number = 0;
		public var workPerformance:Number = 100;
		public var workedToday:Boolean = false;
		public var workPosition:Number = 0;
		public var hasJob:Boolean = true;
		public var tutorialCompleted:Boolean = false;
		
		public var games:Games = new Games();
		public var series:Array = [];
		public var videoProjects:Array = [];
		public var latestVideo:VideoProject = null;
		
		public var aiPlayers:AIPlayers;
		public var tutorial:Tutorial;
		
		public var aiVideoProjects:RollingArray = new RollingArray(10);
		
		public var subscriberHistory:RollingArray = new RollingArray(7, [0,0,0,0,0,0,0]);
		public var viewHistory:RollingArray = new RollingArray(7, [0, 0, 0, 0, 0, 0, 0]);
		public var saveSlot:Number = 0;
		
		public var viewerModel:Object = {
			'children': 1/6,
			'teens': 1/6,
			'young_adults': 1 / 6,
			'adults': 1 / 6,
			'middle_aged': 1 / 6,
			'elderly': 1 / 6
		};
		
		public function Player(name:String = 'Default', dontGen:Boolean = false) 
		{
			this.name = name;
			if (!dontGen)
			{
				this.games.generateGames();
				aiPlayers = new AIPlayers(this);
				tutorial = new Tutorial();
			}
		}
		
		public static function load(saveslot:Number):Player
		{
			var saveObject:SharedObject = SharedObject.getLocal("savedgames");
			var slots:Array = saveObject.data.saveslots;
			var slot:ByteArray = slots[saveslot];
			slot.readUTF();
			
			var length:Number = slot.readUnsignedInt();
			var data:ByteArray = new ByteArray();
			slot.readBytes(data, 0, length);
			data.inflate();
			
			if (data.readUnsignedInt() != Player.PLAYER_BIN_VERSION)
			{
				throw new Error("Invalid save.");
			}
			
			var name:String = data.readUTF();
			var player:Player = new Player(name, true);
			player.cash = data.readDouble();
			player.subs = data.readDouble();
			player.daysPlayed = data.readUnsignedInt();
			player.recordExperience = data.readDouble();
			player.editExperience = data.readDouble();
			player.recordUpgrade = data.readByte();
			player.editUpgrade = data.readByte();
			player.lastEditTimeChoice = data.readByte();
			player.lastRecordTimeChoice = data.readByte();
			player.workExperience = data.readDouble();
			player.workPerformance = data.readDouble();
			player.workPosition = data.readByte();
			player.hasJob = data.readBoolean();
			player.tutorialCompleted = true;
			data.readBoolean();
			player.saveSlot = saveslot;
			
			player.games = Games.read(data);
		
			// read series
			var seriesLength:Number = data.readUnsignedInt();
			player.series = [];
			for (var i:Number = 0; i < seriesLength; i++)
			{
				player.series.push(VideoProject.readVideo(player, data));
			}
			
			// read projects
			var projectLength:Number = data.readUnsignedInt();
			player.videoProjects = [];
			for (var i:Number = 0; i < projectLength; i++)
			{
				player.videoProjects.push(VideoProject.readVideo(player, data));
			}
			
			if (data.readBoolean())
			{
				player.latestVideo = VideoProject.readVideo(player, data);
			}
			
			//
			
			player.aiPlayers = AIPlayers.readPlayers(player, data);
			
			var subHistoryCount:Number = data.readUnsignedInt();
			for (var i:Number = 0; i < subHistoryCount; i++)
			{
				player.subscriberHistory.push(data.readDouble());
			}
			
			var viewHistoryCount:Number = data.readUnsignedInt();
			for (var i:Number = 0; i < viewHistoryCount; i++)
			{
				player.viewHistory.push(data.readDouble());
			}
			
			var keyCount:Number = data.readUnsignedInt();
			for (var i:Number = 0; i < keyCount; i++)
			{
				player.viewerModel[data.readUTF()] = data.readDouble();
			}
			
			return player;
		}
		
		public static function readName(saveslot:Number):String
		{
			var saveObject:SharedObject = SharedObject.getLocal("savedgames");
			if (!saveObject.data.saveslots)
			{
				return "Slot " + (saveslot + 1);
			}
			var slots:Array = saveObject.data.saveslots;
			if (!slots[saveslot])
			{
				return "Slot " + (saveslot + 1);
			}
			
			var slot:ByteArray = slots[saveslot];
			return "Slot " + (saveslot + 1) + " - " + slot.readUTF();
		}
		
		public function save():void
		{
			var saveObject:SharedObject = SharedObject.getLocal("savedgames");
			saveObject.data.saveslots = saveObject.data.saveslots || [null, null, null];
			var bytes:ByteArray = new ByteArray();
			export(bytes);
			bytes.deflate();
			
			var finalBytes:ByteArray = new ByteArray();
			finalBytes.writeUTF(name);
			finalBytes.writeUnsignedInt(bytes.length);
			finalBytes.writeBytes(bytes);
			saveObject.data.saveslots[saveSlot] = finalBytes;
			saveObject.flush();
		}
		
		public function export(output:ByteArray):void
		{
			output.writeUnsignedInt(PLAYER_BIN_VERSION);
			output.writeUTF(name);
			output.writeDouble(cash);
			output.writeDouble(subs);
			output.writeUnsignedInt(daysPlayed);
			output.writeDouble(recordExperience);
			output.writeDouble(editExperience);
			output.writeByte(recordUpgrade);
			output.writeByte(editUpgrade);
			output.writeByte(lastEditTimeChoice);
			output.writeByte(lastRecordTimeChoice);
			output.writeDouble(workExperience);
			output.writeDouble(workPerformance);
			output.writeByte(workPosition);
			output.writeBoolean(hasJob);
			output.writeBoolean(tutorialCompleted);
			
			games.export(output);
		
			// write series
			output.writeUnsignedInt(series.length);
			for (var i:Number = 0; i < series.length; i++)
			{
				var video:VideoProject = series[i];
				video.writeVideo(output);
			}
			
			// write projects
			output.writeUnsignedInt(videoProjects.length);
			for (var i:Number = 0; i < videoProjects.length; i++)
			{
				var video:VideoProject = videoProjects[i];
				video.writeVideo(output);
			}
			
			output.writeBoolean(latestVideo != null);
			if (latestVideo != null)
			{
				latestVideo.writeVideo(output);
			}
			
			aiPlayers.writePlayers(output);
			
			output.writeUnsignedInt(subscriberHistory.data.length);
			for (var i:Number = 0; i < subscriberHistory.data.length; i++)
			{
				output.writeDouble(subscriberHistory.data[i]);
			}
			
			output.writeUnsignedInt(viewHistory.data.length);
			for (var i:Number = 0; i < viewHistory.data.length; i++)
			{
				output.writeDouble(viewHistory.data[i]);
			}
			
			var keys:Array = Util.objectKeys(viewerModel);
			output.writeUnsignedInt(keys.length);
			for (var i:Number = 0; i < keys.length; i++)
			{
				var key:String = keys[i];
				output.writeUTF(key);
				output.writeDouble(viewerModel[key]);
			}
		}
		
		public function generateName():void
		{
			this.name = Patterns.Username();
		}
		
		public function get currentJob():Object
		{
			return Jobs.FastFoodPositions[workPosition];
		}
		
		public function get recordMult():Number
		{
			return Upgrades.RecordingUpgrades[recordUpgrade].mult;
		}
		
		public function get editMult():Number
		{
			return Upgrades.EditingUpgrades[editUpgrade].mult;
		}
		
		public function get totalViews():Number
		{
			var totalViews:Number = 0;
			videoProjects.forEach(function(v:VideoProject, _, __) {
				totalViews += v.views;
			});
			return totalViews;
		}
		
		public function get totalIncome():Number
		{
			var totalMoney:Number = 0;
			videoProjects.forEach(function(v:VideoProject, _, __) {
				totalMoney += v.income(v.views);
			});
			return totalMoney;
		}
		
		public function get latestUnfinishedVideo():VideoProject
		{
			var unfinished = videoProjects.filter(function(e:VideoProject, _, __) { 
				return !e.released && !(e.recordTime >= e.recordTimeSpecified && e.editingTime >= e.editingTimeSpecified);
			});
			return (unfinished.length > 0 ? unfinished[0] : null);
		}
		
		public function jobPerformanceIncrease():Number
		{
			return 10 - (9 * workPosition) / 11;
		}
		
		public function jobPerformanceDecrease():Number
		{
			return 50 - 3.75 * workPosition;
		}
	}
}
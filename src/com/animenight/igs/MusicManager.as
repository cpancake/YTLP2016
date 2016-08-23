package com.animenight.igs 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class MusicManager 
	{
		[Embed(source = "../../../../resources/music/Chipper Doodle v2-compressed.mp3")]
		private static var _chipperDoodleClass:Class;
		
		[Embed(source = "../../../../resources/music/Disco Medusae-compressed.mp3")]
		private static var _discoMedusaeClass:Class;
		
		[Embed(source = "../../../../resources/music/Kawai Kitsune-compressed.mp3")]
		private static var _kawaiKitsuneClass:Class;
		
		[Embed(source = "../../../../resources/music/Close My Mouth-compressed.mp3")]
		private static var _closeMyMouthClass:Class;
		
		[Embed(source = "../../../../resources/music/Mind Over Matter-compressed.mp3")]
		private static var _mindOverMatterClass:Class;
		
		private var _songs:Array = [];
		private var _currentSong:Number = 0;
		private var _currentSongChannel:SoundChannel;
		private var _soundTransform:SoundTransform;
		private var _muted:Boolean = false;
		private var _menuTracks:Array = [
			new _discoMedusaeClass() as Sound
		];
		private var _gameTracks:Array = [
			new _mindOverMatterClass() as Sound,
			new _chipperDoodleClass() as Sound,
			new _kawaiKitsuneClass() as Sound,
			new _closeMyMouthClass() as Sound
		];
		
		public function MusicManager() 
		{
			_songs = _menuTracks;
			_songs = Util.shuffle(_songs);
			_soundTransform = new SoundTransform(0.5);
		}
		
		public function start():void
		{
			var sound:Sound = _songs[_currentSong];
			_currentSongChannel = sound.play();
			_currentSongChannel.soundTransform = new SoundTransform(0.2);
			_currentSongChannel.addEventListener(Event.SOUND_COMPLETE, function(e:Event):void { nextSong(); });
		}
		
		public function nextSong():void
		{
			_currentSongChannel.stop();
			_currentSong++;
			if (_currentSong > _songs.length - 1)
			{
				_currentSong = 0;
			}
			
			var sound:Sound = _songs[_currentSong];
			_currentSongChannel = sound.play();
			_currentSongChannel.soundTransform = new SoundTransform((_muted ? 0 : 0.2));
			_currentSongChannel.addEventListener(Event.SOUND_COMPLETE, function(e:Event):void { nextSong(); });
		}
		
		public function toggleMute():void
		{
			if (_muted)
			{
				_currentSongChannel.soundTransform = new SoundTransform(0.2);
			}
			else
			{
				_currentSongChannel.soundTransform = new SoundTransform(0);
			}
			_muted = !_muted;
		}
		
		public function switchToGame():void
		{
			_songs = _gameTracks;
			_songs = Util.shuffle(_gameTracks);
			nextSong();
		}
		
		public function switchToMenu():void
		{
			_songs = _menuTracks;
			nextSong();
		}
	}
}
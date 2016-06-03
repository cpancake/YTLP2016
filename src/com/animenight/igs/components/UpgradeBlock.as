package com.animenight.igs.components 
{
	import com.animenight.igs.Util;
	import com.animenight.igs.events.UIEvent;
	import com.animenight.igs.scenes.GameScene;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class UpgradeBlock extends Sprite
	{
		public static const WIDTH = 365;
		public static const HEIGHT = 150;
		
		private var _title:EasyTextField;
		private var _desc:EasyTextField;
		private var _button:EasyButton;
		private var _thumbnail:Sprite;
		private var _currentLabel:EasyTextField;
		private var _noUpgrade:EasyTextField;
		private var _currentUpgrade:Object;
		
		public function UpgradeBlock(upgrade:Object, isCurrent:Boolean) 
		{
			updateUpgrade(upgrade, isCurrent);
		}
		
		public function updateUpgrade(upgrade:Object, isCurrent:Boolean)
		{
			this.removeChildren();
			_currentUpgrade = upgrade;
			
			if (!upgrade)
			{
				_noUpgrade = new EasyTextField("No More Upgrades!");
				_noUpgrade.size = 18;
				_noUpgrade.italics = true;
				_noUpgrade.color = 0xdddddd;
				_noUpgrade.update();
				_noUpgrade.x = WIDTH / 2 - _noUpgrade.textWidth / 2;
				_noUpgrade.y = HEIGHT / 2 - _noUpgrade.textHeight / 2;
				this.addChild(_noUpgrade);
				return;
			}
			
			_title = new EasyTextField(upgrade.name);
			_title.bold = true;
			_title.width = WIDTH - 175;
			_title.wordWrap = true;
			
			_desc = new EasyTextField(upgrade.desc);
			_desc.y = _title.textHeight;
			_desc.wordWrap = true;
			_desc.width = _title.width;
			
			_thumbnail = new Sprite();
			_thumbnail.x = WIDTH - 165;
			_thumbnail.graphics.beginFill(0x000000);
			_thumbnail.graphics.drawRect(0, 0, 165, 80);
			_thumbnail.graphics.endFill();
			
			_button = new EasyButton("Buy - $" + Util.formatMoney(upgrade.price));
			_button.x = _thumbnail.x;
			_button.y = _thumbnail.y + _thumbnail.height + 5;
			_button.visible = !isCurrent;
			_button.enabled = _button.visible && (GameScene.player.cash >= upgrade.price);
			_button.resizeBox(_thumbnail.width, _button.height);
			_button.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				if (upgrade.type == "record")
				{
					GameScene.player.recordUpgrade++;
				}
				else
				{
					GameScene.player.editUpgrade++;
				}
				GameScene.player.cash -= upgrade.price;
				
				var cashChange:UIEvent = new UIEvent(UIEvent.CASH_CHANGE);
				cashChange.cashAmount = -upgrade.price;
				cashChange.cashSource = "Upgrade";
				dispatchEvent(cashChange);
				dispatchEvent(new UIEvent(UIEvent.UPGRADE_BOUGHT));
			});
			
			_currentLabel = new EasyTextField("Current");
			_currentLabel.bold = true;
			_currentLabel.italics = true;
			_currentLabel.update();
			_currentLabel.x = _thumbnail.x + (_thumbnail.width / 2 - _currentLabel.textWidth / 2);
			_currentLabel.y = _button.y + (_button.height / 2 - _currentLabel.height / 2);
			_currentLabel.visible = isCurrent;
			this.addChild(_currentLabel);
			
			this.addChild(_title);
			this.addChild(_desc);
			this.addChild(_button);
			this.addChild(_thumbnail);
			
			_title.text = upgrade.name;
			_title.update();
			_desc.text = upgrade.desc;
			_desc.update();
			_button.text = "Buy - $" + Util.formatMoney(upgrade.price);
			_button.resizeBox(_thumbnail.width, _button.height);
			_button.visible = !isCurrent;
			_button.enabled = _button.visible;
			_thumbnail.graphics.beginBitmapFill(upgrade.icon.bitmapData);
			_thumbnail.graphics.drawRect(0, 0, 165, 80);
			_thumbnail.graphics.endFill();
			_currentLabel.visible = isCurrent;
		}
		
		public function update()
		{
			if (!_currentUpgrade) return;
			_button.enabled = _button.visible && (GameScene.player.cash >= _currentUpgrade.price);
		}
	}

}
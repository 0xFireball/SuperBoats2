package states;

import flixel.*;
import flixel.ui.*;
import flixel.util.*;
import flixel.tweens.*;
import flixel.effects.particles.*;
import flixel.addons.effects.chainable.*;

import nf4.ui.*;
import nf4.ui.menu.*;
import nf4.effects.particles.*;
import nf4.util.*;

import ui.*;
import ui.menu.*;
import ui.menu.SBNFMenuState;

class SettingsState extends SBNFMenuState {

	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.load(AssetPaths.mouse__png);
		#end

		bgColor = Registry.backgroundColor;

		var titleTx = new SBNFText(0, 80, "Settings", 84);
		titleTx.color = FlxColor.WHITE;
		titleTx.screenCenter(FlxAxes.X);
		add(titleTx);

		// set up menu
		menuGroup.updatePosition(FlxG.width / 2, 340);
        menuGroup.itemMargin = 12;
        menuWidth = 300;
        menuItemTextSize = 32;

		menuItems.push(
			new MenuSwitchData(["Autosave: On", "Autosave: Off"], Registry.saveSlot.data.autosave ? 0 : 1,
			null, function (a:Int) {
				if (a == 0) {
					Registry.saveSlot.data.autosave = true;
				} else if (a == 1) {
					Registry.saveSlot.data.autosave = false;
				}
			})
		);

		if (!Registry.saveSlot.data.autosave) {
			menuItems.push(
				new MenuButtonData("Save Game", onSaveData)
			);
		}

		menuItems.push(
			new MenuButtonData("Reset Game", onResetSave)
		);

		// menuItems.push(
		// 	new MenuInputData("", 17)
		// );

		#if GAMEJOLT
		menuItems.push(
			new MenuButtonData("Connect GameJolt", onConnectGameJolt)
		);
		#end

		menuItems.push(
			new MenuButtonData("Return", onReturn)
		);

		FlxG.camera.fade(bgColor, 0.4, true);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		#if !FLX_NO_KEYBOARD
		if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
            // dismiss menu
			onReturn();
		}
		#end

		super.update(elapsed);
	}

	private function onReturn() {
		// save settings
		Registry.saveSlot.flush();
		// switch
		FlxG.camera.fade(Registry.washoutColor, 0.4, false, function () {
			FlxG.switchState(new MenuState());
		});
	}

	private function onResetSave() {
		Registry.gameLevel = 0;
		onSaveData();
		// visual feedback
		FlxG.camera.flash(FlxColor.RED, 0.2);
	}

	private function onSaveData() {
		util.SaveUtil.saveGameLevel();
	}

	#if GAMEJOLT
	private function onConnectGameJolt() {
		// substate for connecting gamejolt
		
	}
	#end
}

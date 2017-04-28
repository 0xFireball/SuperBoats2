package states;

import flixel.*;
import flixel.ui.*;
import flixel.util.*;
import flixel.tweens.*;
import flixel.effects.particles.*;
import flixel.addons.effects.chainable.*;

import states.game.PlayState;

import nf4.ui.*;
import nf4.effects.particles.*;
import nf4.util.*;

class SettingsState extends FlxState
{
	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.load(AssetPaths.mouse__png);
		#end

		bgColor = FlxColor.fromInt(0x0B2B36);

		var titleTx = new NFText(0, 80, "Settings", 84);
		titleTx.color = FlxColor.WHITE;
		titleTx.screenCenter(FlxAxes.X);
		add(titleTx);

		var resetGameBtn = new NFButton(0, 540, "Reset Game", onResetSave);
		resetGameBtn.screenCenter(FlxAxes.X);
		add(resetGameBtn);
		
		var saveDataBtn = new NFButton(0, 600, "Save Game", onSaveData);
		saveDataBtn.screenCenter(FlxAxes.X);
		add(saveDataBtn);

		var returnBtn = new NFButton(0, 700, "Return", onReturn);
		returnBtn.screenCenter(FlxAxes.X);
		add(returnBtn);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
            // dismiss menu
			onReturn();
		}

		super.update(elapsed);
	}

	private function onReturn() {
		// switch
		FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function () {
			FlxG.switchState(new MenuState());
		});
	}

	private function onResetSave() {
		Registry.gameLevel = 0;
		Registry.saveSlot.data.level = Registry.gameLevel;
		onSaveData();
	}

	private function onSaveData() {
		Registry.saveSlot.data.level = Registry.gameLevel;
		Registry.saveSlot.flush();
	}
}

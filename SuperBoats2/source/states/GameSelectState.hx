package states;

import flixel.*;
import flixel.ui.*;
import flixel.util.*;
import flixel.tweens.*;
import flixel.effects.particles.*;
import flixel.addons.effects.chainable.*;

import states.game.*;

import nf4.ui.*;
import nf4.effects.particles.*;
import nf4.util.*;

import ui.*;

class GameSelectState extends FlxState
{
	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.load(AssetPaths.mouse__png);
		#end

		bgColor = FlxColor.fromInt(0x0B2B36);

		var titleTx = new SBNFText(0, 80, "Game Mode", 84);
		titleTx.color = FlxColor.WHITE;
		titleTx.screenCenter(FlxAxes.X);
		add(titleTx);

		var classicGameBtn = new SBNFButton(0, 350, "Classic", onSelectClassic);
		classicGameBtn.screenCenter(FlxAxes.X);
		add(classicGameBtn);
		
		var warGameBtn = new SBNFButton(0, 410, "Naval War", onSelectNavalWar);
		warGameBtn.screenCenter(FlxAxes.X);
		add(warGameBtn);

		var returnBtn = new SBNFButton(0, 700, "Return", onReturn);
		returnBtn.screenCenter(FlxAxes.X);
		add(returnBtn);

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

		if (FlxG.keys.anyJustPressed([ ONE ])) {
            onSelectClassic();
		}

		if (FlxG.keys.anyJustPressed([ TWO ])) {
            onSelectNavalWar();
		}
		#end

		super.update(elapsed);
	}

	private function onReturn() {
		// switch
		FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function () {
			FlxG.switchState(new MenuState());
		});
	}

	private function onSelectClassic() {
		FlxG.camera.fade(FlxColor.BLACK, 0.6, false, function () {
			FlxG.switchState(new ClassicPlayState());
		});
	}

	private function onSelectNavalWar() {
		FlxG.camera.fade(FlxColor.BLACK, 0.6, false, function () {
			FlxG.switchState(new WarPlayState());
		});
	}
}

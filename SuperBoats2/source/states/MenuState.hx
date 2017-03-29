package states;

import flixel.*;
import flixel.util.*;
import flixel.tweens.*;
import ui.*;

class MenuState extends FlxState
{
	private var titleTx:NFText;

	override public function create():Void
	{
		titleTx = new NFText(0, FlxG.height * (1 / 4), "SuperBoats 2", 42);
		titleTx.color = FlxColor.WHITE;
		titleTx.screenCenter(FlxAxes.X);
		titleTx.y = -titleTx.height;
		FlxTween.tween(titleTx, { y: FlxG.height * (1 / 4) }, 0.7, { ease: FlxEase.cubeOut })
		add(titleTx);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

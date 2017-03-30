package states;

import flixel.*;
import flixel.util.*;
import flixel.addons.effects.chainable.*;
import flixel.addons.display.*;
import sprites.boats.*;

class PlayState extends FlxState
{
	override public function create():Void
	{
		var bg = new FlxBackdrop(AssetPaths.water__png, 0.5, 0.5);
		add(bg);

		// create player
		var player = new PlayerBoat(FlxG.width / 2, FlxG.height / 2);
		add(player);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

package states.game;

import flixel.*;
import flixel.util.*;
import flixel.effects.particles.*;
import flixel.addons.effects.chainable.*;
import flixel.addons.display.*;
import flixel.group.FlxGroup;

import sprites.boats.*;
import sprites.projectiles.*;

import states.game.data.*;

class PlayState extends FlxState
{
	public var player:PlayerBoat;
    public var mothership:Mothership;
    public var allies:FlxTypedGroup<GreenBoat>;
    public var warships:FlxTypedGroup<Warship>;
    public var projectiles:FlxTypedGroup<Projectile>;
    public var emitter:FlxEmitter;

	public var bg:FlxBackdrop;

	override public function create():Void
	{
		bg = new FlxBackdrop(AssetPaths.water__png, 0.5, 0.5);
		add(bg);

		var stateData = new GameStateData();

		// create player
		player = new PlayerBoat(FlxG.width / 2, FlxG.height / 2, stateData);
		stateData.player = player;
		add(player);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

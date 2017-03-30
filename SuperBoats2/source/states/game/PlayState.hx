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

		allies = new FlxTypedGroup<GreenBoat>();
		stateData.allies = allies;
		add(allies);

		// create player
		player = new PlayerBoat(Math.random() * FlxG.width, Math.random() * FlxG.height, stateData);
		player.angle = Math.random() * Math.PI * 2;
		stateData.player = player;
		allies.add(player);

		warships = new FlxTypedGroup<Warship>();
		stateData.warships = warships;
		// create mothership
		mothership = new Mothership(Math.random() * FlxG.width, Math.random() * FlxG.height, stateData);
		stateData.mothership = mothership;
		mothership.angle = Math.random() * Math.PI * 2;
		add(warships);

		projectiles = new FlxTypedGroup<Projectile>();
		stateData.projectiles = projectiles;
		add(projectiles);

		emitter = new FlxEmitter();
		stateData.emitter = emitter;
		add(emitter);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

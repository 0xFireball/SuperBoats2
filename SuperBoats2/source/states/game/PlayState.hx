package states.game;

import nf4.util.*;
import flixel.*;
import flixel.effects.particles.*;
import flixel.addons.display.*;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;

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
	public var wallMap:FlxTilemap;

	public var bg:FlxBackdrop;

	override public function create():Void
	{
		bg = new FlxBackdrop(AssetPaths.water__png, 0.5, 0.5);
		add(bg);

		// set bounds
		FlxG.worldBounds.set(-20, -20, FlxG.width + 20, FlxG.height + 20);

		
		// create and load boundary map
		wallMap = new FlxTilemap();
		var mapWidth = Std.int(FlxG.width / 16);
		var mapHeight = Std.int(FlxG.height/ 16);
		wallMap.loadMapFromArray(
			WallMapUtil.generateWallMap(mapWidth, mapHeight),
			mapWidth,
			mapHeight,
			AssetPaths.wall_tiles__png,
			16, 16
		);
		add(wallMap);

		var stateData = new GameStateData();

		allies = new FlxTypedGroup<GreenBoat>();
		stateData.allies = allies;
		add(allies);

		// create player
		player = new PlayerBoat(Math.random() * (FlxG.width - 60), Math.random() * (FlxG.height - 60), stateData);
		player.angle = Math.random() * Math.PI * 2;
		stateData.player = player;
		allies.add(player);

		warships = new FlxTypedGroup<Warship>();
		stateData.warships = warships;
		add(warships);

		// create mothership
		mothership = new Mothership(Math.random() * (FlxG.width - 60), Math.random() * (FlxG.height - 60), stateData);
		stateData.mothership = mothership;
		mothership.angle = Math.random() * Math.PI * 2;
		warships.add(mothership);

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
		// sprite collision
		FlxG.overlap(allies, projectiles, shipHitProjectile);
		FlxG.overlap(warships, projectiles, shipHitProjectile);
		FlxG.collide(allies, warships);

		// wall collision
		FlxG.collide(wallMap, allies);
		FlxG.collide(wallMap, warships);

		super.update(elapsed);
	}

	private function shipHitProjectile(s:Boat, j:Projectile) {
		j.hitSprite(s);
	}
}

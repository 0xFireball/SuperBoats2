package states.game;

import flixel.util.FlxColor;
import flixel.*;
import flixel.input.keyboard.FlxKey;
import flixel.effects.particles.*;
import flixel.addons.display.*;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;

import sprites.boats.*;
import sprites.projectiles.*;
import sprites.ui.*;

import states.game.data.*;

import nf4.util.*;
import nf4.effects.particles.*;

class PlayState extends FlxState
{
	public var player:PlayerBoat;
    public var mothership:Mothership;
    public var allies:FlxTypedGroup<Boat>;
    public var warships:FlxTypedGroup<Boat>;
    public var projectiles:FlxTypedGroup<Projectile>;
    public var emitter:FlxEmitter;
	public var wallMap:FlxTilemap;

	public var bg:FlxBackdrop;

	public var stateData:GameStateData;

	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end

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

		stateData = new GameStateData();

		allies = new FlxTypedGroup<Boat>();
		stateData.allies = allies;
		add(allies);

		// create player
		player = new PlayerBoat(Math.random() * (FlxG.width - 120) + 60, Math.random() * (FlxG.height - 120) + 60, stateData);
		player.angle = Math.random() * Math.PI * 2;
		stateData.player = player;
		allies.add(player);

		warships = new FlxTypedGroup<Boat>();
		stateData.warships = warships;
		add(warships);

		// create mothership
		mothership = new Mothership(Math.random() * (FlxG.width - 120) + 60, Math.random() * (FlxG.height - 120) + 60, stateData);
		stateData.mothership = mothership;
		mothership.angle = Math.random() * Math.PI * 2;
		warships.add(mothership);

		projectiles = new FlxTypedGroup<Projectile>();
		stateData.projectiles = projectiles;
		add(projectiles);

		emitter = new FlxEmitter();
		stateData.emitter = emitter;
		add(emitter);

		stateData.effectEmitter = new NFParticleEmitter(240);
		add(stateData.effectEmitter);

		var hud = new HUD(stateData);
		add(hud);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		// sprite collision
		FlxG.overlap(allies, projectiles, shipHitProjectile);
		FlxG.overlap(warships, projectiles, shipHitProjectile);
		// FlxG.overlap(allies, warships);

		// wall collision
		FlxG.collide(wallMap, allies);
		FlxG.collide(wallMap, warships);
		
		// keep projectiles in bounds
		projectiles.forEachAlive(function (p) {
			if (p.x < p.width || p.y < p.height || p.x > FlxG.width + p.width || p.y > FlxG.height + p.height) {
				p.hitBoundary();
			}
		});

		// pause menu
		if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
			openSubState(new PauseSubState(FlxColor.fromRGBFloat(0.7, 0.7, 0.7, 0.8)));
		}

		super.update(elapsed);

		// check game status
		checkGameStatus();
	}

	private function checkGameStatus() {
		// update final vars
		var lastMsDamage = mothership.damage;

		if (!player.exists) {
			// RIP, the player died
			FlxG.camera.fade(FlxColor.RED, 0.4, false, function () {
				FlxG.switchState(new GameOverState(lastMsDamage));
			});
		}
		if (!mothership.exists) {
			// wow, good job!
			FlxG.camera.fade(FlxColor.WHITE, 0.4, false, function () {
				FlxG.switchState(new YouWonState());
			});
		}
	}

	private function shipHitProjectile(s:Boat, j:Projectile) {
		j.hitSprite(s);
	}

	public override function destroy() {
		stateData.destroy();
		stateData = null;

		super.destroy();
	}
}

package states.game;

import flixel.*;
import flixel.tweens.*;
import flixel.util.*;
import flixel.effects.particles.*;
import flixel.addons.display.*;
import flixel.group.FlxGroup;
import flixel.tile.*;

import flixel.addons.nape.*;

import sprites.boats.*;
import sprites.projectiles.*;
import sprites.ui.*;

import states.game.data.*;

import nf4.util.*;
import nf4.effects.particles.*;

import ui.*;

class ClassicPlayState extends FlxState
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

	private var announcementText:SBNFText;
	private var announcementTime:Float = 2.2;
	private var announcementFade:Float = 0.8;
	private var announcementTimer:Float = 0;
	private var announcements = [];
	private var announcing:Bool = true;
	private var announcementIndex:Int = 0;

	public override function create():Void
	{
		super.create();

		// set up Nape
		FlxNapeSpace.init();

		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.load(AssetPaths.diamond_mouse__png);
		#end

		Registry.gameMode = GameMode.Classic;

		bg = new FlxBackdrop(AssetPaths.water__png, 0.5, 0.5);
		add(bg);

		// set bounds
		FlxG.worldBounds.set(-20, -20, FlxG.width + 20, FlxG.height + 20);

		// create and load boundary map
		wallMap = new FlxTilemap();
		wallMap.immovable = true;
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

		// create projectiles and emitter for weapon systems

		projectiles = new FlxTypedGroup<Projectile>();
		stateData.projectiles = projectiles;
		add(projectiles);

		emitter = new FlxEmitter();
		stateData.emitter = emitter;

		stateData.effectEmitter = new NFParticleEmitter(240);

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

		add(emitter);

		add(stateData.effectEmitter);

		var hud = new HUD(stateData);
		add(hud);

		if (Registry.gameLevel == 0) {
			for (introAnnouncement in ["Welcome to SuperBoats 2!", "WASD: move", "Mouse: aim", "C/X: Set/release objective", "R/F/G: Fire",
				"Destroy the mothership (red)", "Protect your allies (green)", "How far will you get?"]) {
				announcements.push(introAnnouncement);
			}
		}

		announcementText = new SBNFText(32, 0, announcements[announcementIndex], 36);
		announcementText.y = FlxG.height - (announcementText.height + 32);
		add(announcementText);
	}

	override public function update(dt:Float):Void
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
		#if !FLX_NO_KEYBOARD
		if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
			openSubState(new PauseSubState(FlxColor.fromRGBFloat(0.7, 0.7, 0.7, 0.8)));
		}
		#end

		// announcements
		if (announcementIndex < announcements.length) {
			if (announcementTimer > announcementTime) {
				announcementTimer = 0;
				announcing = false;
				FlxTween.tween(announcementText, { alpha: 0}, announcementFade, { onComplete: function (t) {
					announcementText.text = announcements[++announcementIndex];
					FlxTween.tween(announcementText, { alpha: 1}, announcementFade, { onComplete: function (t) {
						announcing = true;
					} });
				} });
			} else if (announcing) {
				announcementTimer += dt;
			}
		} else {
			announcementText.text = "";
		}

		super.update(dt);

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

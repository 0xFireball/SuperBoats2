package states.game;

import flixel.*;
import flixel.tweens.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;
import flixel.addons.display.*;
import flixel.group.FlxGroup;
import flixel.tile.*;

import sprites.boats.*;
import sprites.projectiles.*;
import sprites.ui.*;

import states.game.data.*;
import states.game.screens.*;

import nf4.util.*;
import nf4.effects.particles.*;

import ui.*;

import mapgen.*;

class NavalWarPlayState extends FlxState
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

	private var overviewZoom:Bool = false;
	private var zooming:Bool = false;

	#if cpp
	private var minimap:FlxCamera;
	#end

	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.load(AssetPaths.diamond_mouse__png);
		#end

		Registry.gameMode = GameMode.NavalWar;

		bg = new FlxBackdrop(AssetPaths.water__png, 0.5, 0.5);
		add(bg);
		
		// create and load boundary map
		wallMap = new FlxTilemap();
		wallMap.immovable = true;
		var mapGenerator = new NavalMapGenerator();
		var warWorldRoomSize:Int = 4;
		var worldTileSize:Int = 16;
		var mapWidth = Std.int(FlxG.width / worldTileSize) * warWorldRoomSize;
		var mapHeight = Std.int(FlxG.height/ worldTileSize) * warWorldRoomSize;
		wallMap.loadMapFromArray(
			mapGenerator.generateMap(mapWidth, mapHeight),
			mapWidth,
			mapHeight,
			AssetPaths.wall_tiles__png,
			worldTileSize, worldTileSize
		);
		add(wallMap);

		// set bounds
		FlxG.worldBounds.set(-20, -20, mapWidth * worldTileSize + 20, mapHeight * worldTileSize + 20);

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
		player = new PlayerBoat(Math.random() * (mapWidth * worldTileSize - 120) + 60, Math.random() * (mapHeight * worldTileSize - 120) + 60, stateData);
		player.angle = Math.random() * Math.PI * 2;
		stateData.player = player;
		allies.add(player);

		warships = new FlxTypedGroup<Boat>();
		stateData.warships = warships;
		add(warships);

		// create mothership
		mothership = new Mothership(Math.random() * (mapWidth * worldTileSize - 120) + 60, Math.random() * (mapHeight * worldTileSize - 120) + 60, stateData);
		stateData.mothership = mothership;
		mothership.angle = Math.random() * Math.PI * 2;
		warships.add(mothership);

		add(emitter);

		add(stateData.effectEmitter);

		var hud = new HUD(stateData);
		add(hud);

		if (Registry.gameLevel == 0) {
			for (introAnnouncement in ["Welcome to SuperBoats 2!", "Naval War is an experimental new gameplay mode!", "WASD: move", "Mouse: aim", "C/X: Set/release objective", "R/F/G: Fire",
				"Destroy the mothership (red)", "Protect your allies (green)", "How far will you get?"]) {
				announcements.push(introAnnouncement);
			}
		}

		announcementText = new SBNFText(32, 0, announcements[announcementIndex], 36);
		announcementText.y = FlxG.height - (announcementText.height + 32);
		announcementText.x = FlxG.width - announcementText.width - 32;
		add(announcementText);

		// follow player
		FlxG.camera.follow(player, TOPDOWN_TIGHT, 1.0);

		#if cpp
		// render minimap on native only
		var cameraSize:Int = 160;
		var cameraZoom:Float = 0.2;
		minimap = new FlxCamera(10, FlxG.height - cameraSize,
			Std.int(cameraSize / cameraZoom), Std.int(cameraSize / cameraZoom), cameraZoom);
		minimap.color = FlxColor.fromRGB(200, 200, 200);
		minimap.bgColor = FlxColor.BLACK;
		minimap.follow(player, LOCKON, 1.0);
		FlxG.cameras.add(minimap);
		#end

		super.create();
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
			if (wallMap.overlaps(p)) {
				p.hitBoundary();
			}
		});

		#if !FLX_NO_KEYBOARD
		// pause menu
		if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
			openSubState(new PauseSubState(FlxColor.fromRGBFloat(0.7, 0.7, 0.7, 0.8)));
		}

		// zoom tools
		if (FlxG.keys.anyJustPressed([ Z ])) {
			if (!zooming) {
				// temporarily disable
				// updateZoomTool();
			}
		}
		#end

		// announcements
		if (announcementIndex < announcements.length) {
			announcementText.x = FlxG.width - announcementText.width - 32 + FlxG.camera.scroll.x;
			announcementText.y = FlxG.height - announcementText.height - 32 + FlxG.camera.scroll.y;
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

	private function updateZoomTool() {
		zooming = true;
		if (!overviewZoom) {
			// tween the zoom
			var finalZoom = (FlxG.width / FlxG.worldBounds.width);
			FlxTween.tween(FlxG.camera, { zoom: finalZoom }, 0.4, { ease: FlxEase.cubeIn, onComplete: function (t) {
				zooming = false;
				overviewZoom = true;
			} });
			// FlxG.camera.setSize(Std.int(FlxG.width / finalZoom), Std.int(FlxG.height / finalZoom));
		} else {
			// return to initial zoom
			FlxTween.tween(FlxG.camera, { zoom: FlxG.camera.initialZoom }, 0.4, { ease: FlxEase.cubeIn, onComplete: function (t) {
				zooming = false;
				overviewZoom = false;
			} });
			// FlxG.camera.setSize(Std.int(FlxG.width), Std.int(FlxG.height));
		}
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
			// ?
			// TODO
			throw "TODO: End of Naval War";
		}
	}

	private function shipHitProjectile(s:Boat, j:Projectile) {
		j.hitSprite(s);
	}

	private function removeMapAddons() {
		#if cpp
		FlxG.cameras.remove(minimap);

		minimap = null;
		#end
	}

	public override function switchTo(nextState:FlxState):Bool {
		removeMapAddons();
		return super.switchTo(nextState);
	}

	public override function destroy() {
		stateData.destroy();
		stateData = null;

		removeMapAddons();

		super.destroy();
	}
}

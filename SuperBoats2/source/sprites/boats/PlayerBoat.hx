
package sprites.boats;

import flixel.*;
import flixel.math.*;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;
import flixel.util.*;

import nf4.effects.particles.*;
import nf4.util.*;

import states.game.*;
import states.game.data.*;
import sprites.effects.*;
import sprites.projectiles.*;
import sprites.boats.weapons.*;

using nf4.math.NFMathExt;

class PlayerBoat extends GreenBoat {
    public var allyCount:Int = 0;
	public var maxAllyCount:Int = 7;

	private var allySpawnFrequency:Int = 400;

    public function new(?X:Float = 0, ?Y:Float = 0, StateData:GameStateData) {
		super(X, Y, StateData);

		aiState.leader = this;

		maxHealth = health = 540000;
		hullShieldMax = hullShieldIntegrity = 216000;
		hullShieldRegen = 100;
		angularThrust = FlxAngle.asDegrees(0.05 * Math.PI);
		thrust = 3.7;
		wrapBounds = false;
		mass = 58000;
		sprayAmount = 8;
		if (Registry.gameMode == GameMode.NavalWar) {
			maxVelocity.set(380, 380);
		}
		maxAllyCount += Std.int(Registry.gameLevel / 3) * 2;
        loadGraphic(AssetPaths.player_boat__png);
		offset.set(14, 9);
		setSize(14, 30);
		updateHitbox();
	}

	private override function addWeapons() {
		weapons.push(new TalonLauncher(this, 0.4, stateData.effectEmitter, stateData.projectiles));
		weapons.push(new MachineGun(this, 0.05, stateData.effectEmitter, stateData.projectiles));
		weapons.push(new Mortar(this, 1.6, stateData.effectEmitter, stateData.projectiles));
	}

	public override function update(dt:Float) {
		spawnAllies();

		super.update(dt);
	}

	private function spawnAllies() {
		if (allyCount < maxAllyCount && Std.int(Math.random() * allySpawnFrequency) == 4) {
			// spawn ally
			++allyCount;
			var ally = new GreenBoat(Math.random() * (FlxG.width - 60) + 30, Math.random() * (FlxG.height - 60) + 30, stateData);
			stateData.allies.add(ally);
		}
	}

	public override function movement() {
		var up:Bool = false;
		var left:Bool = false;
		var right:Bool = false;
		var down:Bool = false;
		var setObjective:Bool = false;
		var releaseObjective:Bool = false;

		#if !FLX_NO_KEYBOARD
		up = FlxG.keys.anyPressed([W, I, UP]);
		left = FlxG.keys.anyPressed([A, J, LEFT]);
		down = FlxG.keys.anyPressed([S, K, DOWN]);
		right = FlxG.keys.anyPressed([D, L, RIGHT]);

		setObjective = FlxG.keys.anyJustPressed([C]);
		releaseObjective = FlxG.keys.anyJustPressed([X]);

		attacking1 = FlxG.keys.anyPressed([F]);
		attacking2 = FlxG.keys.anyPressed([G]);
		attacking3 = FlxG.keys.anyPressed([R]);
		#end

		if (setObjective && releaseObjective) {
			setObjective = false;
			releaseObjective = false;
		}

		// apply objective
		if (setObjective) {
			aiController.setObjective(center);
			// draw epicenter
			subSprites.add(new Epicenter(center.x, center.y, FlxColor.fromRGBFloat(0.2, 0.9, 0.2)));
		} else if (releaseObjective) {
			subSprites.add(new Epicenter(center.x, center.y, FlxColor.fromRGBFloat(0.9, 0.2, 0.2)));
			aiController.setObjective(null);
		}

		moveDefault(up,
			left,
			right,
			down);
	}

	private override function acquireTarget(SourcePoint:FlxPoint, BoatCollection:FlxTypedGroup<Boat>):Boat {
		SourcePoint = FlxG.mouse.getPosition();
		var target = super.acquireTarget(SourcePoint, BoatCollection);
		SourcePoint.put();
		return target;
	}

	private override function primaryFire(target:Boat, initialAim:FlxPoint) {
		#if !FLX_NO_KEYBOARD
		if (FlxG.keys.anyPressed([E])) {
			var tpos = FlxG.mouse.getPosition();
			initialAim.set(tpos.x, tpos.y);
		}
		#end
		super.primaryFire(target, initialAim);
	}

	private override function secondaryFire() {
		var target = acquireTarget(center, stateData.warships);
		var targetPos:FlxPoint;
		if (target != null) {
			targetPos = target.center;
		} else {
			targetPos = FlxG.mouse.getPosition();	
		}
		weapons[1].fireFree(targetPos);
	}

	private override function heavyFire() {
		var targetPos = FlxG.mouse.getPosition();
		weapons[2].fireFree(targetPos);
	}
}
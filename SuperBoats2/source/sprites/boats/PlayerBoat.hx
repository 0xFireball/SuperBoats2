
package sprites.boats;

import flixel.*;
import flixel.math.*;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;
import flixel.util.*;

import nf4.effects.particles.*;
import nf4.util.*;

import states.game.data.*;
import sprites.effects.*;

class PlayerBoat extends GreenBoat {
    public var allyCount:Int = 0;
	public var maxAllyCount:Int = 6;

	private var allySpawnFrequency:Int = 400;

    public function new(?X:Float = 0, ?Y:Float = 0, StateData:GameStateData) {
		super(X, Y, StateData);

		aiState.leader = this;

		maxHealth = health = 420000;
		hullShieldMax = hullShieldIntegrity = 172000;
		hullShieldRegen = 100;
		attackTime = 0.4;
		angularThrust = FlxAngle.asDegrees(0.05 * Math.PI);
		thrust = 3.5;
		wrapBounds = false;
		mass = 28000;
		sprayAmount = 8;
        loadGraphic(AssetPaths.player_boat__png);
		offset.set(13, 3);
		setSize(16, 36);
	}

	override public function update(dt:Float) {
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

		left = FlxG.keys.anyPressed([J, LEFT]);
		up = FlxG.keys.anyPressed([I, UP]);
		right = FlxG.keys.anyPressed([L, RIGHT]);
		down = FlxG.keys.anyPressed([K, DOWN]);

		var setObjective:Bool = FlxG.keys.anyJustPressed([C]);
		var releaseObjective:Bool = FlxG.keys.anyJustPressed([X]);

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

		attacking = FlxG.keys.anyPressed([F, M]);
		attackingSecondary = FlxG.keys.anyPressed([G, N]);
	}

	private override function acquireTarget(SourcePoint:FlxPoint, BoatCollection:FlxTypedGroup<Boat>):Boat {
		SourcePoint = FlxG.mouse.getPosition();
		var target = super.acquireTarget(SourcePoint, BoatCollection);
		SourcePoint.put();
		return target;
	}

	private override function secondaryFire() {
		var target = acquireTarget(center, stateData.warships);
		var gMgBullet = new MGBullet(this, center.x, center.y, target);
		var tVec = gMgBullet.center.toVector()
			.subtractPoint(target.center)
			.rotate(FlxPoint.weak(0, 0), 180)
			.toVector().normalize().scale(gMgBullet.movementSpeed);
		gMgBullet.velocity.set(tVec.x, tVec.y);
		tVec.put();
		// apply recoil
		velocity.addPoint(gMgBullet.momentum.scale(1 / mass).negate());
		stateData.projectiles.add(gMgBullet);
		// smoke
		for (i in 0...4) {
			stateData.effectEmitter.emitSquare(center.x, center.y, 2,
				NFParticleEmitter.velocitySpread(45, tVec.x / 4, tVec.y / 4),
				NFColorUtil.randCol(0.5, 0.5, 0.5, 0.1), 0.8);
		}
	}
}
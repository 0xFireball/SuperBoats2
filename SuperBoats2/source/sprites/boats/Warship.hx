
package sprites.boats;

import flixel.util.FlxColor;
import flixel.*;
import flixel.math.*;

import sprites.projectiles.*;

import ai.BoatAiState;
import ai.BoatAiController;

import states.game.data.*;

import nf4.math.NFMath;
import nf4.effects.particles.*;
import nf4.util.*;

using nf4.math.NFMathExt;

class Warship extends Boat {
	private var attackTime:Float = 0.4;
	private var attackTimer:Float = 0;
	private var attackCount:Int = 0;
	private var cannonMissRange:Float = Math.PI * 1 / 8;
	private var torpedoMissRange:Float = Math.PI * 1 / 3;
	public var aiController:BoatAiController<Boat>;
	public var aiState:BoatAiState<Boat>;
	public var lastStep:ActionState;

	public function new(?X:Float = 0, ?Y:Float = 0, StateData:GameStateData) {
		super(X, Y, StateData);

		aiController = new BoatAiController<Boat>();
		aiController.me = this;
		aiState = new BoatAiState<Boat>();
		aiController.loadState(aiState);
		var hypot = NFMath.hypot(FlxG.width, FlxG.height);
		aiController.triggerRadius = hypot / 4;
		maxHealth = health = 540000;
		thrust = 1.9;
		wrapBounds = false;
		mass = 79000;
		sprayAmount = 20;
		spraySpread = 80;
		angularThrust = FlxAngle.asDegrees(0.034 * Math.PI);
		maxAngular = FlxAngle.asDegrees(Math.PI / 4);
		maxVelocity.set(135, 135);

		makeGraphic(20, 43, FlxColor.fromRGBFloat(0.8, 0.4, 0.1));
	}

	override public function update(dt:Float) {
		aiController.style = damage < 0.7 ? Aggressive : Defensive;
		movement();
		attackTimer += dt;
		if (attackTimer > attackTime) {
			attackPlayer();
			++attackCount;
			attackTimer = 0;
		}

		super.update(dt);
	}

	private function attackPlayer() {
		var target = acquireTarget(center, stateData.allies);
		trace("attack, "+ center);
		if (target == null) return;
		var dist = center.toVector().subtractPoint(target.center);
		var dx = dist.x;
		var dy = dist.y;
		if (attackCount % 3 == 0) {
			var projectile:Projectile = null;
			projectile = new Cannonball(this, center.x + width / 2, center.y + height / 2, target);
			var bulletSp = projectile.movementSpeed;
			var m = -Math.sqrt(dx * dx + dy * dy);
			var vx = dx * bulletSp / m;
			var vy = dy * bulletSp / m;
			var pVelVec = FlxPoint.get(vx, vy);
			// accuracy isn't perfect
			pVelVec.rotate(FlxPoint.weak(0, 0), Math.random() * FlxAngle.asDegrees(Math.random() * cannonMissRange * 2 - cannonMissRange));
			vx = pVelVec.x;
			vy = pVelVec.y;
			shootProjectile(projectile, vx, vy);
		}
		if (attackCount % 7 == 0) {
			var projectile:Projectile = null;
			projectile = new Torpedo(this, center.x, center.y, target);
			var bulletSp = projectile.movementSpeed;
			var m = -Math.sqrt(dx * dx + dy * dy);
			var vx = dx * bulletSp / m;
			var vy = dy * bulletSp / m;
			var pVelVec = FlxPoint.get(vx, vy);
			// accuracy isn't perfect
			pVelVec.rotate(FlxPoint.weak(0, 0), Math.random() * FlxAngle.asDegrees(Math.random() * torpedoMissRange * 2 - torpedoMissRange));
			pVelVec.put();
			vx = pVelVec.x;
			vy = pVelVec.y;
			shootProjectile(projectile, vx, vy);
		}
	}

	private function shootProjectile(pj:Projectile, vx:Float, vy:Float) {
		pj.velocity.set(vx, vy);
		stateData.projectiles.add(pj);
		var recoil = pj.momentum.scale(1 / mass).negate();
		velocity.addPoint(recoil);
		if (x > FlxG.width) x = x % FlxG.width;
		if (y > FlxG.height) y = y % FlxG.height;
		if (x < 0) x += FlxG.width;
		if (y < 0) y += FlxG.height;
		// smoke
		for (i in 0...14) {
			stateData.effectEmitter.emitSquare(center.x, center.y, 6,
				NFParticleEmitter.velocitySpread(45, vx / 4, vy / 4),
				NFColorUtil.randCol(0.5, 0.5, 0.5, 0.1), 0.8);
		}
	}

	private function movement() {
		var target = acquireTarget(center, stateData.allies);
		aiState.friends = stateData.warships;
		aiState.enemies = stateData.allies;
		aiController.target = target;

		var step = aiController.step();
		lastStep = step;
		moveDefault(step.movement.thrust,
			step.movement.left,
			step.movement.right,
			step.movement.brake);
	}

	override public function dismantle() {
		// when destroyed, update minion count
		if (this != stateData.mothership) {
			stateData.mothership.minionCount--;
		}
		super.dismantle();
	}
}
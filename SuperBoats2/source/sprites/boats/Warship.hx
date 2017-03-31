
package sprites.boats;

import flixel.*;
import flixel.math.*;

import sprites.projectiles.*;

import ai.BoatAiState;
import ai.BoatAiController;

import states.game.data.*;

import nf4.math.NFMath;

using nf4.math.NFMathExt;

class Warship extends Boat {
	private static var attackTime:Float = 0.2;
	private var attackTimer:Float = 0;
	private var attackCount:Int = 0;
	private var cannonMissRange:Float = Math.PI * 1 / 8;
	private var torpedoMissRange:Float = Math.PI * 1 / 3;
	public var aiController:BoatAiController<Warship, GreenBoat>;
	public var aiState:BoatAiState<Warship, GreenBoat>;
	public var lastStep:ActionState;

	public function new(?X:Float = 0, ?Y:Float = 0, StateData:GameStateData) {
		super(X, Y, StateData);

		aiController = new BoatAiController<Warship, GreenBoat>();
		aiController.me = this;
		aiState = new BoatAiState<Warship, GreenBoat>();
		aiController.loadState(aiState);
		var hypot = NFMath.hypot(FlxG.width, FlxG.height);
		aiController.triggerRadius = hypot / 4;
		maxHealth = health = 4750000;
		thrust = 0.6;
		wrapBounds = false;
		mass = 184000;
		sprayAmount = 20;
		spraySpread = 80;
		angularThrust = FlxAngle.asDegrees(0.027 * Math.PI);
		maxAngular = FlxAngle.asDegrees(Math.PI / 5);
		maxVelocity.set(60, 60);
	}

	override public function update(dt:Float) {
		movement();
		attackTimer += dt;
		if (attackTimer > attackTime) {
			attackPlayer();
			++attackCount;
			attackTimer = 0;
		}

		super.update(dt);
	}

	private function acquireTarget():GreenBoat {
		var target:GreenBoat = null;
		var hypot = NFMath.hypot(FlxG.width, FlxG.height);
		var minDistance = hypot * 2;
		stateData.allies.forEachAlive(function (boat) {
			var dist = boat.center.distanceTo(center);
			if (dist < minDistance) {
				minDistance = dist;
				target = boat;
			}
		});
		return target;
	}

	private function attackPlayer() {
		var target = acquireTarget();
		if (target == null) return;
		var dist = center.toVector().subtractPoint(target.center);
		var dx = dist.x;
		var dy = dist.y;
		if (attackCount % 3 == 0) {
			var projectile:Projectile = null;
			projectile = new Cannonball(x + width / 2, y + height / 2, target, stateData.emitter);
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
			var hydraRng:Bool = Std.int(Math.random() * 7) == 4;
			projectile = new Torpedo(x + width / 2, y + height / 2, target, stateData.emitter);
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
		// for (i in 0...14) {
		// 	stateData.smokeEffectEmitter.emitSquare(x, y, 6,
		// 		NParticleEmitter.velocitySpread(45, vx / 4, vy / 4),
		// 		NColorUtil.randCol(0.5, 0.5, 0.5), 0.8);
		// }
	}

	private function movement() {
		var target = acquireTarget();
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
}
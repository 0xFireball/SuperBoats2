package sprites.projectiles;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;

import nf4.NFSprite;

using nf4.math.NFMathExt;

class Talon extends Projectile {
	public var thrust(default, null):Float = 1;
	public var angularThrust(default, null):Float = Math.PI * 0.04;

	public function new(?X:Float = 0, ?Y:Float = 0, Target:NFSprite, Emitter:FlxEmitter) {
		super(X, Y, Emitter);
		damageFactor = 0.4;
		mass = 1100;
		target = Target;
		movementSpeed = 320;
		maxVelocity.set(600, 600);
		makeGraphic(6, 2, FlxColor.fromRGBFloat(0.1, 0.9, 0.9));
	}

	override public function update(dt:Float) {
		var particleTrailVector = velocity.toVector(); // duplicate velocity vector
		particleTrailVector.rotate(FlxPoint.weak(0, 0), 180);
		particleTrailVector.scale(0.7);
		// emit trail particles
		// for (i in 0...2) {
		// 	Registry.currentEmitterState.emitter.emitSquare(center.x, center.y, Std.int(Math.random() * 6) + 1,
		// 		NParticleEmitter.velocitySpread(40, particleTrailVector.x, particleTrailVector.y),
		// 	NColorUtil.randCol(0.1, 0.9, 0.9, 0.1), 0.7);
		// }
		if (target != null) {
			var distToTarget:Float = new FlxVector(x, y).distanceTo(FlxPoint.weak(target.x, target.y));
			// retarget to target
			var mA = 0;
			if (x < target.x) {
				mA = 0;
				if (y < target.y) {
					mA += 45;
					angularVelocity += angularThrust;
				} else if (y > target.y) {
					mA -= 45;
					angularVelocity -= angularThrust;
				}
			} else if (x > target.x) {
				mA = 180;
				if (y < target.y) {
					mA -= 45;
					angularVelocity -= angularThrust;
				} else if (y > target.y) {
					mA += 45;
					angularVelocity += angularThrust;
				}
			}
			var thrustVector = FlxPoint.get(thrust, 0);
			thrustVector.rotate(FlxPoint.weak(0, 0), mA);
			velocity.addPoint(thrustVector);
			thrustVector.put();
		}

		super.update(dt);
	}

	override public function explode() {
		// for (i in 0...14) {
		// 	stateData.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 10 + 5),
		// 		NParticleEmitter.velocitySpread(90),
		// 	NColorUtil.randCol(0.8, 0.5, 0.2, 0.2), 1.8);
		// }
		super.explode();
	}
}
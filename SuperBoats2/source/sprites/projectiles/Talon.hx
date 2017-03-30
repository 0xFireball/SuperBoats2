package sprites.projectiles;

import flixel.util.*;
import flixel.math.*;
import flixel.*;

import nf4.NFSprite;

using nf4.math.NFMathExt;

class Talon extends Projectile {
	public var thrust(default, null):Float = 1;
	public var angularThrust(default, null):Float = Math.PI * 0.04;
	public var isHydra:Bool = false;
	public var hydraAvailable:Bool = false;

	public function new(?X:Float = 0, ?Y:Float = 0, Target:NFSprite, ?Hydra:Bool = false) {
		super(X, Y);
		damageFactor = 0.4;
		mass = 1100;
		target = Target;
		isHydra = hydraAvailable = Hydra;
		movementSpeed = 320;
		maxVelocity.set(600, 600);
		makeGraphic(6, 2, FlxColor.fromRGBFloat(0.1, 0.9, 0.9));
	}

	override public function update(dt:Float) {
		var particleTrailVector = velocity.toVector(); // duplicate velocity vector
		particleTrailVector.rotate(FlxPoint.get(0, 0), 180);
		particleTrailVector.scale(0.7);
		// emit trail particles
		// for (i in 0...2) {
		// 	Registry.currentEmitterState.emitter.emitSquare(center.x, center.y, Std.int(Math.random() * 6) + 1,
		// 		NParticleEmitter.velocitySpread(40, particleTrailVector.x, particleTrailVector.y),
		// 	NColorUtil.randCol(0.1, 0.9, 0.9, 0.1), 0.7);
		// }
		var distToTarget = FlxVector.get(x, y).distanceTo(FlxPoint.get(target.x, target.y));
		if (distToTarget < 400 && hydraAvailable) {
			hydraAvailable = false;
			var hydraCount = 5;
			// for (i in 0...(hydraCount - 1)) {
			// 	var hyd = new Torpedo(x, y, target, false);
			// 	var spray = FlxPoint.get(Math.random() * 40 - 20, Math.random() * 40 - 20);
			// 	hyd.velocity.set(velocity.x / hydraCount + spray.x, velocity.y / hydraCount + spray.y);
			// 	Registry.PS.projectiles.add(hyd);
			// }
		}
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
		thrustVector.rotate(FlxPoint.get(0, 0), mA);
		velocity.addPoint(thrustVector);

		super.update(dt);
	}

	override public function explode() {
		for (i in 0...14) {
			Registry.PS.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 10 + 5),
				NParticleEmitter.velocitySpread(90),
			NColorUtil.randCol(0.8, 0.5, 0.2, 0.2), 1.8);
		}
		super.explode();
	}
}
package sprites.projectiles;

import flixel.math.*;
import flixel.effects.particles.*;

import nf4.NFSprite;

class TargetingProjectile extends Projectile {
	public var thrust(default, null):Float = 1;
	public var angularThrust(default, null):Float = FlxAngle.asDegrees(Math.PI * 0.015);

    public function new(?X:Float = 0, ?Y:Float = 0, Target:NFSprite, Emitter:FlxEmitter) {
		super(X, Y, Emitter);
    }

    override public function update(dt:Float) {
		if (target != null) {
			var distToTarget:Float = FlxVector.get(x, y).distanceTo(target.center);
			// retarget to player
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
		}

		super.update(dt);
	}
}

package sprites.boats;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import nf4.*;

import states.game.data.*;

class Boat extends NFSprite {
    public var angularThrust(default, null):Float = 0.05 * Math.PI;
	public var thrust(default, null):Float = 3.5;
	public var sprayAmount(default, null):Int = 5;
	public var spraySpread(default, null):Int = 40;
	
	private var wrapBounds:Bool = true;

	public var hullShieldMax:Float = 60000;
	public var hullShieldIntegrity:Float = 0;
	public var hullShieldRegen:Float = 100;

	public var stateData:GameStateData;

	public function new(?X:Float = 0, ?Y:Float = 0, StateData:GameStateData) {
		super(X, Y);

		stateData = StateData;
		
		maxHealth = health = 100000;
		maxVelocity.set(200, 200);
		maxAngular = FlxAngle.asDegrees(Math.PI);
		angularDrag = FlxAngle.asDegrees(Math.PI);
		drag.set(24, 24);
		elasticity = 0.3;
		mass = 16000;
	}

	override public function update(dt:Float) {
		keepInBounds();
		drawSpray();
		manageHealth();
		powerShield();

		super.update(dt);
	}

	private function moveDefault(Thrust:Bool, Left:Bool, Right:Bool, Brake:Bool) {
		// cancel movement
		if (Left && Right) Left = Right = false;
		if (Thrust && Brake) Thrust = Brake = false;

		if (Left) {
			angularVelocity -= angularThrust;
		} else if (Right) {
			angularVelocity += angularThrust;
		}
		var thrustVector = FlxVector.get(0, 0);
		drag.set(15, 15);
		if (Thrust) {
			thrustVector.add(0, -thrust);
		} else if (Brake) {
			// thrustVector.add(0, thrust);
			// brakes
			drag.scale(6);
		}
		thrustVector.rotate(FlxPoint.weak(0, 0), angle);
		velocity.addPoint(thrustVector);
		thrustVector.put();
	}

	private function powerShield() {
		if (hullShieldIntegrity > 0) {
			hullShieldIntegrity += hullShieldRegen;
			if (hullShieldIntegrity > hullShieldMax) hullShieldIntegrity = hullShieldMax;
		}
	}

	override public function hurt(amount:Float) {
		// apply damage to shield, else health
		if (hullShieldIntegrity > 0) {
			// absorb damage into shield
			hullShieldIntegrity -= amount;
			if (hullShieldIntegrity < 0) hullShieldIntegrity = 0;
		} else {
			super.hurt(amount);
		}
	}

	private function manageHealth() {
		if (damage > 0.2 && damage <= 0.5) {
			// smoke
			// for (i in 0...Std.int(4 * damage)) {
			// 	stateData.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 6 + 3),
			// 		NParticleEmitter.velocitySpread(90),
			// 	NColorUtil.randCol(0.3, 0.3, 0.3, 0.05), 1.8);
			// }
		} else if (damage > 0.5 && damage <= 0.7) {
			// fire
			// for (i in 0...Std.int(8 * damage)) {
			// 	stateData.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 6 + 3),
			// 		NParticleEmitter.velocitySpread(90),
			// 	NColorUtil.randCol(0.8, 0.5, 0.2, 0.2), 1.8);
			// }
		} else if (damage > 0.7) {
			// bright fire
			// for (i in 0...Std.int(12 * damage)) {
			// 	stateData.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 6 + 3),
			// 		NParticleEmitter.velocitySpread(90),
			// 	NColorUtil.randCol(0.9, 0.3, 0.2, 0.1), 2.2);
			// }
		}

		if (damage >= 1) {
			// dead!
			explode();
			destroy();
		}
	}

	private function drawSpray() {
		var particleTrailVector = FlxVector.get(velocity.x, velocity.y); // duplicate velocity vector
		particleTrailVector.rotate(FlxPoint.get(0, 0), 180);
		particleTrailVector.scale(0.7);

        // draw spray
		// for (i in 0...sprayAmount) {
		// 	stateData.lowerEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 10) + 1,
		// 		NParticleEmitter.velocitySpread(spraySpread, particleTrailVector.x, particleTrailVector.y),
		// 	NColorUtil.randCol(0.2, 0.6, 0.8, 0.2), Math.random() * 1.0);
		// }
		particleTrailVector.put();
	}

	public function explode() {
		// for (i in 0...50) {
		// 	stateData.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 10) + 1,
		// 		NParticleEmitter.velocitySpread(spraySpread, velocity.x / 4, velocity.y / 4),
		// 	NColorUtil.randCol(0.95, 0.95, 0.1, 0.05), Math.random() * 1.0);
		// }
	}

	private function keepInBounds() {
		if (wrapBounds) {
			if (x < 0) x += FlxG.width;
			if (y < 0) y += FlxG.height;
			if (x > FlxG.width) x %= FlxG.width;
			if (y > FlxG.height) y %= FlxG.height;
		} else {
			if (x < width / 2) x = width / 2;
			if (y < height / 2) y = height / 2;
			if (x > FlxG.width - width) x = FlxG.width - width;
			if (y > FlxG.height - height) y = FlxG.height - height;
		}
	}
}
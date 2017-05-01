
package sprites.boats;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.group.FlxGroup;
import flixel.effects.particles.*;

import nf4.*;
import nf4.math.*;
import nf4.util.*;
import nf4.effects.particles.*;

import ai.*;

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
	
	public var shieldPercentage(get, null):Float;

	public var healthPercentage(get, null):Float;

	public var subSprites:FlxTypedGroup<FlxSprite>;

	public var stateData:GameStateData;

	private var sprayEmitter:FlxEmitter;
		
	public var aiController:BoatAiController<Boat>;

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

		sprayEmitter = new FlxEmitter(X, Y);
		sprayEmitter.scale.set(2, 2, 10, 10);
		sprayEmitter.lifespan.set(0.1, 0.7);
		sprayEmitter.color.set(FlxColor.fromRGBFloat(0.0, 0.4, 0.6, 0.4), FlxColor.fromRGBFloat(0.4, 0.8, 1.0, 0.9));
		sprayEmitter.makeParticles(1, 1, FlxColor.WHITE, 200);

		subSprites = new FlxTypedGroup<FlxSprite>();

		aiController = new BoatAiController<Boat>(this);
	}

	override public function update(dt:Float) {
		drawSpray();
		manageHealth();
		powerShield();

		sprayEmitter.update(dt);
		subSprites.update(dt);

		// nuke dead subsprites
		subSprites.forEachDead(function (d) {
			subSprites.remove(d, true);
			d.destroy();
		});

		super.update(dt);
	}

	private function acquireTarget(SourcePoint:FlxPoint, BoatCollection:FlxTypedGroup<Boat>):Boat {
		var target:Boat = null;
		var hypot = NFMath.hypot(FlxG.width, FlxG.height);
		var minDistance = hypot * 2;
		BoatCollection.forEachAlive(function (boat) {
			var dist = boat.center.distanceTo(SourcePoint);
			if (dist < minDistance) {
				minDistance = dist;
				target = boat;
			}
		});
		return target;
	}

	override public function draw():Void {
		// draw spray below
		sprayEmitter.draw();

		super.draw();

		subSprites.draw();
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
			for (i in 0...Std.int(4 * damage)) {
				stateData.effectEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 6 + 3),
					NFParticleEmitter.velocitySpread(90),
				NFColorUtil.randCol(0.3, 0.3, 0.3, 0.05), 1.8);
			}
		} else if (damage > 0.5 && damage <= 0.7) {
			// fire
			for (i in 0...Std.int(8 * damage)) {
				stateData.effectEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 6 + 3),
					NFParticleEmitter.velocitySpread(90),
				NFColorUtil.randCol(0.8, 0.5, 0.2, 0.2), 1.8);
			}
		} else if (damage > 0.7) {
			// bright fire
			for (i in 0...Std.int(12 * damage)) {
				stateData.effectEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 6 + 3),
					NFParticleEmitter.velocitySpread(90),
				NFColorUtil.randCol(0.9, 0.3, 0.2, 0.1), 2.2);
			}
		}

		if (damage >= 1) {
			// dead!
			explode();
			kill();
		}
	}

	private function drawSpray() {
		// sprayEmitter.focusOn(this);
		sprayEmitter.x = x + width / 2;
		sprayEmitter.y = y + height / 2;

		var sprayTrailVector = FlxVector.get(velocity.x, velocity.y); // duplicate velocity vector
		sprayTrailVector.rotate(FlxPoint.get(0, 0), 180);
		sprayTrailVector.scale(0.7);
		var sprayAngle = FlxAngle.asDegrees(Math.atan(sprayTrailVector.y / sprayTrailVector.x));
		var sprayMag = sprayTrailVector.length;

		sprayEmitter.launchAngle.set(sprayAngle);
		sprayEmitter.speed.set(sprayMag * 0.8, sprayMag);

		if (sprayMag > 0) {
			if (!sprayEmitter.emitting) {
				sprayEmitter.start(false, 0.01);
			}
		} else {
			sprayEmitter.emitting = false; // stop emitting
		}

        // draw spray
		// for (i in 0...sprayAmount) {
		// 	stateData.lowerEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 10) + 1,
		// 		NFParticleEmitter.velocitySpread(spraySpread, sprayTrailVector.x, sprayTrailVector.y),
		// 	NFColorUtil.randCol(0.2, 0.6, 0.8, 0.2), Math.random() * 1.0);
		// }
		sprayTrailVector.put();
	}

	override public function explode() {
		// for (i in 0...50) {
		// 	stateData.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 10) + 1,
		// 		NFParticleEmitter.velocitySpread(spraySpread, velocity.x / 4, velocity.y / 4),
		// 	NFColorUtil.randCol(0.95, 0.95, 0.1, 0.05), Math.random() * 1.0);
		// }
		for (i in 0...50) {
			// stateData.emitter.emitParticle
			// NFColorUtil.randCol(0.95, 0.95, 0.1, 0.05)
		}
		super.explode();
	}

	override public function kill() {
		super.kill();
		sprayEmitter.kill();
		subSprites.kill();
	}

	override public function destroy() {
		sprayEmitter.destroy();
		sprayEmitter = null;

		subSprites.destroy();
		subSprites = null;

		stateData.destroy();
		stateData = null;

		aiController.destroy();
		aiController = null;

		super.destroy();
	}

	private function get_shieldPercentage():Float {
		return hullShieldIntegrity * 100 / hullShieldMax;
	}

	private function get_healthPercentage():Float {
		return health * 100 / maxHealth;
	}
}
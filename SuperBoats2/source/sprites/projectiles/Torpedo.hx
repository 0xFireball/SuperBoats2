package sprites.projectiles;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;

import nf4.NFSprite;

using nf4.math.NFMathExt;

class Torpedo extends TargetingProjectile {
	public var thrust(default, null):Float = 6;
	public var angularThrust(default, null):Float = Math.PI * 0.08;

	public function new(?X:Float = 0, ?Y:Float = 0, Target:NFSprite, Emitter:FlxEmitter) {
		super(X, Y, Emitter);
		damageFactor = 0.4;
		mass = 4400;
		target = Target;
		movementSpeed = 90;
		maxVelocity.set(600, 600);
		makeGraphic(3, 7, FlxColor.fromRGBFloat(0.6, 0.9, 0.6));
	}

	override public function update(dt:Float) {

		super.update(dt);
	}

	override private function drawSpray() {
		var particleTrailVector = velocity.toVector(); // duplicate velocity vector
		particleTrailVector.rotate(FlxPoint.weak(0, 0), 180);
		particleTrailVector.scale(0.7);
		// TODO
		particleTrailVector.put();
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
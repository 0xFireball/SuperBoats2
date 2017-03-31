package sprites.projectiles;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;

import nf4.NFSprite;

using nf4.math.NFMathExt;

class Cannonball extends Projectile {
	public function new(?X:Float = 0, ?Y:Float = 0, Target:NFSprite, Emitter:FlxEmitter) {
		super(X, Y, Emitter);
		damageFactor = 1.5;
		mass = 2200;
		target = Target;
		movementSpeed = 180;
		makeGraphic(8, 8, FlxColor.fromRGBFloat(0.6, 0.6, 0.6));
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
		// for (i in 0...15) {
		// 	stateData.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 8 + 4),
		// 		NParticleEmitter.velocitySpread(50),
		// 	NColorUtil.randCol(0.8, 0.2, 0.2, 0.2), 1.8);
		// }
		// for (i in 0...10) {
		// 	stateData.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 8 + 4),
		// 		NParticleEmitter.velocitySpread(50),
		// 	NColorUtil.randCol(0.8, 0.8, 0.2, 0.2), 1.8);
		// }
		super.explode();
	}
}
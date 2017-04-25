package sprites.projectiles;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;

import nf4.NFSprite;

using nf4.math.NFMathExt;

class Torpedo extends TargetingProjectile {
	public function new(?Owner:NFSprite, ?X:Float = 0, ?Y:Float = 0, Target:NFSprite) {
		super(Owner, X, Y, Target);
		damageFactor = 0.4;
		mass = 4400;
		thrust = 6;
		target = Target;
		movementSpeed = 90;
		angularThrust = FlxAngle.asDegrees(Math.PI * 0.08);
		maxVelocity.set(600, 600);
		makeGraphic(3, 7, FlxColor.fromRGBFloat(0.6, 0.9, 0.6));

		emitter.scale.set(1, 1, 7, 7);
		emitter.lifespan.set(0.7);
		emitter.color.set(FlxColor.fromRGBFloat(0.3, 0.3, 0.8), FlxColor.fromRGBFloat(0.5, 0.5, 1.0));
		emitter.makeParticles(1, 1, FlxColor.WHITE, 15);
	}

	override public function update(dt:Float) {

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
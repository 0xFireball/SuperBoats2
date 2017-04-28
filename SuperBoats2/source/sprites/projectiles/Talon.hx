package sprites.projectiles;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;

import nf4.NFSprite;
import nf4.util.*;
import nf4.effects.particles.*;

using nf4.math.NFMathExt;

class Talon extends TargetingProjectile {

	public function new(?Owner:NFSprite, ?X:Float = 0, ?Y:Float = 0, Target:NFSprite) {
		super(Owner, X, Y, Target);
		damageFactor = 0.4;
		mass = 1800;
		thrust = 1;
		target = Target;
		movementSpeed = 360;
		angularThrust = FlxAngle.asDegrees(Math.PI * 0.04);
		maxVelocity.set(600, 600);
		makeGraphic(6, 2, FlxColor.fromRGBFloat(0.1, 0.9, 0.9));

		emitter.maxSize = 15;
		emitter.scale.set(1, 1, 7, 7);
		emitter.lifespan.set(0.7);
		emitter.color.set(FlxColor.fromRGBFloat(0.0, 0.8, 0.8), FlxColor.fromRGBFloat(0.2, 1.0, 1.0));
		emitter.makeParticles(1, 1, FlxColor.WHITE, 15);
	}

	override public function update(dt:Float) {

		super.update(dt);
	}

	override public function explode() {
		for (i in 0...14) {
			explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 10 + 5),
				NFParticleEmitter.velocitySpread(90),
			NFColorUtil.randCol(0.8, 0.5, 0.2, 0.2), 1.8);
		}
		super.explode();
	}
}
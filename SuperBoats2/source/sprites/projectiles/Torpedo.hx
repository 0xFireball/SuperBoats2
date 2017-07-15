package sprites.projectiles;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;

import nf4.NFSprite;
import nf4.util.*;
import nf4.effects.particles.*;

using nf4.math.NFMathExt;

import sprites.boats.*;

class Torpedo extends TargetingProjectile {
	public function new(?Owner:FlxSprite, ?X:Float = 0, ?Y:Float = 0, Life:Float = 30.0, Target:Boat) {
		super(Owner, X, Y, Life, Target);
		damageFactor = 0.5;
		mass = 3800;
		thrust = 6;
		movementSpeed = 90;
		angularThrust = FlxAngle.asDegrees(Math.PI * 0.09);
		maxVelocity.set(700, 700);
		makeGraphic(3, 7, FlxColor.fromRGBFloat(0.6, 0.9, 0.6));

		emitter.maxSize = 15;
		emitter.scale.set(1, 1, 7, 7);
		emitter.lifespan.set(0.7);
		emitter.color.set(FlxColor.fromRGBFloat(0.3, 0.3, 0.8), FlxColor.fromRGBFloat(0.5, 0.5, 1.0));
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
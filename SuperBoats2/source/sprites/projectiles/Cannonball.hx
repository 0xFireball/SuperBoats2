package sprites.projectiles;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;

import nf4.NFSprite;
import nf4.util.*;
import nf4.effects.particles.*;

using nf4.math.NFMathExt;

class Cannonball extends Projectile {
	public function new(?Owner:NFSprite, ?X:Float = 0, ?Y:Float = 0, Target:NFSprite) {
		super(Owner, X, Y);
		damageFactor = 1.5;
		mass = 2200;
		target = Target;
		movementSpeed = 180;
		makeGraphic(8, 8, FlxColor.fromRGBFloat(0.6, 0.6, 0.6));

		emitter.maxSize = 15;
		emitter.scale.set(4, 4, 12, 12);
		emitter.lifespan.set(0.7);
		emitter.color.set(FlxColor.fromRGBFloat(0.4, 0.0, 0.0), FlxColor.fromRGBFloat(0.6, 0.2, 0.2));
		emitter.makeParticles(1, 1, FlxColor.WHITE, 15);
	}

	override public function update(dt:Float) {

		super.update(dt);
	}

	override public function explode() {
		trace(explosionEmitter);
		for (i in 0...15) {
			explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 8 + 4),
				NFParticleEmitter.velocitySpread(50),
			NFColorUtil.randCol(0.8, 0.2, 0.2, 0.2), 1.8);
		}
		for (i in 0...10) {
			explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 8 + 4),
				NFParticleEmitter.velocitySpread(50),
			NFColorUtil.randCol(0.8, 0.8, 0.2, 0.2), 1.8);
		}
		super.explode();
	}
}
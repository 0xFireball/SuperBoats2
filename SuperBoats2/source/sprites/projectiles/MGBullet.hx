package sprites.projectiles;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;

import nf4.NFSprite;
import nf4.util.*;
import nf4.effects.particles.*;

using nf4.math.NFMathExt;

class MGBullet extends Projectile {

	public function new(?Owner:NFSprite, ?X:Float = 0, ?Y:Float = 0, Target:NFSprite) {
		super(Owner, X, Y);
		damageFactor = 20;
		mass = 2;
		target = Target;
		movementSpeed = 500;
		maxVelocity.set(800, 800);
		makeGraphic(2, 2, FlxColor.fromRGBFloat(0.6, 0.6, 0.8));

		emitter.maxSize = 4;
		emitter.scale.set(1, 1, 2, 2);
		emitter.lifespan.set(0.2);
		emitter.color.set(FlxColor.fromRGBFloat(0.2, 0.2, 0.2), FlxColor.fromRGBFloat(0.4, 0.4, 0.4));
		emitter.makeParticles(1, 1, FlxColor.WHITE, 15);
	}

	override public function update(dt:Float) {

		super.update(dt);
	}

	override public function explode() {
		for (i in 0...2) {
			explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 3 + 1),
				NFParticleEmitter.velocitySpread(90),
			NFColorUtil.randCol(0.4, 0.4, 0.4, 0.3), 0.4);
		}
		super.explode();
	}

	// private override function onDamageDealt(dmg:Float) {
	// 	trace("mgb:" + dmg);
	// }
}
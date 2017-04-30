package sprites.projectiles;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;

import nf4.NFSprite;
import nf4.util.*;
import nf4.effects.particles.*;

using nf4.math.NFMathExt;

class MortarShell extends Projectile {

	public function new(?Owner:NFSprite, ?X:Float = 0, ?Y:Float = 0, Target:NFSprite) {
		super(Owner, X, Y);
		damageFactor = Math.random() * 10 + 2;
		mass = (Math.random() * 6400) + 2000;
		target = Target;
		movementSpeed = 80 + Math.random() * 80;
		makeGraphic(11, 11, FlxColor.fromRGBFloat(0.569, 0.678, 0.122));

		emitter.maxSize = 15;
		emitter.scale.set(4, 4, 12, 12);
		emitter.lifespan.set(0.7);
		emitter.color.set(FlxColor.fromRGBFloat(0.45, 0.6, 0.1), FlxColor.fromRGBFloat(0.6, 0.7, 0.15));
		emitter.makeParticles(1, 1, FlxColor.WHITE, 15);
	}

	override public function update(dt:Float) {

		super.update(dt);
	}

	override public function explode() {
		for (i in 0...8) {
			explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 10 + 7),
				NFParticleEmitter.velocitySpread(50),
			NFColorUtil.randCol(0.3, 0.3, 0.3, 0.1), 1.8);
		}
		for (i in 0...25) {
			explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 8 + 6),
				NFParticleEmitter.velocitySpread(50),
			NFColorUtil.randCol(0.8, 0.2, 0.2, 0.2), 1.8);
		}
		for (i in 0...16) {
			explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 8 + 6),
				NFParticleEmitter.velocitySpread(50),
			NFColorUtil.randCol(0.8, 0.8, 0.2, 0.2), 1.8);
		}
		super.explode();
	}

	private override function onDamageDealt(dmg:Float) {
		trace("mortar:" + dmg);
	}
}
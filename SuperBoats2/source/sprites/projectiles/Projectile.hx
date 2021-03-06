package sprites.projectiles;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;

import states.game.data.*;

import nf4.*;
import nf4.util.*;
import nf4.effects.particles.NFParticleEmitter;
using nf4.math.NFMathExt;

class Projectile extends NFSprite {
	public var movementSpeed:Float = 100;
	public var target:NFSprite;

	/**
	 * The deadliness of the weapon
	 * This should be changed by subclasses
	 */
	public var damageFactor:Float = 10;

	/**
	 * How much to scale the damage by.
	 * Subclasses should not change this.
	 */
	private var damageScale:Float = (1 / 24);

	public var emitter:FlxEmitter;

	public var explosionEmitter:NFParticleEmitter;

	public var owner:NFSprite;

	public var life:Float;

	public var age:Float = 0.0;

	public function new(Owner:NFSprite, X:Float = 0, Y:Float = 0, Life:Float = 30.0, ?Target:NFSprite) {
		super(X, Y);

		owner = Owner;
		target = Target;
		emitter = new FlxEmitter(X, Y);
		explosionEmitter = new NFParticleEmitter(64);
		life = Life;

		mass = 500;
	}

	override public function explode() {
		// blast explosion
		alive = false;
	}

	private function finishExplode() {
		super.explode();
	}

	public function calculateDamage():Float {
		var dmMomentum = momentum.length;
		return damageFactor * dmMomentum * damageScale;
	}

	public function hitTarget() {
		hitSprite(target);
	}

	public function hitSprite(sprite:NFSprite) {
		if (!alive) return; // dead sprites don't explode
		if (sprite == owner) return;
		// deal damage
		var damageDealt = calculateDamage();
		sprite.hurt(damageDealt);
		onDamageDealt(damageDealt);

		// apply conservation of momentum collision
		var transferredMomentum = this.velocity.toVector().scale(this.mass / sprite.mass);
		sprite.velocity.addPoint(transferredMomentum);

		// trace('dealt ${damageDealt} damage');
		// explode
		explode();
	}

	private function onDamageDealt(damage:Float) {
		// debugging override
	}

	override public function update(dt:Float) {
		if (alive) {
			drawSpray();
			age += dt;
		}

		if (age > life) {
			// silently decay
			hitBoundary();
		}

		explosionEmitter.update(dt);
		emitter.update(dt);
		if (!alive && explosionEmitter.memberCount == 0) {
			finishExplode();
		}

		super.update(dt);
	}

	override public function draw() {
		if (alive) {
			emitter.draw();
			super.draw();
		}
		explosionEmitter.draw();
	}

	private function drawSpray() {
		emitter.x = x + width / 2;
		emitter.y = y + height / 2;

		var trailVec = velocity.toVector()
			.rotate(FlxPoint.weak(0, 0), 180)
			.scale(0.7);
		var trailNg = FlxAngle.asDegrees(Math.atan(trailVec.y / trailVec.x));
		var trailMag = Math.sqrt(trailVec.x * trailVec.x + trailVec.y * trailVec.y);

		emitter.launchAngle.set(trailNg);
		emitter.speed.set(trailMag * 0.8, trailMag);

		if (!emitter.emitting) {
			emitter.start(false, (1 / 15));
		}
	}

	public function hitBoundary() {
		dismantle(); // destroy silently instead of exploding
	}

	override public function kill() {
		super.kill();

		emitter.kill();
		explosionEmitter.kill();
	}

	override public function destroy() {
		emitter.destroy();
		emitter = null;

		explosionEmitter.destroy();
		explosionEmitter = null;

		super.destroy();
	}
}
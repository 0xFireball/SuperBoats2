package sprites.projectiles;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;

import states.game.data.*;

import nf4.*;
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

	public var owner:NFSprite;

	public function new(Owner:NFSprite, X:Float = 0, Y:Float = 0) {
		super(X, Y);

		owner = Owner;
		emitter = new FlxEmitter(X, Y);
		emitter.makeParticles(1, 1, FlxColor.WHITE, 200);

		mass = 500;
	}

	override public function explode() {

		// draw pretty collision
		// TODO

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
		if (sprite == owner) return;
		// deal damage
		var damageDealt = calculateDamage();
		sprite.hurt(damageDealt);

		// apply conservation of momentum collision
		var transferredMomentum = this.velocity.toVector().scale(this.mass / target.mass);
		sprite.velocity.addPoint(transferredMomentum);

		// trace('dealt ${damageDealt} damage');
		// explode
		explode();
	}

	override public function update(dt:Float) {
		drawSpray();

		emitter.update(dt);

		super.update(dt);
	}

	override public function draw() {
		emitter.draw();
		super.draw();
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
			emitter.start(false, 0.01);
		}
	}

	public function hitBoundary() {
		dismantle(); // destroy silently instead of exploding
	}
}
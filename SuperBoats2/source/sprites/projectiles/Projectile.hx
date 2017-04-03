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

	public function new(?Owner:NFSprite, ?X:Float = 0, ?Y:Float = 0, Emitter:FlxEmitter) {
		super(X, Y);
		
		owner = Owner;
		emitter = Emitter;
		mass = 500;
	}

	public function explode() {
		// apply conservation of momentum collision
		var transferredMomentum = this.velocity.toVector().scale(this.mass / target.mass);
		target.velocity.addPoint(transferredMomentum);

		dismantle();
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
		// trace('dealt ${damageDealt} damage');
		// explode
		explode();
	}

	override public function update(dt:Float) {
		drawSpray();
		checkBounds();
		super.update(dt);
	}

	private function drawSpray() {
		// To be overriden
	}

	private function checkBounds() {
		if (x < width * 2 || y < height * 2 || x > FlxG.width + width * 2 || y > FlxG.height + height * 2) {
			dismantle();
		}
	}

	public function dismantle() {
		this.kill();
	}
}
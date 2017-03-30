package sprites.projectiles;

import flixel.util.*;
import flixel.math.*;
import flixel.*;

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

	public var stateData:GameStateData;

	public function new(?X:Float = 0, ?Y:Float = 0, StateData:GameStateData) {
		super(X, Y);

		stateData = StateData;
		mass = 500;
	}

	public function explode() {
		// apply conservation of momentum collision
		var transferredMomentum = this.velocity.toVector().scale(this.mass / target.mass);
		target.velocity.addPoint(transferredMomentum);

		this.destroy();
	}

	public function calculateDamage():Float {
		var dmMomentum = momentum.length;
		return damageFactor * dmMomentum * damageScale;
	}

	public function hitTarget() {
		hitSprite(target);
	}

	public function hitSprite(sprite:NFSprite) {
		// deal damage
		var damageDealt = calculateDamage();
		sprite.hurt(damageDealt);
		// trace('dealt ${damageDealt} damage');
		// explode
		explode();
	}

	override public function update(dt:Float) {
		checkBounds();
		super.update(dt);
	}

	private function checkBounds() {
		if (x < width * 2 || y < height * 2 || x > FlxG.width + width * 2 || y > FlxG.height + height * 2) {
			destroy();
		}
	}
}
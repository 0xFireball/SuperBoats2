package nf4.effects.particles;

import flixel.*;
import flixel.util.*;

class NFParticle extends FlxSprite {

	public var life:Float;
	public var age:Float = 0;
	public var particleColor:FlxColor;

	public function new(X:Float = 0, Y:Float = 0, PColor:FlxColor, Life:Float = 0) {
		super(X, Y);

		life = Life;
		particleColor = PColor;
	}

	public override function update(dt:Float) {
		age += dt;

		if (age >= life) {
			destroy();
		} else {
			var alpha = 1 - (age / life);
			color = FlxColor.fromRGBFloat(particleColor.red, particleColor.green, particleColor.blue, alpha);
		}

		super.update(dt);
	}
}
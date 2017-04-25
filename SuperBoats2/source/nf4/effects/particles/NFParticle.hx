package nf4.effects.particles;

import flixel.*;
import flixel.util.*;

class NFParticle extends NFSprite {

	public var life:Float;
	public var age:Float = 0;
	public var particleColor:FlxColor;

	public function new(X:Float, Y:Float, Width:Int, Height:Int, PColor:FlxColor, Life:Float) {
		super(X, Y);

		life = Life;
		particleColor = PColor;

		makeGraphic(Width, Height, PColor);
	}

	public override function update(dt:Float) {
		age += dt;

		if (age >= life) {
			kill();
		} else {
			alpha = 1 - (age / life);
		}

		super.update(dt);
	}
}
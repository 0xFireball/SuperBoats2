package sprites.effects;

import flixel.util.*;

import nf4.*;

class Epicenter extends NFSprite {

    public var life:Float = 2.0;
    public var age:Float = 0;

    public function new(X:Float, Y:Float, Color:FlxColor) {
        super(X, Y);

        color = Color;
        loadGraphic(AssetPaths.epicenter__png);
        x -= width / 2;
        y -= height / 2;
    }

    public override function update(dt:Float) {
        age += dt;

		if (age >= life) {
			kill();
		} else {
			alpha = 1 - (age / life);
            var scaleFactor = 1 + (1 - alpha) * 4;
            scale.set(scaleFactor, scaleFactor);
		}

        super.update(dt);
    }

}
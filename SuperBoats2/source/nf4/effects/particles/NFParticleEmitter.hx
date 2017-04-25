package nf4.effects.particles;

import flixel.group.FlxGroup;
import flixel.util.*;
import flixel.math.FlxPoint;

class NFParticleEmitter extends FlxGroup {

    public function new(?MaxSize:Int = 0) {
        super(MaxSize);
    }

    public function emitSquare(X:Float, Y:Float, Size:Int, Velocity:FlxPoint, PColor:FlxColor, Life:Float = 0) {
		X -= Size / 2;
		Y -= Size / 2;
		var particle = new NFParticle(X, Y, PColor, Life);
		particle.makeGraphic(Size, Size, PColor);
		emitInternal(particle, Velocity);
	}

    private function emitInternal(Particle:NFParticle, Velocity:FlxPoint) {
		Particle.velocity.x = Velocity.x;
		Particle.velocity.y = Velocity.y;
		add(Particle);
	}

}
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

	public static function velocitySpread(Radius:Float, XOffset:Float = 0, YOffset:Float = 0):NPoint {
		var theta = Math.random() * Math.PI * 2;
		var u = Math.random() + Math.random();
		var r = Radius * (u > 1 ? 2 - u : u);
		return new NPoint(Math.cos(theta) * r + XOffset, Math.sin(theta) * r + YOffset);
	}

}
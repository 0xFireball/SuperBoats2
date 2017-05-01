package sprites.boats.weapons;

import flixel.group.FlxGroup;
import flixel.math.*;

import nf4.effects.particles.*;
import nf4.util.*;

import sprites.boats.*;
import sprites.projectiles.*;

using nf4.math.NFMathExt;

class Cannon extends WeaponSystem<Cannonball> {

    private var missRange:Float = Math.PI * 1 / 8;
    
    public function new(Carrier:Boat, ReloadTime:Float, EffectEmitter:NFParticleEmitter, ProjectilesGroup:FlxTypedGroup<Projectile>) {
        super(Carrier, ReloadTime, EffectEmitter, ProjectilesGroup);
    }

    public override function fireFree(target:FlxPoint):Cannonball {
        var dist = carrier.center.toVector().subtractPoint(target);
		var dx = dist.x;
		var dy = dist.y;
        if (!canFire()) return null;
        var projectile = new Cannonball(carrier, carrier.center.x, carrier.center.y, null);
        var bulletSp = projectile.movementSpeed;
        var m = -Math.sqrt(dx * dx + dy * dy);
        var vx = dx * bulletSp / m;
        var vy = dy * bulletSp / m;
        var velVec = FlxPoint.get(vx, vy);
        // accuracy isn't perfect
        velVec.rotate(FlxPoint.weak(0, 0), Math.random() * FlxAngle.asDegrees(Math.random() * missRange * 2 - missRange));
        vx = velVec.x;
        vy = velVec.y;
        launchProjectile(projectile, vx, vy);
        return projectile;
    }
}
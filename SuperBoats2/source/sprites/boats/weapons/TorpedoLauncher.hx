package sprites.boats.weapons;

import flixel.group.FlxGroup;
import flixel.math.*;

import nf4.effects.particles.*;
import nf4.util.*;

import sprites.boats.*;
import sprites.projectiles.*;

using nf4.math.NFMathExt;

class TorpedoLauncher extends WeaponSystem<Torpedo> {

    private var missRange:Float = Math.PI * 1 / 3;
    
    public function new(Carrier:Boat, ReloadTime:Float, EffectEmitter:NFParticleEmitter, ProjectilesGroup:FlxTypedGroup<Projectile>) {
        super(Carrier, ReloadTime, EffectEmitter, ProjectilesGroup);
    }

    public override function fireFree(?targetPos:FlxPoint, ?targetBoat:Boat):Torpedo {
        if (!canFire()) return null;
        var dist = carrier.center.toVector().subtractPoint(targetBoat.center);
		var dx = dist.x;
		var dy = dist.y;
        var projectile = new Torpedo(carrier, carrier.center.x, carrier.center.y, targetBoat);
        var bulletSp = projectile.movementSpeed;
        var m = -Math.sqrt(dx * dx + dy * dy);
        var vx = dx * bulletSp / m;
        var vy = dy * bulletSp / m;
        var velVec = FlxPoint.get(vx, vy);
        // accuracy isn't perfect
        velVec.rotate(FlxPoint.weak(0, 0), Math.random() * FlxAngle.asDegrees(Math.random() * missRange * 2 - missRange));
        velVec.put();
        vx = velVec.x;
        vy = velVec.y;
        launchProjectile(projectile, vx, vy);
        return projectile;
    }
}
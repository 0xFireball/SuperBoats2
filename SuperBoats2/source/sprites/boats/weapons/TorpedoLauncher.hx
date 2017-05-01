package sprites.boats.weapons;

import flixel.group.FlxGroup;
import flixel.math.*;

import nf4.effects.particles.*;
import nf4.util.*;

import sprites.boats.*;
import sprites.projectiles.*;

using nf4.math.NFMathExt;

class TorpedoLauncher extends WeaponSystem {

    private var missRange:Float = Math.PI * 1 / 3;
    
    public function new(Carrier:Boat, ReloadTime:Float, EffectEmitter:NFParticleEmitter, ProjectilesGroup:FlxTypedGroup<Projectile>) {
        super(Carrier, ReloadTime, EffectEmitter, ProjectilesGroup);
    }

    public override function fireFree(?targetPos:FlxPoint, ?targetBoat:Boat):Torpedo {
        if (!canFire()) return null;
        if (targetPos == null) targetPos = targetBoat.center;
        var dist = carrier.center.toVector().subtractPoint(targetBoat.center);
		var dx = dist.x;
		var dy = dist.y;
        var projectile = new Torpedo(carrier, carrier.center.x, carrier.center.y, 15.0, targetBoat);
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
        velVec.put();
        // recoil
        carrier.velocity.addPoint(projectile.momentum.scale(1 / carrier.mass).negate());
        // smoke
		for (i in 0...14) {
			effectEmitter.emitSquare(carrier.center.x, carrier.center.y, 6,
				NFParticleEmitter.velocitySpread(45, vx / 4, vy / 4),
				NFColorUtil.randCol(0.5, 0.5, 0.5, 0.1), 0.8);
		}
        return projectile;
    }
}
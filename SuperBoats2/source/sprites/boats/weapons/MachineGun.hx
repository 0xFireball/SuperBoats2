package sprites.boats.weapons;

import flixel.group.FlxGroup;
import flixel.math.*;

import nf4.effects.particles.*;
import nf4.util.*;

import sprites.boats.*;
import sprites.projectiles.*;

using nf4.math.NFMathExt;

class TalonLauncher extends WeaponSystem<MGBullet> {

    private var missRange:Float = Math.PI * 1 / 3;
    
    public function new(Carrier:Boat, ReloadTime:Float, EffectEmitter:NFParticleEmitter, ProjectilesGroup:FlxTypedGroup<Projectile>) {
        super(Carrier, ReloadTime, EffectEmitter, ProjectilesGroup);
    }

    public override function fireFree(?targetPos:FlxPoint, ?targetBoat:Boat):MGBullet {
        if (!canFire()) return null;
        if (targetPos == null) targetPos = targetBoat.center;
		var bullet = new MGBullet(carrier, carrier.center.x, carrier.center.y, targetBoat);
		var bulletSpread:Float = 10;
		var tVec = bullet.center.toVector()
			.subtractPoint(targetPos)
			.rotate(FlxPoint.weak(0, 0), (180 - (bulletSpread / 2)) + (Math.random() * bulletSpread))
			.toVector().normalize().scale(bullet.movementSpeed);
		tVec.put();
		launchProjectile(bullet, tVec.x, tVec.y);
		// apply recoil
		carrier.velocity.addPoint(bullet.momentum.scale(1 / carrier.mass).negate());
        return bullet;
    }
}
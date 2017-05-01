package sprites.boats.weapons;

import flixel.group.FlxGroup;
import flixel.math.*;

import nf4.effects.particles.*;
import nf4.util.*;

import sprites.boats.*;
import sprites.projectiles.*;

using nf4.math.NFMathExt;

class Mortar extends WeaponSystem {

    private var missRange:Float = Math.PI * 1 / 3;
    
    public function new(Carrier:Boat, ReloadTime:Float, EffectEmitter:NFParticleEmitter, ProjectilesGroup:FlxTypedGroup<Projectile>) {
        super(Carrier, ReloadTime, EffectEmitter, ProjectilesGroup);
    }

    public override function fireFree(?targetPos:FlxPoint, ?targetBoat:Boat):MortarShell {
        if (!canFire()) return null;
        if (targetPos == null) targetPos = targetBoat.center;
		var firingDistance = targetPos.distanceTo(carrier.center);
		var heavyWeaponError:Float = 0.25 * firingDistance;
		var xErr = (Math.random() * heavyWeaponError * 2) - heavyWeaponError;
		var yErr = (Math.random() * heavyWeaponError * 2) - heavyWeaponError;
		targetPos = targetPos.addPoint(FlxPoint.weak(xErr, yErr));
		var mortarShell = new MortarShell(carrier, carrier.center.x, carrier.center.y, 30.0, null);
		var tVec = mortarShell.center.toVector()
			.subtractPoint(targetPos)
			.rotate(FlxPoint.weak(0, 0), 180)
			.toVector().normalize().scale(mortarShell.movementSpeed);
		launchProjectile(mortarShell, tVec.x, tVec.y);
		tVec.put();
		// apply recoil
		var mortarBlast:Float = 2.5;
		carrier.velocity.addPoint(mortarShell.momentum.scale(1 * mortarBlast / carrier.mass).negate());
        return mortarShell;
    }
}
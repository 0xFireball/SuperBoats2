package sprites.boats.weapons;

import flixel.group.FlxGroup;
import flixel.math.*;

import nf4.effects.particles.*;
import nf4.util.*;

import sprites.boats.*;
import sprites.projectiles.*;

using nf4.math.NFMathExt;

class TalonLauncher extends WeaponSystem<Talon> {

    private var missRange:Float = Math.PI * 1 / 3;
    
    public function new(Carrier:Boat, ReloadTime:Float, EffectEmitter:NFParticleEmitter, ProjectilesGroup:FlxTypedGroup<Projectile>) {
        super(Carrier, ReloadTime, EffectEmitter, ProjectilesGroup);
    }

    public override function fireFree(?targetPos:FlxPoint, ?targetBoat:Boat):Talon {
        if (!canFire()) return null;
        if (targetPos == null) targetPos = targetBoat.center;
        var talon = new Talon(carrier, carrier.center.x, carrier.center.y, targetBoat);
		// target talon
		var tVec = talon.center.toVector()
			.subtractPoint(targetPos)
			.rotate(FlxPoint.weak(0, 0), 180)
			.toVector().normalize().scale(talon.movementSpeed);
        launchProjectile(talon, tVec.x, tVec.y);
		tVec.put();
        // apply recoil
		carrier.velocity.addPoint(talon.momentum.scale(1 / carrier.mass).negate());
        // smoke
		for (i in 0...4) {
			effectEmitter.emitSquare(carrier.center.x, carrier.center.y, 6,
				NFParticleEmitter.velocitySpread(45, tVec.x / 4, tVec.y / 4),
				NFColorUtil.randCol(0.5, 0.5, 0.5, 0.1), 0.8);
		}
        return talon;
    }
}
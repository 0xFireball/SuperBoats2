package sprites.boats.weapons;

import flixel.group.FlxGroup;
import flixel.math.*;

import nf4.effects.particles.*;
import nf4.util.*;

import sprites.boats.*;
import sprites.projectiles.*;

using nf4.math.NFMathExt;

class WeaponSystem {

    private var carrier:Boat;

    private var fireTimer:Float;
    private var reloadTime:Float;
    private var effectEmitter:NFParticleEmitter;
    private var projectilesGroup:FlxTypedGroup<Projectile>;

    public function new(Carrier:Boat, ReloadTime:Float, EffectEmitter:NFParticleEmitter, ProjectilesGroup:FlxTypedGroup<Projectile>) {
        carrier = Carrier;
        reloadTime = ReloadTime;
        effectEmitter = EffectEmitter;
        projectilesGroup = ProjectilesGroup;
    }

    public function update(dt:Float) {
        fireTimer += dt;
    }

    private function canFire():Bool {
        if (fireTimer < reloadTime) return false;
        fireTimer = 0;
        return true;
    }

    public function fireFree(?targetPos:FlxPoint, ?targetBoat:Boat):Projectile {
        // Override
        return null;
    }

    public function launchProjectile(Projectile:Projectile, Vx:Float, Vy:Float) {
        projectilesGroup.add(Projectile);
        Projectile.velocity.set(Vx, Vy);
		var recoil = Projectile.momentum.scale(1 / carrier.mass).negate();
		carrier.velocity.addPoint(recoil);
    }

    public function destroy() {
        // get rid of references
        carrier = null;
        projectilesGroup = null;
        effectEmitter = null;
    }

}
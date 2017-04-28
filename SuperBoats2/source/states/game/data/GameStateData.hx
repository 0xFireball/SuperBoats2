
package states.game.data;

import sprites.boats.*;
import sprites.projectiles.*;

import flixel.group.FlxGroup;
import flixel.effects.particles.*;

import nf4.effects.particles.*;

class GameStateData {
    public var player:PlayerBoat;
    public var mothership:Mothership;
    public var allies:FlxTypedGroup<Boat>;
    public var warships:FlxTypedGroup<Boat>;
    public var projectiles:FlxTypedGroup<Projectile>;
    public var emitter:FlxEmitter;
    public var effectEmitter:NFParticleEmitter;

    public function new(?Player:PlayerBoat, ?Mothership:Mothership,
        ?WarshipsGroup:FlxTypedGroup<Boat>, ?AlliesGroup:FlxTypedGroup<Boat>, ?ProjectilesGroup:FlxTypedGroup<Projectile>,
        ?Emitter:FlxEmitter,
        ?EffectEmitter:NFParticleEmitter) {
        
        player = Player;
        mothership = Mothership;

        warships = WarshipsGroup;
        allies = AlliesGroup;

        projectiles = ProjectilesGroup;

        emitter = Emitter;
        effectEmitter = EffectEmitter;
    }

    public function destroy() {
        player = null;
        mothership = null;
        warships = null;
        allies = null;
        projectiles = null;
        emitter = null;
        effectEmitter = null;
    }
}
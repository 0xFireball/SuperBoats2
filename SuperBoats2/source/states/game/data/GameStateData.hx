
package states.game.data;

import sprites.boats.*;
import sprites.projectiles.*;

import flixel.group.FlxGroup;
import flixel.effects.particles.*;

import nf4.effects.particles.*;

class GameStateData {
    public var player:PlayerBoat;
    public var mothership:Mothership;
    public var allies:FlxTypedGroup<GreenBoat>;
    public var warships:FlxTypedGroup<Warship>;
    public var projectiles:FlxTypedGroup<Projectile>;
    public var emitter:FlxEmitter;
    public var effectEmitter:NFParticleEmitter;

    public function new(?Player:PlayerBoat, ?Mothership:Mothership,
        ?WarshipsGroup:FlxTypedGroup<Warship>, ?AlliesGroup:FlxTypedGroup<GreenBoat>, ?ProjectilesGroup:FlxTypedGroup<Projectile>,
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
}
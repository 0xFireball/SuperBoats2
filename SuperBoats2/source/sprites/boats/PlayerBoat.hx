
package sprites.boats;

import flixel.*;
import flixel.math.*;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;

import states.game.data.*;

import sprites.effects.*;

class PlayerBoat extends GreenBoat {
    public var allyCount:Int = 0;
	public var maxAllyCount:Int = 6;

	private var allySpawnFrequency:Int = 400;

    public function new(?X:Float = 0, ?Y:Float = 0, StateData:GameStateData) {
		
		super(X, Y, StateData);

		maxHealth = health = 420000;
		hullShieldMax = hullShieldIntegrity = 172000;
		hullShieldRegen = 100;
		attackTime = 0.4;
		angularThrust = FlxAngle.asDegrees(0.05 * Math.PI);
		thrust = 3.5;
		wrapBounds = false;
		mass = 28000;
		sprayAmount = 8;
        loadGraphic(AssetPaths.player_boat__png);
		offset.set(13, 3);
		setSize(16, 36);
	}

	override public function update(dt:Float) {
		spawnAllies();

		super.update(dt);
	}

	private function spawnAllies() {
		if (allyCount < maxAllyCount && Std.int(Math.random() * allySpawnFrequency) == 4) {
			// spawn ally
			++allyCount;
			var ally = new GreenBoat(Math.random() * (FlxG.width - 60) + 30, Math.random() * (FlxG.height - 60) + 30, stateData);
			stateData.allies.add(ally);
		}
	}

	public override function movement() {
		var up:Bool = false;
		var left:Bool = false;
		var right:Bool = false;
		var down:Bool = false;

		left = FlxG.keys.anyPressed([J, LEFT]);
		up = FlxG.keys.anyPressed([I, UP]);
		right = FlxG.keys.anyPressed([L, RIGHT]);
		down = FlxG.keys.anyPressed([K, DOWN]);

		var setObjective:Bool = FlxG.keys.anyPressed([C]);
		var releaseObjective:Bool = FlxG.keys.anyPressed([X]);

		if (setObjective && releaseObjective) {
			setObjective = false;
			releaseObjective = false;
		}

		// apply objective
		if (setObjective) {
			aiController.setObjective(center);
		} else if (releaseObjective) {
			aiController.setObjective(null);
		}

		if (setObjective || releaseObjective) {
			// draw epicenter
			subSprites.add(new Epicenter(center.x, center.y));
		}

		moveDefault(up,
			left,
			right,
			down);

		attacking = FlxG.keys.anyPressed([F, M]);
	}

	private override function acquireTarget(SourcePoint:FlxPoint, BoatCollection:FlxTypedGroup<Boat>):Boat {
		SourcePoint = FlxG.mouse.getPosition();
		var target = super.acquireTarget(SourcePoint, BoatCollection);
		SourcePoint.put();
		return target;
	}
}
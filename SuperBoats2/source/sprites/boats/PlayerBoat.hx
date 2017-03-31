
package sprites.boats;

import flixel.*;
import flixel.math.*;
import flixel.input.keyboard.FlxKey;

import states.game.data.*;

class PlayerBoat extends GreenBoat {
    public var allyCount:Int = 0;
	public var maxAllyCount:Int = 6;

	private var allySpawnFrequency:Int = 400;

    public function new(?X:Float = 0, ?Y:Float = 0, StateData:GameStateData) {
		
		super(X, Y, StateData);

		maxHealth = health = 220000;
		hullShieldMax = hullShieldIntegrity = 72000;
		hullShieldRegen = 100;
		attackTime = 0.7;
		angularThrust = FlxAngle.asDegrees(0.05 * Math.PI);
		thrust = 3.5;
		wrapBounds = false;
		mass = 28000;
		sprayAmount = 8;
        loadGraphic(AssetPaths.player_boat__png);
		// renderGraphic(16, 36, function (gpx) {
		// 	var ctx = gpx.g2;
		// 	ctx.begin();
		// 	ctx.color = FlxColor.fromRGBFloat(0.1, 0.3, 0.9);
		// 	ctx.fillRect(0, 0, width, height);
		// 	ctx.color = FlxColor.fromRGBFloat(0.1, 0.5, 0.9);
		// 	ctx.fillRect(width / 3, height * (3 / 4), width / 3, height / 4);
		// 	ctx.end();
		// }, "playerboat");
	}

	override public function update(dt:Float) {
		spawnAllies();

		super.update(dt);
	}

	private function spawnAllies() {
		// if (allyCount < maxAllyCount && Std.int(Math.random() * allySpawnFrequency) == 4) {
		// 	// spawn ally
		// 	++allyCount;
		// 	var ally = new GreenBoat(0, Math.random() * FlxG.height, stateData);
		// 	stateData.allies.add(ally);
		// }
	}

	override private function movement() {
		var up:Bool = false;
		var left:Bool = false;
		var right:Bool = false;
		var down:Bool = false;

		left = FlxG.keys.anyPressed([J, LEFT]);
		up = FlxG.keys.anyPressed([I, UP]);
		right = FlxG.keys.anyPressed([L, RIGHT]);
		down = FlxG.keys.anyPressed([K, DOWN]);

		moveDefault(up,
			left,
			right,
			down);

		attacking = FlxG.keys.anyPressed([F, M]);
	}
}
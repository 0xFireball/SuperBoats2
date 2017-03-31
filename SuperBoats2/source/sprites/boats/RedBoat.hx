
package sprites.boats;

import flixel.math.*;

import states.game.data.*;

class RedBoat extends Warship {
	public function new(?X:Float = 0, ?Y:Float = 0, StateData:GameStateData) {
		super(X, Y, StateData);
		maxHealth = health = 540000;
		thrust = 1.9;
		wrapBounds = false;
		mass = 79000;
		sprayAmount = 20;
		spraySpread = 80;
		angularThrust = FlxAngle.asDegrees(0.034 * Math.PI);
		maxAngular = FlxAngle.asDegrees(Math.PI / 4);
		maxVelocity.set(135, 135);
		// renderGraphic(20, 43, function (gpx) {
		// 	var ctx = gpx.g2;
		// 	ctx.begin();
		// 	ctx.color = Color.fromFloats(0.8, 0.4, 0.1);
		// 	ctx.fillRect(0, 0, width, height);
		// 	ctx.color = Color.fromFloats(0.9, 0.5, 0.1);
		// 	ctx.fillRect(width / 3, height * (3 / 4), width / 3, height / 4);
		// 	ctx.end();
		// }, "minion_warship");
	}

	override public function update(dt:Float) {
		aiController.style = damage < 0.7 ? Aggressive : Defensive;

		super.update(dt);
	}

	override public function dismantle() {
		// when destroyed, update minion count
		stateData.mothership.minionCount--;
		super.dismantle();
	}
}
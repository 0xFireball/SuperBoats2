
package sprites.boats;

import flixel.util.FlxColor;
import flixel.*;
import flixel.math.*;

import sprites.projectiles.*;

import ai.*;
import ai.BoatAiController;

import states.game.data.*;
import sprites.boats.weapons.*;

import nf4.math.NFMath;
import nf4.effects.particles.*;
import nf4.util.*;

using nf4.math.NFMathExt;

class Warship extends Boat {
	private var cannonMissRange:Float = Math.PI * 1 / 8;
	private var torpedoMissRange:Float = Math.PI * 1 / 3;
	public var aiState:BoatAiState<Boat>;
	public var lastStep:ActionState;

	public function new(?X:Float = 0, ?Y:Float = 0, StateData:GameStateData) {
		super(X, Y, StateData);

		aiState = new BoatAiState<Boat>();
		aiController.loadState(aiState);
		var hypot = NFMath.hypot(FlxG.width, FlxG.height);
		aiController.triggerRadius = hypot / 4;
		maxHealth = health = 540000;
		thrust = 1.9;
		wrapBounds = false;
		mass = 79000;
		sprayAmount = 20;
		spraySpread = 80;
		angularThrust = FlxAngle.asDegrees(0.034 * Math.PI);
		maxAngular = FlxAngle.asDegrees(Math.PI / 4);
		maxVelocity.set(135, 135);

		loadGraphic(AssetPaths.superboats2_warship__png);
		offset.set(15, 1);
		setSize(13, 40);

		createPhysicsBody();
	}

	private override function addWeapons() {
		weapons.push(new Cannon(this, 0.4 * 3, stateData.effectEmitter, stateData.projectiles));
		weapons.push(new TorpedoLauncher(this, 0.4 * 7, stateData.effectEmitter, stateData.projectiles));
	}

	override public function update(dt:Float) {
		aiController.style = damage < 0.7 ? Aggressive : Defensive;
		movement();
		attackPlayer();

		super.update(dt);
	}

	private function attackPlayer() {
		var target = acquireTarget(center, stateData.allies);
		if (target == null) return;
		weapons[0].fireFree(target);
		weapons[1].fireFree(target);
	}

	private function movement() {
		var target = acquireTarget(center, stateData.allies);
		aiState.friends = stateData.warships;
		aiState.enemies = stateData.allies;
		aiController.target = target;

		var step = aiController.step();
		lastStep = step;
		moveDefault(step.movement.thrust,
			step.movement.left,
			step.movement.right,
			step.movement.brake);
	}

	override public function dismantle() {
		// when destroyed, update minion count
		if (this != stateData.mothership) {
			stateData.mothership.minionCount--;
		}
		super.dismantle();
	}
}
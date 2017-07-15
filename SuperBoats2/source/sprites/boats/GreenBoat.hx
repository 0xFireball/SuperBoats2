
package sprites.boats;

import flixel.util.FlxColor;
import flixel.*;
import flixel.math.*;
import flixel.group.FlxGroup;
import flixel.effects.particles.*;

import sprites.projectiles.*;

import ai.*;
import ai.BoatAiController;
import sprites.boats.weapons.*;

import nf4.math.NFMath;
import nf4.effects.particles.*;
import nf4.util.*;

import states.game.data.*;

using nf4.math.NFMathExt;

class GreenBoat extends Boat {

	public var aiState:BoatAiState<Boat>;
	public var lastStep:ActionState;

	public var attacking1:Bool = false;
	public var attacking2:Bool = false;
	public var attacking3:Bool = false;

    public function new(?X:Float = 0, ?Y:Float = 0, StateData:GameStateData) {
		super(X, Y, StateData);

		aiState = new BoatAiState<Boat>();
		aiState.leader = StateData.player;
		aiController.loadState(aiState);
		aiState.friends = stateData.allies;
		aiState.enemies = stateData.warships;

		var hypot = NFMath.hypot(FlxG.width, FlxG.height);
		aiController.triggerRadius = hypot / 4;
		maxHealth = health = 290000;
		hullShieldMax = hullShieldIntegrity = 157000;
		hullShieldRegen = 140;
		angularThrust = FlxAngle.asDegrees(0.07 * Math.PI);
		thrust = 3.5;
		wrapBounds = false;
		mass = 42000;
		maxVelocity.set(240, 240);
		sprayAmount = 8;
		
		loadGraphic(AssetPaths.superboats2_ally__png);
		offset.set(11, 11);
		setSize(10, 30);
	}

	private override function addWeapons() {
		weapons.push(new TalonLauncher(this, 0.7, stateData.effectEmitter, stateData.projectiles));
	}

	override public function update(dt:Float) {
		aiController.style = damage < 0.7 ? Aggressive : Defensive;
		movement();

		if (attacking1) {
			autoPrimaryFire();
		}

		if (attacking2) {
			secondaryFire();
		}

		if (attacking3) {
			heavyFire();
		}

		super.update(dt);
	}

	private function movement() {
		// minion should attack

		var target = acquireTarget(center, stateData.warships);
		aiController.target = target;

		var step = aiController.step();
		lastStep = step;
		moveDefault(step.movement.thrust,
			step.movement.left,
			step.movement.right,
			step.movement.brake);

		attacking1 = lastStep.attack.anyWeapon;
	}

	public function autoPrimaryFire() {
		var target = acquireTarget(center, stateData.warships);
		if (target == null) return;
		primaryFire(target, target.center);
	}

	private function primaryFire(target:Boat, initialAim:FlxPoint) {
		weapons[0].fireFree(initialAim, target);
	}

	private function secondaryFire() {
		// override
	}

	private function heavyFire() {
		// override
	}

	override public function dismantle() {
		if (this != stateData.player) {
			stateData.player.allyCount--;
		}
		super.dismantle();
	}
}
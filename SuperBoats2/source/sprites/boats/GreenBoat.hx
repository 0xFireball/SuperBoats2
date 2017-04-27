
package sprites.boats;

import flixel.util.FlxColor;
import flixel.*;
import flixel.math.*;
import flixel.group.FlxGroup;
import flixel.effects.particles.*;

import sprites.projectiles.*;

import ai.*;
import ai.BoatAiController;

import nf4.math.NFMath;
import nf4.effects.particles.*;
import nf4.util.*;

import states.game.data.*;

using nf4.math.NFMathExt;

class GreenBoat extends Boat {
    private var attackTime:Float = 1.0;
	private var attackTimer:Float = 0;
	private var attackCount:Int = 0;

	public var aiState:BoatAiState<Boat>;
	public var lastStep:ActionState;
	public var attacking:Bool = false;

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
		hullShieldRegen = 120;
		attackTime = 0.7;
		angularThrust = FlxAngle.asDegrees(0.05 * Math.PI);
		thrust = 3.5;
		wrapBounds = false;
		mass = 26000;
		maxVelocity.set(200, 200);
		sprayAmount = 8;
		// renderGraphic(14, 32, function (gpx) {
		// 	var ctx = gpx.g2;
		// 	ctx.begin();
		// 	ctx.color = FlxColor.fromRGBFloat(0.1, 0.9, 0.3);
		// 	ctx.fillRect(0, 0, width, height);
		// 	ctx.color = FlxColor.fromRGBFloat(0.1, 0.9, 0.5);
		// 	ctx.fillRect(width / 3, height * (3 / 4), width / 3, height / 4);
		// 	ctx.end();
		// }, "greenboat");
		makeGraphic(14, 32, FlxColor.fromRGBFloat(0.1, 0.9, 0.5));
	}

	override public function update(dt:Float) {
		aiController.style = damage < 0.7 ? Aggressive : Defensive;
		movement();

		attackTimer += dt;
		if (attackTimer > attackTime && attacking) {
			autoFire();
			++attackCount;
			attackTimer = 0;
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

		attacking = lastStep.attack.anyWeapon;
	}

	public function autoFire() {
		var target = acquireTarget(center, stateData.warships);
		if (target == null) return;
		var fTalon = new Talon(this, center.x, center.y, target);
		// target talon
		var tVec = fTalon.center.toVector()
			.subtractPoint(target.center)
			.rotate(FlxPoint.weak(0, 0), 180)
			.toVector().normalize().scale(fTalon.movementSpeed);
		fTalon.velocity.set(tVec.x, tVec.y);
		tVec.put();
		// apply recoil
		velocity.addPoint(fTalon.momentum.scale(1 / mass).negate());
		stateData.projectiles.add(fTalon);
		// smoke
		for (i in 0...4) {
			stateData.effectEmitter.emitSquare(center.x, center.y, 6,
				NFParticleEmitter.velocitySpread(45, tVec.x / 4, tVec.y / 4),
				NFColorUtil.randCol(0.5, 0.5, 0.5, 0.1), 0.8);
		}
	}

	override public function dismantle() {
		if (this != stateData.player) {
			stateData.player.allyCount--;
		}
		super.dismantle();
	}
}
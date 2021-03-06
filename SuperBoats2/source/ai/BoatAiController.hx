package ai;

import flixel.*;
import flixel.math.*;
import nf4.*;

import sprites.boats.*;

using nf4.math.NFMathExt;

class BoatAiController<T:Boat> {
	public var triggerRadius:Float = 150.0;
	public var style:Style = Passive;
	public var me:NFSprite;
	public var target:NFSprite;

	public var state(default, null):BoatAiState<T>;

	public function new(Me:Boat) {
		me = Me;
	}

	public function loadState(State:BoatAiState<T>) {
		state = State;
	}

	public function setObjective(Objective:FlxPoint) {
		state.objective = Objective;
		var amLeader = state.leader == me;
		if (amLeader) {
			// i'm the leader, set the objective for everyone else too
			state.friends.forEachAlive(function (f) {
				if (f != me) {
					f.aiController.setObjective(Objective);
				}
			});
		}
	}

	public function step():ActionState {
		var result = new ActionState();

		var left = false;
		var up = false;
		var right = false;
		var down = false;
		// forward is in the direction the boat is pointing
		var facingAngle = FlxAngle.asRadians(me.angle); // facing upward
		var selfPosition = FlxVector.get(me.x, me.y);

		// process AI logic
		// if going near the edge, point to the center
		var chaseRadius = triggerRadius;
		var targetSetpoint:FlxVector = null;
		if (target != null) {
			var targetPos = target.center.toVector();
			// follow leader commands
			var hasLeader = state.leader != null && state.leader != me;
			if (hasLeader && state.objective != null) {
				// go to leader objective
				if ((selfPosition.distanceTo(state.objective) > chaseRadius)) {
					// set goal to travel to objective
					targetSetpoint = FlxVector.get(state.objective.x, state.objective.y);
				}
			} else {
				// no objective, or no leader
				if (style == Aggressive || style == Passive) {
					if ((selfPosition.distanceTo(targetPos) > chaseRadius)) {
						targetSetpoint = targetPos;
					}
				} else if (style == Defensive) {
					if ((selfPosition.distanceTo(targetPos) < chaseRadius)) {
						var awayPos = selfPosition.subtractPoint(targetPos);
						targetSetpoint = awayPos.toVector();
						awayPos.putWeak();
					}
				}
			}
		} else if (me.x < FlxG.width / 4 || me.x > FlxG.width * (3 / 4)
			|| me.y < FlxG.height / 4 || me.y > FlxG.height * (3 / 4)) {
			targetSetpoint = FlxVector.get(FlxG.width / 2, FlxG.height / 2);
		}

		selfPosition.put();

		if (targetSetpoint != null) {
			var distToTarget = new FlxVector(me.x, me.y).subtractNew(targetSetpoint);
			// create an angle from the current position to the center
			var angleToSetpoint = FlxAngle.asRadians(new FlxVector(me.x, me.y).angleBetween(targetSetpoint));
			if (style == Defensive) {
				// if defensive, go the opposite way
				angleToSetpoint += Math.PI;	
			}
			if (Math.abs(facingAngle - angleToSetpoint) > Math.PI / 8) {
				if (facingAngle < angleToSetpoint) {
					right = true;
				} else if (facingAngle > angleToSetpoint) {
					left = true;
				}
			} else {
				// we're on target
				if (style == Aggressive) {
					up = true;
				} else if (style == Passive && distToTarget.length > chaseRadius * (2 / 3)) {
					up = true;
				} else if (style == Defensive && distToTarget.length > chaseRadius * (4 / 3)) {
					up = true;
				}
			}
			targetSetpoint.put();
		}

		// make sure it's clear to shoot
		// TODO
		result.attack.lightWeapon = true;
		// result.attack.heavyWeapon = true;

		result.movement.thrust = up;
		result.movement.brake = down;
		result.movement.left = left;
		result.movement.right = right;

		return result;
	}

	public function destroy() {
		me = null;
		target = null;

		state.destroy();
		state = null;
	}
}

enum Style {
	Passive;
	Aggressive;
	Defensive;
}

class ActionState {
	public function new() {}
	public var movement:MovementState = new MovementState();
	public var attack:AttackState = new AttackState();
}

class MovementState {
	public function new() {}
	public var brake:Bool;
	public var thrust:Bool;
	public var left:Bool;
	public var right:Bool;
}

class AttackState {
	public function new() {}
	public var lightWeapon:Bool;
	public var heavyWeapon:Bool;
	public var anyWeapon(get, null):Bool;

	private function get_anyWeapon() {
		return lightWeapon || heavyWeapon;
	}
}
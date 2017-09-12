package sprites.boats;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

import states.game.data.*;
import sprites.boats.weapons.*;

import nf4.math.*;

class Mothership extends Warship {

	private var minionSpawnChance = 720;
	public var minionCount:Int = 0;
	public var maxMinionCount:Int = 2;

	private var minionDelay:Float = 0.44;

	public function new(?X:Float = 0, ?Y:Float = 0, StateData:GameStateData) {
		super(X, Y, StateData);
		maxHealth = health = 2350000;
		thrust = 0.6;
		wrapBounds = false;
		mass = 234000;
		sprayAmount = 20;
		spraySpread = 80;
		angularThrust = FlxAngle.asDegrees(0.03 * Math.PI);
		maxAngular = FlxAngle.asDegrees(Math.PI / 5);
		maxVelocity.set(60, 60);
		
		if (Registry.gameLevel > 0) {
			var lvl = Registry.gameLevel;
			health *= 1.8 * Math.pow(1.1, lvl);
			minionDelay *= (1 / Math.pow(4, lvl));
			maxMinionCount += Math.ceil(Math.pow(1.6, lvl));
			minionSpawnChance = Std.int(minionSpawnChance / (lvl + 1));
			maxHealth = health;
			hullShieldMax = hullShieldIntegrity = 180000 * Math.pow(1.02, lvl);
			hullShieldRegen = 2 + (lvl - 1) * 2;
		}

		loadGraphic("assets/images/sprites/mothership.png");
		setSize(20, 60);
		offset.set(22, 2);
	}

	private override function addWeapons() {
		weapons.push(new Cannon(this, 0.2 * 3, stateData.effectEmitter, stateData.projectiles));
		weapons.push(new TorpedoLauncher(this, 0.2 * 7, stateData.effectEmitter, stateData.projectiles));
	}

	override public function update(dt:Float) {
		if (damage > minionDelay && minionCount < maxMinionCount && Std.int(Math.random() * minionSpawnChance) == 4) {
			minionCount++;
			var hypot = NFMath.hypot(FlxG.width, FlxG.height);
			var minionDist = hypot / 4;
			var minion = new Warship(center.x + Math.random() * minionDist, center.y + Math.random() * minionDist, stateData);
			var minionEdge = 40;
			if (minion.x < minionEdge) minion.x = minionEdge;
			if (minion.x > FlxG.width - minion.width) minion.x = FlxG.width - minion.width - minionEdge;
			if (minion.y < minionEdge) minion.y = minionEdge;
			if (minion.y > FlxG.height - minion.height) minion.y = FlxG.height - minion.height - minionEdge;
			minion.velocity.set(Math.random() * 100, Math.random() * 100);
			stateData.warships.add(minion);
		}

		super.update(dt);
	}
}
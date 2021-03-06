package ai;

import flixel.group.FlxGroup;
import flixel.math.*;

import sprites.boats.*;

class BoatAiState<T:Boat> {
	public function new() {}
	public var friends:FlxTypedGroup<T>;
	public var enemies:FlxTypedGroup<T>;
	
	// smart grouping
	public var leader:T; // optional, stores a leader
	public var objective:FlxPoint;

	public function destroy() {
		if (objective != null) {
			objective.put();
			objective = null;
		}

		friends = null;
		enemies = null;
		leader = null;
	}
}
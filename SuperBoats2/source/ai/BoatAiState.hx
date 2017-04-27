package ai;

import flixel.group.FlxGroup;

import sprites.boats.*;

class BoatAiState<T:Boat> {
	public function new() {}
	public var friends:FlxTypedGroup<T>;
	public var enemies:FlxTypedGroup<T>;
}
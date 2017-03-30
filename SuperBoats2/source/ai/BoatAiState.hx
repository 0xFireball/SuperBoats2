package ai;

import flixel.*;
import flixel.group.FlxGroup;
import nf4.*;

class BoatAiState<T1:FlxSprite, T2:NFSprite> {
	public function new() {}
	public var friends:FlxTypedGroup<T1>;
	public var enemies:FlxTypedGroup<T2>;
}
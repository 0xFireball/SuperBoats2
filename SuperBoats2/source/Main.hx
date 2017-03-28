package;

import flixel.FlxGame;
import openfl.display.Sprite;
import intro.FFIntroState;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, FFIntroState));
	}
}

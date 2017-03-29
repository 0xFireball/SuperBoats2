package states;

import flixel.*;
import flixel.util.*;
import flixel.tweens.*;
import flixel.effects.particles.*;
import ui.*;

class MenuState extends FlxState
{
	private var titleTx:NFText;
	
	private var emitter:FlxEmitter;

	override public function create():Void
	{
		titleTx = new NFText(0, 0, "SuperBoats 2", 84);
		titleTx.color = FlxColor.WHITE;
		titleTx.screenCenter(FlxAxes.X);
		titleTx.y = -titleTx.height;
		FlxTween.tween(titleTx, { y: 200 }, 0.7, { ease: FlxEase.cubeOut });
		add(titleTx);

		emitter = new FlxEmitter(FlxG.width / 2, titleTx.y + titleTx.height / 2);
		emitter.lifespan.set(0.6);
		emitter.scale.set(1, 1, 4, 4, 6, 6, 6, 6);
		emitter.makeParticles(1, 1, FlxColor.WHITE, 200);
		// start emitter
		emitter.start(false, 0.005);
		emitter.velocity.set(-140, -140, 140, 140);
		emitter.color.set(FlxColor.fromRGBFloat(0.0, 0.4, 0.6), FlxColor.fromRGBFloat(0.4, 0.8, 1.0));
		add(emitter);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

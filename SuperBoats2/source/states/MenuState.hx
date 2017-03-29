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
		var titleFinalY = 180;
		FlxTween.tween(titleTx, { y: titleFinalY }, 0.7, { ease: FlxEase.cubeOut });

		emitter = new FlxEmitter(FlxG.width / 2, titleFinalY + titleTx.height * 1.2);
		emitter.lifespan.set(0.4);
		emitter.scale.set(2, 2, 8, 8, 12, 12, 12, 12);
		emitter.makeParticles(1, 1, FlxColor.WHITE, 200);
		// start emitter
		emitter.start(false, 0.003);
		emitter.speed.set(120, 280);
		emitter.color.set(FlxColor.fromRGBFloat(0.0, 0.4, 0.6), FlxColor.fromRGBFloat(0.4, 0.8, 1.0));
		add(emitter);
		add(titleTx); // add title after emitter

		var credits = new NFText(40, 0, "PetaPhaser", 60);
		credits.y = FlxG.height - credits.height * 1.2;
		add(credits);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

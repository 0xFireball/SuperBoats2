package intro;

import flixel.*;
import flixel.util.*;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import states.*;

/**
 * ...
 * @author ...
 */
class FFIntroState extends FlxState
{
	private var cover:FFLogo;
	
	private var introLength:Float = 2.0;

	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end

		bgColor = FlxColor.fromInt(0xFF111111);
		
		cover = new FFLogo();
		// cover.scaleFactor = FlxG.stage.stageWidth / cover.width;
		cover.screenCenter(FlxAxes.XY);
		cover.alpha = 0;
		add(cover);

		FlxG.camera.fade(FlxColor.fromInt(0xFF555555), 0.2, true);
		FlxTween.tween(cover, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadIn });

		// play chime
		FlxG.sound.play(AssetPaths.petaphaser_chime__ogg, 1.0, false);
		
		super.create();
	}

	public override function update(elapsed:Float) {
		FlxTween.tween(cover, { scaleFactor: 1.2, alpha: 0 }, 0.4, {
			ease: FlxEase.cubeOut,
			startDelay: introLength,
			onComplete: function (t) {
				switchToGame();
			}
		});

		#if debug
		// Enable quickly skipping intro
		if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
			switchToGame();
		}
		#end

		super.update(elapsed);
	}
	
	private function switchToGame() {
		FlxG.switchState(new MenuState());
	}
}
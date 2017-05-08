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
	private var _ffLogo:FFLogo;
	private var _t:Float = 0;
	private var anim1:Bool = false;

	private var animDone:Bool = false;
	private var chimeDone:Bool = false;	

	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end

		bgColor = FlxColor.fromInt(0xFF111111);
		
		_ffLogo = new FFLogo();
		_ffLogo.scaleFactor = FlxG.stage.stageWidth / _ffLogo.width;
		_ffLogo.screenCenter(FlxAxes.XY);
		_ffLogo.alpha = 0;
		add(_ffLogo);

		FlxG.camera.fade(FlxColor.fromInt(0xFF555555), 0.2, true);
		FlxTween.tween(_ffLogo, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadIn });

		// play chime
		FlxG.sound.play(AssetPaths.petaphaser_chime__ogg, 1.0, false, true, function() {
			chimeDone = true;
		});
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		_t += elapsed;
		if (_t > (60 / FlxG.updateFramerate) && !anim1)
		{
			anim1 = true;
			FlxTween.tween(_ffLogo, { alpha: 0, scaleFactor: 3 }, 1.2, { ease: FlxEase.cubeOut, onComplete: function(t) { animDone = true; }, type: FlxTween.ONESHOT});
		}
		if (animDone && chimeDone) {
			switchToGameIcon();
		}

		super.update(elapsed);
	}
	
	private function switchToGameIcon():Void
	{
		FlxG.switchState(new MenuState());
	}
}
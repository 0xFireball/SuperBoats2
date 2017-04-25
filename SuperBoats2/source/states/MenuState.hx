package states;

import flixel.*;
import flixel.ui.*;
import flixel.util.*;
import flixel.tweens.*;
import flixel.effects.particles.*;
import flixel.addons.effects.chainable.*;

import states.game.PlayState;

import nf4.ui.*;

class MenuState extends FlxState
{
	private var titleTx:NFText;
	
	private var emitter:FlxEmitter;

	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.load("images/mouse.png");
		#end

		bgColor = FlxColor.fromInt(0x0B2B36);

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

		var credits = new NFText(32, 0, "PetaPhaser", 48);
		credits.y = FlxG.height - (credits.height + 32);
		add(credits);

		var playBtn = new FlxButton(0, 350, "Play", onClickPlay);
		playBtn.screenCenter(FlxAxes.X);
		add(playBtn);

		FlxTween.color(credits, 0.9, FlxColor.fromRGBFloat(0.8, 0.1, 0.1), FlxColor.fromRGBFloat(0.98, 0.98, 0.98), { startDelay: 0.6, ease: FlxEase.cubeInOut });

		FlxG.camera.shake(0.01, 0.5);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	private function onClickPlay() {
		// TODO
		var waveFct = new FlxWaveEffect();
		var distortedTitle = new FlxEffectSprite(titleTx, [ waveFct ]);
		distortedTitle.setPosition(titleTx.x, titleTx.y);
		add(distortedTitle);
		FlxTween.tween(titleTx, { alpha: 0 }, 0.4, { onComplete: function (t) {
			remove(titleTx);
		}});
		FlxTween.tween(distortedTitle, { alpha: 1 }, 0.4, { onComplete: function (t) {
			// switch
			FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function () {
				FlxG.switchState(new PlayState());
			});
		}});
	}
}

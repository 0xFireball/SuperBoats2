package states.game;

import flixel.*;
import flixel.ui.*;
import flixel.util.*;
import flixel.tweens.*;
import flixel.effects.particles.*;
import flixel.addons.effects.chainable.*;

import states.game.PlayState;

import nf4.ui.*;
import nf4.effects.particles.*;
import nf4.util.*;

class GameOverState extends FlxState {

    public var effectEmitter:NFParticleEmitter;
    public var progress:Float;

    public function new(Progress:Float) {
        progress = Progress;
        super();
    }

    public override function create() {
        var titleTx = new NFText(0, 180, "SuperBoats 2", 84);
		titleTx.color = FlxColor.WHITE;
		titleTx.screenCenter(FlxAxes.X);
        add(titleTx);

        effectEmitter = new NFParticleEmitter(200);
        add(effectEmitter);

        var tt2 = new NFText(0, FlxG.height * 0.65, "mothership health: " + Std.int((1 - progress) * 100) + "%", 32);
		tt2.screenCenter(FlxAxes.X);
		add(tt2);

        var playBtn = new FlxButton(0, 650, "Return", onClickReturn);
		playBtn.screenCenter(FlxAxes.X);
		add(playBtn);

        super.create();
    }

    public override function update(dt:Float) {
        // bright fire
		for (i in 0...12) {
			effectEmitter.emitSquare(FlxG.width / 2, FlxG.height / 2, Std.int(Math.random() * 6 + 3),
				NFParticleEmitter.velocitySpread(120),
			NFColorUtil.randCol(0.9, 0.3, 0.2, 0.1), 2.2);
		}

        super.update(elapsed);
    }

    private function onClickReturn() {
        FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function () {
            FlxG.switchState(new MenuState());
        });
    }

}
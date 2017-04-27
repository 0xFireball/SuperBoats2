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

class YouWonState extends FlxState {

    public var effectEmitter:NFParticleEmitter;

    public override function create() {
        #if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end

        var titleTx = new NFText(0, 180, "SuperBoats 2", 84);
		titleTx.color = FlxColor.WHITE;
		titleTx.screenCenter(FlxAxes.X);
        add(titleTx);

        effectEmitter = new NFParticleEmitter(200);
        add(effectEmitter);

        var tt2 = new NFText(0, FlxG.height * 0.65, "you won. level " + Registry.gameLevel + " complete.", 32);
		tt2.screenCenter(FlxAxes.X);
		add(tt2);

        var menuBtn = new NFButton(0, 500, "Exit to Menu", onReturnToMenu);
		menuBtn.screenCenter(FlxAxes.X);
		add(menuBtn);

        var replayBtn = new NFButton(0, 600, "Replay", onClickReplay);
		replayBtn.screenCenter(FlxAxes.X);
		add(replayBtn);

        var nextLevelBtn = new NFButton(0, 700, "Next Level", onClickNextLv);
		nextLevelBtn.screenCenter(FlxAxes.X);
		add(nextLevelBtn);

        super.create();
    }

    public override function update(dt:Float) {
        // bright fire
		for (i in 0...12) {
			effectEmitter.emitSquare(FlxG.width / 2, FlxG.height / 2, Std.int(Math.random() * 6 + 3),
				NFParticleEmitter.velocitySpread(220),
			NFColorUtil.randCol(0.2, 0.9, 0.2, 0.1), 2.2);
		}

        super.update(dt);
    }

    private function onClickReplay() {
        FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function () {
            FlxG.switchState(new PlayState());
        });
    }

    private function onClickNextLv() {
        // increase the difficulty
        Registry.gameLevel++;
        FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function () {
            FlxG.switchState(new PlayState());
        });
    }

    private function onReturnToMenu() {
        // return to menu
        FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function () {
            FlxG.switchState(new MenuState());
        });
        this.close();
    }

}
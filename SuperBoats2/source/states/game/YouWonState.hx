package states.game;

import flixel.*;
import flixel.ui.*;
import flixel.util.*;
import flixel.tweens.*;
import flixel.effects.particles.*;
import flixel.addons.effects.chainable.*;

import states.game.*;

import nf4.ui.*;
import nf4.effects.particles.*;
import nf4.util.*;

import ui.*;

class YouWonState extends FlxState {

    public var effectEmitter:NFParticleEmitter;

    private var nextLevel:Int;

    private var navalWar:Bool;

    public function new(NavalWar:Bool = false) {
        super();

        navalWar = NavalWar;
    }

    public override function create() {
        #if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end

        var titleTx = new SBNFText(0, 180, "SuperBoats 2", 84);
		titleTx.color = FlxColor.WHITE;
		titleTx.screenCenter(FlxAxes.X);
        add(titleTx);

        effectEmitter = new NFParticleEmitter(200);
        add(effectEmitter);

        var tt2 = new SBNFText(0, FlxG.height * 0.65, "you won. level " + Registry.gameLevel + " complete.", 32);
		tt2.screenCenter(FlxAxes.X);
		add(tt2);

        var menuBtn = new SBNFButton(0, 580, "Menu", onReturnToMenu);
		menuBtn.screenCenter(FlxAxes.X);
		add(menuBtn);

        var replayBtn = new SBNFButton(0, 640, "Replay", onClickReplay);
		replayBtn.screenCenter(FlxAxes.X);
		add(replayBtn);

        var nextLevelBtn = new SBNFButton(0, 700, "Next Level", onClickNextLv);
		nextLevelBtn.screenCenter(FlxAxes.X);
		add(nextLevelBtn);

        nextLevel = Registry.gameLevel + 1;

        super.create();
    }

    public override function update(dt:Float) {
        // bright fire
		for (i in 0...12) {
			effectEmitter.emitSquare(FlxG.width / 2, FlxG.height / 2, Std.int(Math.random() * 6 + 3),
				NFParticleEmitter.velocitySpread(220),
			NFColorUtil.randCol(0.2, 0.9, 0.2, 0.1), 2.2);
		}

        // hotkeys
        #if !FLX_NO_KEYBOARD
		if (FlxG.keys.anyJustPressed([ ENTER ])) {
			onClickNextLv();
		}
        if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
			onReturnToMenu();
		}
        #end

        super.update(dt);
    }

    private function onClickReplay() {
        FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function () {
            if (navalWar) {
                FlxG.switchState(new WarPlayState());
            } else {
                FlxG.switchState(new ClassicPlayState());
            }
        });
    }

    private function onClickNextLv() {
        // increase the difficulty
        Registry.gameLevel = nextLevel;
        onClickReplay(); // replay just reloads play, but we updated level
    }

    private function onReturnToMenu() {
        // return to menu
        FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function () {
            FlxG.switchState(new MenuState());
        });
    }

}
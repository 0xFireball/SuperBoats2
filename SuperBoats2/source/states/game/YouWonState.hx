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
import ui.menu.*;

class YouWonState extends SBNFMenuState {

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

        var tt2 = new SBNFText(0, 340, "you won. level " + Registry.gameLevel + " complete.", 32);
		tt2.screenCenter(FlxAxes.X);
		add(tt2);

        // set up menu
		menuGroup.updatePosition(FlxG.width / 2, 500);
        menuGroup.itemMargin = 12;
        menuWidth = 240;
        menuItemTextSize = 32;

		menuItems.push({
            text: "Menu",
            callback: onReturnToMenu
        });

		menuItems.push({
            text: "Replay",
            callback: onClickReplay
        });

        menuItems.push({
            text: "Next Level",
            callback: onClickNextLv
        });

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